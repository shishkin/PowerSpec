function Write-Statistic ($failed, $passed) {
    write-host 'Test results: ' -nonewline

    if ($failed -ne 0) {
        $failed_params = @{foregroundcolor = 'red'}
    }
    write-host "$failed failed" -nonewline @failed_params

    write-host ', ' -nonewline

    if ($passed -ne 0) {
        $passed_params = @{foregroundcolor = 'green'}
    }
    write-host "$passed passed" -nonewline @passed_params
    write-host '.'
}

function Test-Spec {
    begin {
        $tests = @()
    }
    process {
        &$_ | out-null
        $tests += @{ test="$_"; passed = $true}
    }
    end {
        $result = @{}
        $result.passed = $tests | ? { $_.passed } |
            measure | % { $_.Count }
        $result.failed = $tests | ? { -not $_.passed } |
            measure | % { $_.Count }
        write-statistic @result
    }
}

export-moduleMember `
    Test-Spec