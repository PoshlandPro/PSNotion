function Get-NotionPageContent {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias("id")]
        [string]
        $PageId
    )

    $Response = Invoke-NotionRequest -UriEndpoint "/blocks/$PageId/children" -Method GET 


    return $Response.results

}
 