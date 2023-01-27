function Get-NotionDatabase {
[CmdletBinding()]
param (
    [Parameter()]
    [Alias("Id")]
    [string]
    $DatabaseId,
    [Parameter()]
    [switch]
    $All
)

    if ([string]::IsNullOrEmpty($DatabaseId)){
        $Body = [PSCustomObject]@{
            filter = [PSCustomObject]@{
                value = "database"
                property = "object"
            }
            page_size = 100
        }
        $Response = Invoke-NotionRequest -UriEndpoint "/search" -Method POST -Body  ($Body|ConvertTo-Json )
        $ResponseSummary = $Response

        If ($All -and $Response.has_more -eq $true) {
            do {
                $Body = [PSCustomObject]@{
                    filter = [PSCustomObject]@{
                        value = "database"
                        property = "object"
                    }
                    page_size = 100
                    start_cursor = "$($Response.next_cursor)"
                }
                $Response = Invoke-NotionRequest -UriEndpoint "/search" -Method POST -Body  ($Body|ConvertTo-Json )
                $ResponseSummary.results += $Response.results
                $ResponseSummary.has_more = $Response.has_more
                $ResponseSummary.next_cursor = $Response.next_cursor
            }while ($Response.has_more -eq $true)
        }

        return $ResponseSummary.results

    }
    else {
        $Response = Invoke-NotionRequest -UriEndpoint "/databases/$DatabaseId" -Method GET
        return $Response
    }


}