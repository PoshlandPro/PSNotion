function New-NotionPage {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Parameter(ParameterSetName = 'InPage')]
        [switch]
        $InPage,
        [Parameter()]
        [Parameter(ParameterSetName = 'InDatabase')]
        [switch]
        $InDatabase,
        [Parameter(Mandatory)]
        [Parameter(ParameterSetName = 'InPage')]
        [Parameter(ParameterSetName = 'InDatabase')]
        [string]
        $ParentId,
        [Parameter(Mandatory)]
        [Parameter(ParameterSetName = 'InPage')]
        [Parameter(ParameterSetName = 'InDatabase')]
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
        Invoke-NotionRequest -UriEndpoint "/pages" -Method POST -Body ($Body | ConvertTo-Json -Depth 10)
    }
    elseif ($InDatabase) {
        $dbProperties = (Get-NotionDatabase -id $ParentId).properties 
        $PropertyNames = ($dbProperties |  Get-Member | Where-Object  {$_.membertype -eq "NoteProperty"}).Name       
        foreach ($property in $PropertyNames) {
            $titletype = $dbProperties.$property | Where-Object {$_.type -eq "title"}
            if ($titletype) {
                $titleProperty = @{
                    $property = @{
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
        }

        $Body = @{
            parent = @{
                database_id = $ParentId
            }
            properties = $titleProperty
        }
        Invoke-NotionRequest -UriEndpoint "/pages" -Method POST -Body ($Body | ConvertTo-Json -Depth 10)
        
    }
    else {
        throw "Plase specify -InPage or -InDatabase parameter!"
    }


    

}