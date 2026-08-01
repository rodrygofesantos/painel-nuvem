# Executa a validação completa do laboratório em ambiente local:
# instala dependências, roda os testes, sobe a aplicação sem contêiner,
# consulta /healthz, constrói a imagem Docker, executa o contêiner,
# consulta a aplicação containerizada e encerra tudo ao final.

$ErrorActionPreference = "Stop"

$Imagem = "painel-nuvem:v1.0"
$Container = "painel-nuvem-validacao"
$Porta = 3000

$processoLocal = $null

function Limpar {
    Write-Host ""
    Write-Host "Limpando processos e conteineres de validacao..."

    if ($null -ne $processoLocal -and -not $processoLocal.HasExited) {
        Stop-Process -Id $processoLocal.Id -Force -ErrorAction SilentlyContinue
    }

    docker rm -f $Container *> $null
}

try {
    Write-Host "1) Instalando dependencias (npm ci)..."
    npm ci
    if ($LASTEXITCODE -ne 0) { throw "Falha no npm ci" }

    Write-Host ""
    Write-Host "2) Executando testes automatizados (npm test)..."
    npm test
    if ($LASTEXITCODE -ne 0) { throw "Falha nos testes" }

    Write-Host ""
    Write-Host "3) Iniciando a aplicacao localmente (sem conteiner)..."
    $env:PORT = "$Porta"
    $processoLocal = Start-Process -FilePath "npm" -ArgumentList "start" -PassThru -WindowStyle Hidden

    Write-Host "   Aguardando a aplicacao responder em /healthz..."
    $sucesso = $false
    for ($tentativa = 0; $tentativa -lt 20; $tentativa++) {
        try {
            $resposta = Invoke-WebRequest -Uri "http://localhost:$Porta/healthz" -UseBasicParsing -TimeoutSec 2
            if ($resposta.StatusCode -eq 200) {
                $sucesso = $true
                break
            }
        } catch {
            Start-Sleep -Milliseconds 500
        }
    }

    if ($sucesso) {
        Write-Host "   OK: /healthz respondeu com sucesso (execucao local)."
    } else {
        throw "/healthz nao respondeu a tempo (execucao local)"
    }

    Stop-Process -Id $processoLocal.Id -Force -ErrorAction SilentlyContinue
    $processoLocal = $null

    Write-Host ""
    Write-Host "4) Construindo a imagem Docker ($Imagem)..."
    docker build -t $Imagem .
    if ($LASTEXITCODE -ne 0) { throw "Falha no docker build" }

    Write-Host ""
    Write-Host "5) Executando o conteiner de validacao..."
    docker run --rm -d --name $Container -p "${Porta}:3000" $Imagem | Out-Null

    Write-Host "   Aguardando o conteiner responder em /healthz..."
    $sucesso = $false
    for ($tentativa = 0; $tentativa -lt 20; $tentativa++) {
        try {
            $resposta = Invoke-WebRequest -Uri "http://localhost:$Porta/healthz" -UseBasicParsing -TimeoutSec 2
            if ($resposta.StatusCode -eq 200) {
                $sucesso = $true
                break
            }
        } catch {
            Start-Sleep -Milliseconds 500
        }
    }

    if ($sucesso) {
        Write-Host "   OK: /healthz respondeu com sucesso (conteiner)."
    } else {
        docker logs $Container
        throw "/healthz nao respondeu a tempo (conteiner)"
    }

    Write-Host ""
    Write-Host "Validacao local concluida com sucesso!" -ForegroundColor Green
} finally {
    Limpar
}
