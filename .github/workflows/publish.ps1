$ModulePath = (Get-Item "$PSScriptRoot/../../PSNotion/").FullName
Get-PSRepository PSGallery| Set-PSRepository -InstallationPolicy Trusted
Install-Module Microsoft.PowerShell.SecretStore -Confirm:$false
Install-Module Microsoft.PowerShell.SecretManagement -Confirm:$false
Publish-Module -Path $ModulePath -NuGetApiKey $env:NUGET_KEY