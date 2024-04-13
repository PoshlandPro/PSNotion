Get-ChildItem "$PSScriptRoot/public/*.ps1" | ForEach-Object { . $_ }
$Script:SecretVaultName  = "MyVault"
$Script:RootUri  = "https://api.notion.com/v1"

if ($env:NotionAPIKey) {
    Write-Warning "You have Notion API key in your environment variables (NotionAPIKey). It will be used for authentication"
    return
}

$RequiredModules = @(
    "Microsoft.PowerShell.SecretStore"
    "Microsoft.PowerShell.SecretManagement"
)
$MissingModules = @()
Foreach ($RequiredModule in $RequiredModules) {
    Try {
        $ModuleInstalled = Get-InstalledModule -name $RequiredModule -ErrorAction STOP
    }
    catch {
        $MissingModules += $RequiredModule
    }
    
}
if ($MissingModules.count -gt 0) {
    foreach ($Module in $MissingModules) {
        Write-Warning "Missing required module $Module. Please install it using command Install-Module $Module"
    }
    return
}



Try {
    if (!(Get-SecretVault -Name $SecretVaultName -ErrorAction SilentlyContinue)){
        Write-Output "You don't have registered secret vault. Now it will be regstered. Please type a main password for a new vault."
        $MainSecret = Read-Host "Vault Password" | ConvertTo-SecureString -AsPlainText -Force -ErrorAction STOP
        Set-SecretStoreConfiguration -Scope CurrentUser -Authentication None -Interaction None -Confirm:$False -Password  $MainSecret
        Register-SecretVault -Name $SecretVaultName -ModuleName Microsoft.PowerShell.SecretStore
        
        Write-Warning "No config file found. Please run New-NotionConfig comand to setup first tenant configuration and import the module again"
    }
    else {
        Try {
            $CurrentConfig = @{}   
            Get-SecretInfo | Where-Object {$_.Metadata.Module -eq "PSNotion"}  | Foreach {$CurrentConfig.Add($_.Name,(Get-Secret -Name $_.Name -Vault $_.VaultName -AsPlainText))}

            If ($CurrentConfig.Keys.count -gt 0) {
                
                $script:ActiveAccount  = $CurrentConfig.Keys.Clone() | % {If($CurrentConfig[$_] | ? {$_.Default -eq $True}){$_}}
    
                Write-Warning "Active Notion Account - $ActiveAccount"
            }else {
                Write-Warning "No config found. Please run New-NotionConfig comand to setup first tenant configuration" 
            }

        }
        catch {
            if ($_.Exception.Message -like "*The secret * was not found*") {
                Write-Warning "No config found. Please run New-ITSMTenantConfig comand to setup first tenant configuration" 
            }
            else {

                throw $_
            }
        }
    }
    
}
Catch {
    Throw "Failed to open or register secret vault. Details: $_"
}

