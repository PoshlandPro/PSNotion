function Get-NotionPage{
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName = 'ByDatabaseId')]
        [Alias("id")]
        [string]
        $DatabaseId,
        [Parameter()]
        [Parameter(ParameterSetName = 'ByPageId')]
        [string]
        $PageId,
        [Parameter()]
        [Parameter(ParameterSetName = 'ByDatabaseId')]
        [switch]
        $All
    )


    if (![string]::IsNullOrEmpty($DatabaseId)) {
        $Body = @{}
        $Response = Invoke-NotionRequest -UriEndpoint "/databases/$DatabaseId/query" -Method POST -Body ( $Body | ConvertTo-Json)
        $ResponseSummary = $Response
    
    
        If ($All -and $Response.has_more -eq $true) {
            
            do {
                $Body = @{
                    start_cursor = "$($Response.next_cursor)"
                }
                $Response = Invoke-NotionRequest -UriEndpoint "/databases/$DatabaseId/query" -Method POST -Body ( $Body | ConvertTo-Json)
                $ResponseSummary.results += $Response.results
                $ResponseSummary.has_more = $Response.has_more
                $ResponseSummary.next_cursor = $Response.next_cursor
            }while ($Response.has_more -eq $true)
        }
    
        return $ResponseSummary.results
    }
    elseif(![string]::IsNullOrEmpty($PageId)) {

        $Response = Invoke-NotionRequest -UriEndpoint "/pages/$PageId" -Method GET 
        return $Response
    }
    else {
        throw "No Databaseid or Pageid provided!"
    }

    

}