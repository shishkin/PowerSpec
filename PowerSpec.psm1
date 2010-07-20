function Write-Success {
    param (
        $text = '',
        [switch]$success,
        [switch]$failure
    )

    if ($text.ToUpper().EndsWith('PASSED') -or $success) {
        $params = @{ foregroundcolor = 'green' }
    }
    elseif ($text.ToUpper().EndsWith('FAILED') -or $failure) {
        $params = @{ foregroundcolor = 'red' }
    }
    
    write-host $text -nonewline @params    
}

function Test-Script ($script) {
    $passed = $true

    trap [Exception] {
        set-variable -name passed -value $false -scope 1
        continue
    }
    &$script | out-null

    write-success "$script" -success:$passed -failure:$(!$passed)
    write-host
    return $passed
}

function Format-Summary ($failed, $passed) {
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

function Get-Summary {
    begin { $summary = @{} }
    process {
        if ($_.passed) { $summary.passed += 1 }
        else { $summary.failed += 1 }
    }
    end { return $summary }
}

function Test-Spec {
    begin { $tests = @() }
    process {
        $passed = test-script $_
        $tests += @{ test="$_"; passed = $passed }
    }
    end {
        $summary = $tests | get-summary
        format-summary @summary
        return $summary
    }
}

export-moduleMember `
    Test-Spec