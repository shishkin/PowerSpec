function Write-Success ($text = '') {
    if ($text.ToUpper().EndsWith('PASSED')) {
        $params = @{ foregroundcolor = 'green' }
    }
    elseif ($text.ToUpper().EndsWith('FAILED')) {
        $params = @{ foregroundcolor = 'red' }
    }
    
    write-host $text -nonewline @params    
}

function Test-Script ($script) {
    $output = &$script
    write-host "$script `t" -nonewline
    write-success "PASSED"
    write-host
    return $true
}

function Write-Statistic ($failed, $passed) {
    write-host 'Test results: ' -nonewline
    if ($failed -gt 0) {
        write-success "$failed failed"
        write-host ', ' -nonewline
    }
    if ($passed -gt 0) {
        write-success "$passed passed"
        write-host ', ' -nonewline
    }
    write-host "$($passed + $failed) Total."
}

function Test-Spec {
    begin {
        $tests = @()
    }
    process {
        $passed = test-script $_
        $tests += @{ test="$_"; passed = $passed }
    }
    end {
        $result = @{}
        $result.passed = $tests | ? { $_.passed } |
            measure | % { $_.Count }
        $result.failed = $tests | ? { -not $_.passed } |
            measure | % { $_.Count }
        write-statistic @result
        return $result
    }
}

export-moduleMember `
    Test-Spec