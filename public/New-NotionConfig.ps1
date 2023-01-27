function New-NotionConfig {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [string]
        $APIKey,
        [Parameter()]
        [bool]
        $DefaultTenant = $False
    )

    Try {
        $ErrorMsg = "ERROR: Cannot read config." 
        $CurrentConfig = @{}   
        Get-SecretInfo -Vault $SecretVaultName| Where-Object {$_.Metadata.Module -eq "PSNotion"}  | Foreach {$CurrentConfig.Add($_.Name,(Get-Secret -Name $_.Name -Vault $_.VaultName -AsPlainText))}
        
        if ($CurrentConfig.Keys.count -gt 0) {
            if ($CurrentConfig.Keys.Clone() -contains $Name) {
                Throw "ERROR: There is an existing tenant configuration for $Name. Please use Update-NotionConfig"
            }
        }
        else {
            $DefaultTenant = $True
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

    Try {
        $NewConfig = @{
            Default = "$DefaultTenant"
            APIKey  = "$APIKey"
        }
        Set-Secret -Vault $SecretVaultName -Name $Name -Secret $NewConfig -Metadata @{Module="PSNotion"}
    }
    catch {
        throw "ERROR: Problem occured while saving new config file. $_"
    }
    
}