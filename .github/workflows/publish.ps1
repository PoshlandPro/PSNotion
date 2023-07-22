$ModulePath = (Get-Item "$PSScriptRoot/../../PSNotion/").FullName
Install-Module Microsoft.PowerShell.SecretStore
Install-Module Microsoft.PowerShell.SecretManagement
Publish-Module -Path $ModulePath -NuGetApiKey $env:NUGET_KEY