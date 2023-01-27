function Update-NotionConfig {
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
        Get-SecretInfo -Vault $SecretVaultName | Where-Object {$_.Metadata.Module -eq "PSNotion"}  | Foreach {$CurrentConfig.Add($_.Name,(Get-Secret -Name $_.Name -Vault $_.VaultName -AsPlainText))}
        
        If ($CurrentConfig[$Name] -eq $Null) {
            Write-Warning "No config found. Please run New-NotionConfig comand to setup account configuration"
            return
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
        If ($DefaultTenant -eq $True) {
            $CurrentConfig.Keys.Clone() | Where-Object {$_ -ne $Name} | ForEach-Object {$CurrentConfig[$_]['Default']="$False"; Set-Secret -Name $_ -Secret $CurrentConfig[$_]}
        }
        $CurrentConfig[$Name]['APIKey']  = $APIKey
        $CurrentConfig[$Name]['Default'] = "$DefaultTenant"
        Set-Secret -Vault $SecretVaultName -Name $Name -Secret $CurrentConfig[$Name] -Metadata @{Module="PSNotion"}
    }
    catch {
        throw "ERROR: Problem occured while saving new config file. $_"
    }





    
}