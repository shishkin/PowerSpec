$true | should-beTrue

4 -gt 3 | should-beTrue

{ 4 -gt 2 } | should-beTrue

should-throw { $false | should-beTrue }