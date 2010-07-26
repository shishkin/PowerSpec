function Write-Success {
    param (
        $text = '',
        [switch]$success,
        [switch]$failure,
        [switch]$nonewline
    )

    if ($text.ToUpper().EndsWith('PASSED') -or $success) {
        $params = @{ foregroundcolor = 'green' }
    }
    elseif ($text.ToUpper().EndsWith('FAILED') -or $failure) {
        $params = @{ foregroundcolor = 'red' }
    }
    
    write-host $text -nonewline:$nonewline @params    
}

function Format-Summary {
    process {
        [int]$passed = $_.passed
        [int]$failed = $_.failed
        write-host 'Test results: ' -nonewline
        if ($failed -gt 0) {
            write-success "$failed failed" -nonewline
            write-host ', ' -nonewline
        }
        if ($passed -gt 0) {
            write-success "$passed passed" -nonewline
            write-host ', ' -nonewline
        }
        write-host "$($passed + $failed) total."
        return $_
    }
}

function Get-Summary {
    begin { $summary = @{ } }
    process {
        if ($_.type -ne 'TestResult') { return }
        
        if ($_.passed) { $summary.passed += 1 }
        else { $summary.failed += 1 }
    }
    end { return $summary }
}

function Test-Script {
    process {
        $name = (split-path $_ -leaf).Trim()
        write-host $name

        try {
            &$_ | write-output
        }
        catch {
            write-success "`t$_" -failure
            write-host
        }
    }
}

function Test-Spec {
    end {
        $input |
            test-script |
            get-summary |
            format-summary
    }
}

function Write-Assertion ([string]$name, [switch]$failed) {
    $name = $name.Trim()
    write-output @{
        type = 'TestResult';
        name = $name;
        passed = -not $failed
    }
    
    if ($failed) {
        $name += ' FAILED'
    }
    else {
        $name += ' PASSED'
    }
    write-success "`t$name"
}

export-moduleMember -function `
    Test-Spec,
    Write-Assertion
