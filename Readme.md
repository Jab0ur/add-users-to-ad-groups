<!---
.AUTHOR Gabriel dos Santos Jabour
.VERSION 1.0
.DATE 2025-08-04
-->

# 📝 Add Users to AD Groups from Text Files

A PowerShell script to bulk-add Azure AD (or on-prem AD) users into multiple groups based on two simple text files: one listing user UPNs and another listing group names.

---

## 🌐 English

### 🔹 0. Download  
Clone this repository or download the script files manually:
```bash
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio
```

### 🔹 1. Overview  
This script (`Add-FromTxt.ps1`) reads:
- **`users.txt`** – one UserPrincipalName (UPN, e-mail) per line (e.g., `user1@domain.com`)  
- **`groups.txt`** – one AD group name per line (e.g., `Group A`)

For each UPN, it looks up the corresponding AD user and adds them to every group listed. Ideal for ad-hoc bulk membership maintenance without editing the script itself.

### 🔹 2. Prerequisites  
- **PowerShell** 5.1 or PowerShell Core  
- **ActiveDirectory** module installed (RSAT on Windows):  
  ```powershell
  Install-WindowsFeature RSAT-AD-PowerShell    # Windows Server
  # or
  Add-WindowsCapability –Online –Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"  # Windows 10/11
  ```  
- Credentials with **permission** to read AD users and modify AD group membership.  
- The script should be run **elevated** (Run as Administrator).

### 🔹 3. Files  
Place all three files in the **same folder**:

1. **Add-FromTxt.ps1**  
   ```powershell
   # The main script—no edits needed for new users/groups
   ```
2. **users.txt**  
   ```
   user1@domain.com
   user2@domain.com
   user3@domain.com
   user4@domain.com
   user5@domain.com
   ```
3. **groups.txt**  
   ```
   Group A
   Group B
   Group C
   Group D
   ```

> Lines beginning with `#` or blank lines in the text files are ignored.

### 🔹 4. Usage  

1. **Open PowerShell as Administrator** and `cd` into the folder containing the files.  
2. Execute the script:
   ```powershell
   .\Add-FromTxt.ps1
   ```  
3. Monitor the console output. You will see confirmations for each addition:
   ```
   ✅  user1@domain.com added to group 'Group A'
   ✅  user1@domain.com added to group 'Group B'
   … etc.
   ```
4. At the end:
   ```
   🏁 Process completed.
   ```
5. If a user or group is not found, a warning is displayed:
   ```
   ⚠️ User not found: someone@domain.com
   ⚠️ Group not found: NonExistentGroup
   ```

### 🔹 5. Customization  
- To change the input lists, simply edit **users.txt** and **groups.txt**—no need to open the script.  
- To add logging, wrap calls in `Start-Transcript` / `Stop-Transcript` or redirect output to a file:
  ```powershell
  .\Add-FromTxt.ps1 *>&1 | Tee-Object add-groups.log
  ```

### 🔹 6. Troubleshooting  
- **“The term ‘Get-ADUser’ is not recognized”**  
  Ensure the ActiveDirectory module is installed and imported.  
- **Permission denied**  
  Run PowerShell as Administrator and verify your account has the proper AD roles.  
- **Malformed lines** in `users.txt` or `groups.txt`  
  Remove stray whitespace or invalid characters; one entry per line.

---

## 🌐 Português

### 🔹 0. Download  
Clone este repositório ou baixe os arquivos manualmente:
```bash
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio
```

### 🔹 1. Visão Geral  
Este script (`Add-FromTxt.ps1`) lê:
- **`users.txt`** – um UserPrincipalName (UPN, e-mail) por linha (ex.: `user1@domain.com`)  
- **`groups.txt`** – um nome de grupo AD por linha (ex.: `Group A`)

Para cada UPN, busca o usuário no AD e o adiciona a cada grupo listado. Ideal para gerenciar adesões em lote sem alterar o script.

### 🔹 2. Pré-requisitos  
- **PowerShell** 5.1 ou PowerShell Core  
- Módulo **ActiveDirectory** instalado (RSAT no Windows):  
  ```powershell
  Install-WindowsFeature RSAT-AD-PowerShell    # Windows Server
  # ou
  Add-WindowsCapability –Online –Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"  # Windows 10/11
  ```  
- Credenciais com **permissão** para ler usuários e modificar associações de grupo.  
- Execute o script em **modo elevado** (Administrador).

### 🔹 3. Arquivos  
Coloque os três arquivos na **mesma pasta**:

1. **Add-FromTxt.ps1**  
   ```powershell
   # O script principal—sem necessidade de edição para novos usuários/grupos
   ```
2. **users.txt**  
   ```
   user1@domain.com
   user2@domain.com
   user3@domain.com
   user4@domain.com
   user5@domain.com
   ```
3. **groups.txt**  
   ```
   Group A
   Group B
   Group C
   Group D
   ```

> Linhas iniciadas com `#` ou em branco são ignoradas.

### 🔹 4. Uso  

1. **Abra o PowerShell como Administrador** e navegue até a pasta dos arquivos.  
2. Execute:
   ```powershell
   .\Add-FromTxt.ps1
   ```  
3. Acompanhe o console. Você verá confirmações como:
   ```
   ✅  user1@domain.com adicionado ao grupo 'Group A'
   ✅  user1@domain.com adicionado ao grupo 'Group B'
   … etc.
   ```
4. Ao final:
   ```
   🏁 Processo concluído.
   ```
5. Se um usuário ou grupo não for encontrado, haverá aviso:
   ```
   ⚠️ Usuário não encontrado: someone@domain.com
   ⚠️ Grupo não encontrado: GrupoInexistente
   ```

### 🔹 5. Customização  
- Para alterar as listas de entrada, edite **users.txt** e **groups.txt**—não é preciso mexer no script.  
- Para gerar log, use `Start-Transcript` / `Stop-Transcript` ou redirecione saída:
  ```powershell
  .\Add-FromTxt.ps1 *>&1 | Tee-Object add-groups.log
  ```

### 🔹 6. Solução de Problemas  
- **“O termo ‘Get-ADUser’ não é reconhecido”**  
  Verifique se o módulo ActiveDirectory está instalado/importado.  
- **Permissão negada**  
  Execute como Administrador e confirme se sua conta tem as funções corretas no AD.  
- **Linhas malformadas** em `users.txt` ou `groups.txt`  
  Remova espaços em branco ou caracteres inválidos; mantenha um registro por linha.  
