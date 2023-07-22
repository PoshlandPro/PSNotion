$ModulePath = (Get-Item "$PSScriptRoot/../../PSNotion/").FullName
Publish-Module -Path $ModulePath -NuGetApiKey $env:NUGET_KEY