$ModulePath = (Get-Item "$PSScriptRoot/../Movies").FullName
# Publish-Module -Path $ModulePath -NuGetApiKey $env:NUGET_KEY