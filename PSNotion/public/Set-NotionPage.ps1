function Set-NotionPage{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Parameter(ParameterSetName = 'ByPageId')]
        [string]
        $PageId,
        [Parameter(Mandatory)]
        [Parameter(ParameterSetName = 'ByPageId')]
        [hashtable]
        $PageProperties

    )

    if ($PageProperties) {
        $Body = @{
            properties = $PageProperties
        }
    }
    else {
        throw "PageProperties is required"
    }
    
    try {
        $Response = Invoke-NotionRequest -UriEndpoint "/pages/$($PageId)" -Method PATCH -Body ( $Body | ConvertTo-Json -Depth 100)    
    }
    catch {
        throw "Failed to update page with id: $($PageId). Error: $($_.Exception.Message)"
    }
    
    return $Response
}