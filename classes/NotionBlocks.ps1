# class NotionDefaultBlock {
#     [array]$rich_text

#     NotionDefaultBlock ([string]$content) {

#         $this.rich_text = [array]@(
#             @{
#                 text = @{
#                     content = $content
#                 }
#             }
#         )
        
#     }
# }

class NotionParagraph {
    [object]$paragraph

    NotionParagraph ([string]$content) {
        $this.paragraph = [PSCustomObject]@{
            rich_text = [array]@(
                [PSCustomObject]@{
                    text = [PSCustomObject]@{
                        content = $content
                    }
                }
            )
            color = $null
        }
    }
}

class NotionHeading1{
    [object]$heading_1

    NotionHeading ([string]$content) {
        $this."heading_1" = [PSCustomObject]@{
            rich_text = [array]@(
                [PSCustomObject]@{
                    text = [PSCustomObject]@{
                        content = $content
                        link = $null
                    }
                }
            )
            color = $null
            is_toggleable = $false
        }
        
    }
}

class NotionHeading2{
    [object]$heading_1

    NotionHeading ([string]$content) {
        $this."heading_2" = [PSCustomObject]@{
            rich_text = [array]@(
                [PSCustomObject]@{
                    text = [PSCustomObject]@{
                        content = $content
                        link = $null
                    }
                }
            )
            color = $null
            is_toggleable = $false
        }
        
    }
}

class NotionHeading3{
    [object]$heading_1

    NotionHeading ([string]$content) {
        $this."heading_3" = [PSCustomObject]@{
            rich_text = [array]@(
                [PSCustomObject]@{
                    text = [PSCustomObject]@{
                        content = $content
                        link = $null
                    }
                }
            )
            color = $null
            is_toggleable = $false
        }
        
    }
}

