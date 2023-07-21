$ModulePath = (Get-Item "$PSScriptRoot/../../src").FullName
# Publish-Module -Path $ModulePath -NuGetApiKey $env:NUGET_KEY