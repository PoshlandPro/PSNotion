function Switch-NotionConfig {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]
        $Name
    )

    Try {
        $ErrorMsg = "ERROR: Cannot read config." 
        $CurrentConfig = @{}   
        Get-SecretInfo -Vault $SecretVaultName | Where-Object {$_.Metadata.Module -eq "PSNotion"}  | Foreach {$CurrentConfig.Add($_.Name,(Get-Secret -Name $_.Name -Vault $_.VaultName -AsPlainText))}
        
        If ($CurrentConfig[$Name] -eq $Null) {
            Write-Warning "No config found with name $Name. Please run New-NotionConfig comand to setup account configuration or provide correct and existing config name"
            return
        }
        else {
            Write-Warning "Active Notion Account - $ActiveAccount"
            $script:ActiveAccount = $Name
        }


    }
    catch {
        if ($_.Exception.Message -like "The secret * was not found.") {
            $CurrentConfig = $null
        }
        else {
            Throw $_
        }
        
    }
    
}