$ModulePath = (Get-Item "$PSScriptRoot/../../PSNotion/").FullName
Install-Module Microsoft.PowerShell.SecretStore -Confirm:$false
Install-Module Microsoft.PowerShell.SecretManagement -Confirm:$false
Publish-Module -Path $ModulePath -NuGetApiKey $env:NUGET_KEY