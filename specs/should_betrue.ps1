$true | should be_true

4 -gt 3 | should be_true

{ 4 -gt 2 } | should be_true

$false | should be_false

{ $null } | should not be_false