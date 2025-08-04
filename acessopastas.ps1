<#
.SYNOPSIS
  Adiciona usuários a grupos de AD listados em arquivos TXT.
.AUTHOR Gabriel dos Santos Jabour
.VERSION 1.0
.DESCRIPTION
  Lê um arquivo de texto com UPNs (um por linha) e outro com nomes de grupos (um por linha),
  e adiciona cada usuário a cada grupo.
.PREREQUISITES
  - Módulo ActiveDirectory (RSAT) instalado.
  - Permissões de leitura de usuários e escrita em grupos no AD.
.INPUTS
  - `users.txt`: lista de UPNs, um por linha.
  - `groups.txt`: lista de nomes de grupos, um por linha.
.EXAMPLE
  # No mesmo diretório onde estão users.txt e groups.txt:
  .\Add-FromTxt.ps1
#>

# Carrega módulo do AD
Import-Module ActiveDirectory -ErrorAction Stop

# Arquivos de entrada (assume no mesmo diretório do script)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$usersFile  = Join-Path $scriptPath 'users.txt'
$groupsFile = Join-Path $scriptPath 'groups.txt'

# Lê e filtra linhas vazias ou comentadas (linhas começando com #)
$Users = Get-Content $usersFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not ($_ -like '#*') }
$Groups = Get-Content $groupsFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not ($_ -like '#*') }

if (-not $Users) {
    Write-Error "O arquivo users.txt está vazio ou não foi encontrado em $usersFile"
    exit 1
}
if (-not $Groups) {
    Write-Error "O arquivo groups.txt está vazio ou não foi encontrado em $groupsFile"
    exit 1
}

Write-Host "Iniciando adição de usuários aos grupos..." -ForegroundColor Cyan

foreach ($upn in $Users) {
    # Busca o usuário pelo UPN
    $user = Get-ADUser -Filter { UserPrincipalName -eq $upn } -ErrorAction SilentlyContinue
    if (-not $user) {
        Write-Warning "Usuário não encontrado no AD: $upn"
        continue
    }

    foreach ($groupName in $Groups) {
        # Busca o grupo pelo nome
        $group = Get-ADGroup -Filter { Name -eq $groupName } -ErrorAction SilentlyContinue
        if (-not $group) {
            Write-Warning "Grupo não encontrado no AD: $groupName"
            continue
        }

        try {
            Add-ADGroupMember -Identity $group -Members $user -ErrorAction Stop
            Write-Host "✔️  $upn adicionado ao grupo '$groupName'"
        }
        catch {
            Write-Error "❌  Falha ao adicionar $upn ao grupo '$groupName': $_"
        }
    }
}

Write-Host "Processo concluído." -ForegroundColor Green