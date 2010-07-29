<#
    'each' keyword can be used to specify multiple assertions
    in a single statement
#>

3, 4, 5 | each should not be_equal 6

<#
    Output:

    each.ps1
    	3 should not be equal 6 PASSED
    	4 should not be equal 6 PASSED
    	5 should not be equal 6 PASSED

#>    