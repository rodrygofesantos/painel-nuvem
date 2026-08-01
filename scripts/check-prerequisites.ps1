# Verifica se as ferramentas necessárias para o laboratório estão instaladas.
# Este script apenas verifica e orienta: ele NÃO instala nada automaticamente.

$ErrorActionPreference = "SilentlyContinue"
$algumErro = $false

function Verificar-Comando {
    param(
        [string]$Nome,
        [string]$Comando,
        [string[]]$ArgumentosVersao,
        [string]$DicaInstalacao
    )

    $existe = Get-Command $Comando -ErrorAction SilentlyContinue
    if ($existe) {
        $versao = & $Comando @ArgumentosVersao 2>&1 | Select-Object -First 1
        Write-Host "[OK] $Nome encontrado - $versao" -ForegroundColor Green
    } else {
        Write-Host "[FALTANDO] $Nome nao foi encontrado." -ForegroundColor Red
        Write-Host "           Sugestao: $DicaInstalacao" -ForegroundColor Yellow
        $script:algumErro = $true
    }
}

Write-Host "Verificando pre-requisitos do laboratorio painel-nuvem..."
Write-Host ""

Verificar-Comando -Nome "Git" -Comando "git" -ArgumentosVersao @("--version") `
    -DicaInstalacao "instale em https://git-scm.com/downloads"

Verificar-Comando -Nome "Node.js" -Comando "node" -ArgumentosVersao @("--version") `
    -DicaInstalacao "instale a versao 24 em https://nodejs.org/"

Verificar-Comando -Nome "NPM" -Comando "npm" -ArgumentosVersao @("--version") `
    -DicaInstalacao "o NPM e instalado junto com o Node.js"

Verificar-Comando -Nome "Docker" -Comando "docker" -ArgumentosVersao @("--version") `
    -DicaInstalacao "instale o Docker Desktop em https://www.docker.com/products/docker-desktop/"

Verificar-Comando -Nome "Azure CLI" -Comando "az" -ArgumentosVersao @("version") `
    -DicaInstalacao "instale em https://learn.microsoft.com/cli/azure/install-azure-cli"

Verificar-Comando -Nome "kubectl" -Comando "kubectl" -ArgumentosVersao @("version", "--client") `
    -DicaInstalacao "instale em https://kubernetes.io/docs/tasks/tools/"

Write-Host ""
Write-Host "Verificando se o daemon do Docker esta em execucao..."
docker info *> $null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Docker esta em execucao." -ForegroundColor Green
} else {
    Write-Host "[FALTANDO] Docker nao esta respondendo." -ForegroundColor Red
    Write-Host "           Sugestao: abra o Docker Desktop e aguarde ele iniciar." -ForegroundColor Yellow
    $algumErro = $true
}

Write-Host ""
if (-not $algumErro) {
    Write-Host "Tudo certo! Todas as ferramentas necessarias foram encontradas." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Atencao: revise os itens marcados como FALTANDO antes de continuar." -ForegroundColor Yellow
    exit 1
}
