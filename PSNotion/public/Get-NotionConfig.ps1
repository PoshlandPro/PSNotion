function Get-NotionConfig {

    Try {
        $ConfigList = Get-SecretInfo -Vault $SecretVaultName | Where-Object {$_.Metadata.Module -eq "PSNotion"}  
        
        If (!$ConfigList) {
            Write-Warning "No config found. Please run New-NotionConfig comand to setup account configuration"
            return
        }
        else {
            Write-Warning "Active Notion Account - $( $script:ActiveAccount)"
            return $ConfigList | Select-Object Name
        }


    }
    catch {
        Throw "ERROR: Cannot read config. - $($_.Exception.Message)"
    }
    
}