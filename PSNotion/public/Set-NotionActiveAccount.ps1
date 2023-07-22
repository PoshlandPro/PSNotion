function Set-NotionActiveConfig {
    [CmdletBinding()]
    param (
        [Parameter(mandatory)]
        [string]
        $Name
    )

    Try {
        $CurrentConfig = @{}   
        Get-SecretInfo | Where-Object {$_.Metadata.Module -eq "PSNotion"}| Foreach {$CurrentConfig.Add($_.Name,(Get-Secret -Name $_.Name -Vault $_.VaultName -AsPlainText))}

        If ($CurrentConfig.Keys.count -gt 0) {
            $script:ActiveAccount = $Name

            Write-Warning "INFO: Active Notion account - $ActiveAccount"
        }else {
            Write-Warning "No config found. Please run New-NotionConfig comand to setup first tenant configuration" 
        }
    }
    catch {
        throw "Set-ITSMActivetenant: $_"
    }

}