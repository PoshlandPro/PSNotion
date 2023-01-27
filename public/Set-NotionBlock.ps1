function Set-NotionBlock{
    [CmdletBinding(DefaultParameterSetName = 'paragraph')]
    param (
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias("id")]
        [string]
        $Blockid,
        [Parameter(ParameterSetName = 'paragraph')]
        [switch]
        $Paragraph,
        [Parameter(ParameterSetName = 'heading')]
        [ValidateSet("H1","H2","H3")]
        [string]
        $Heading,
        [Parameter(ParameterSetName = 'callout')]
        [switch]
        $Callout,
        [Parameter(ParameterSetName = 'quote')]
        [switch]
        $Quote,
        [Parameter(ParameterSetName = 'heading')]
        [Parameter(ParameterSetName = 'paragraph')]
        [Parameter(ParameterSetName = 'callout')]
        [Parameter(ParameterSetName = 'quote')]
        [string]
        $Content,
        [Parameter(ParameterSetName = 'heading')]
        [Parameter(ParameterSetName = 'paragraph')]
        [Parameter(ParameterSetName = 'callout')]
        [Parameter(ParameterSetName = 'quote')]
        [ValidateSet("default","gray","brown","orange","yellow","green","blue","purple","pink","red","gray_background","brown_background","orange_background","yellow_background","green_background","blue_background","purple_background","pink_background","red_background")]
        [string]
        $Color = "default",
        [Parameter(ParameterSetName = 'heading')]
        [bool]
        $IsToggleable


    )

    if ($Paragraph) {
        $Block = [PSCustomObject]@{
            paragraph = [PSCustomObject]@{
                rich_text = @(
                    [PSCustomObject]@{
                        text = [PSCustomObject]@{
                            content = $Content
                        }
                    }
                )
                color = $Color
            }
        }
    }
    elseif ($Heading) {
        switch ($Heading) {
            "H1" {$headingsize = "heading_1"}
            "H2" {$headingsize = "heading_2"}
            "H3" {$headingsize = "heading_3"}
        }
        $Block = [PSCustomObject]@{
            "$headingsize" = [PSCustomObject]@{
                rich_text = @(
                    [PSCustomObject]@{
                        text = [PSCustomObject]@{
                            content = $Content
                            link = $null
                        }
                    }
                )
                color = $Color
            }
        }
        if ($IsToggleable -ne $null) {
            $block."$headingsize" | Add-Member -MemberType NoteProperty -Name "is_toggleable" -Value $IsToggleable
        }
    }
    elseif ($Callout) {
        $Block = [PSCustomObject]@{
            callout = [PSCustomObject]@{
                rich_text = @(
                    [PSCustomObject]@{
                        text = [PSCustomObject]@{
                            content = $Content
                        }
                    }
                )
                # icon = [PSCustomObject]@{
                #     emoji = $Icon
                # }
                color = $Color
                
            }
        }
    }
    elseif ($Quote) {
        $Block = [PSCustomObject]@{
            quote = [PSCustomObject]@{
                rich_text = @(
                    [PSCustomObject]@{
                        text = [PSCustomObject]@{
                            content = $Content
                        }
                    }
                )
                color = $Color
            }
        }
    }
    
    $Response = Invoke-NotionRequest -UriEndpoint "/blocks/$Blockid" -Method PATCH -Body ($Block|ConvertTo-Json -Depth 100) 


    return $Response.results

}
