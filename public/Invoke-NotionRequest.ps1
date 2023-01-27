function Invoke-NotionRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string]$UriEndpoint,
        [Parameter(Mandatory = $True)][string]$Method,
        [Parameter(Mandatory = $False)][string]$Body
    )
    
    begin {
        $APIKey = (Get-Secret -Name $ActiveAccount -AsPlainText)['APIKey']
        $Headers = @{
            "Authorization" = "Bearer $APIKey"
            "Notion-Version" = "2022-06-28"
            "accept" = "application/json"
            "content-type" = "application/json"
        }

        $Parameters = @{

            Method = $Method
            Headers = $Headers
            Uri = $RootUri + $UriEndpoint
            ContentType = $Headers["content-type"] 
        }

        if ($Body) {
            $Parameters += @{
                Body = $Body
            }
        }

    }
    
    process {


        if ($PSversiontable.PSEdition -eq "Core" ) {
            $response = Invoke-RestMethod @Parameters -SkipHeaderValidation -MaximumRedirection 0
        }
        else {
            $response = Invoke-RestMethod @Parameters 
        }
        
    }
    
    end {
        return $response
    }
}