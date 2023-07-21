# BeforeAll {

    
# }
Describe 'Token validation' {
    Context 'Test saved credentials' {
        $TestCredentials = Get-SecretInfo | Where-Object {$_.Metadata.Module -eq "PSNotion"}
        $TestCredentials | Should -Not -BeNullOrEmpty
    }
}
Describe 'Test PSNotionModule' {
    Context 'Get Notion object' {
        It 'Find-NotionObject -ObjectType database should return at least one Notion database' {
            $NotionDatabase = Find-NotionObject -ObjectType database
            $NotionDatabase | Should -Not -BeNullOrEmpty
        }
        It 'Find-NotionObject -ObjectType page should return at least one Notion page' {
            $NotionPages = Find-NotionObject -ObjectType page
            
            $NotionPages | Should -Not -BeNullOrEmpty
        }
        It 'Get-PSNotionDatabase should return at least one Notion Database' {
            $NotionDatabase = Get-NotionDatabase
            $NotionDatabase | Should -Not -BeNullOrEmpty
        }
        It 'Get-PSNotionDatabase -DatabaseId should return only one database object' {
            $DatabaseId = (Get-NotionDatabase)[0].Id
            $NotionDatabase = Get-NotionDatabase -DatabaseId $DatabaseId
            $NotionDatabase | Measure-Object | Select-Object -ExpandProperty Count | Should -Be 1
        }
        It 'Get-PSPage -DatabaseId should return only one database object' {
            $DatabaseId = (Get-NotionDatabase)[0].Id
            $NotionDatabase = Get-NotionDatabase -DatabaseId $DatabaseId
            $NotionDatabase | Measure-Object | Select-Object -ExpandProperty Count | Should -Be 1
        }
    }
}