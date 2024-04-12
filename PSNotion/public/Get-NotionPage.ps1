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
        $All,
        [Parameter()]
        [Parameter(ParameterSetName = 'ByDatabaseId')]
        [hashtable]
        $Filter
    )


    if (![string]::IsNullOrEmpty($DatabaseId)) {
        if ($Filter) {
            $Body = @{
                filter = $Filter
            }
        }
        else {
            $Body = @{}
        }

        $Response = Invoke-NotionRequest -UriEndpoint "/databases/$DatabaseId/query" -Method POST -Body ( $Body | ConvertTo-Json -Depth 100)
        $ResponseSummary = $Response
    
    
        If ($All -and $Response.has_more -eq $true) {
            
            do {
                if ($Body.ContainsKey("start_cursor")) {
                    $Body["start_cursor"] = $Response.next_cursor
                }
                else {
                    $Body.Add("start_cursor", $Response.next_cursor)
                }
                $Response = Invoke-NotionRequest -UriEndpoint "/databases/$DatabaseId/query" -Method POST -Body ( $Body | ConvertTo-Json -Depth 100)
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