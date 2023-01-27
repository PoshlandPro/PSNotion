function New-NotionPage {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Parameter(ParameterSetName = 'InPage')]
        [switch]
        $InPage,
        [Parameter(Mandatory)]
        [Parameter(ParameterSetName = 'InPage')]
        [Parameter(ParameterSetName = 'InDatabase')]
        [string]
        $ParentId,
        [Parameter(Mandatory)]
        [Parameter(ParameterSetName = 'InPage')]
        [string]
        $PageTitle
    )

    if ($InPage) {
        $Body = @{
            parent = @{
                page_id = $ParentId
            }
            properties = @{
                title = @{
                    title = @(
                        @{
                            text = @{
                                content = "$PageTitle"
                            }
                        }
                    )
                }
            }
        }
        Invoke-NotionRequest -UriEndpoint "/pages" -Method POST -Body ($Body | ConvertTo-Json -Depth 100)
    }

    

}