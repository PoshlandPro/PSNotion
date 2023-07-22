function Find-NotionObject {
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateSet("database","page")]
    [Alias("object")]
    [string]
    $ObjectType,
    [Parameter()]
    [switch]
    $All
)


    $Body = [PSCustomObject]@{
        filter = [PSCustomObject]@{
            value = "$ObjectType"
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
                    value = "$ObjectType"
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