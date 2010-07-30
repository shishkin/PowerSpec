resolve-path "$PSScriptRoot\PowerSpec-*.psm1" |
    import-module -force

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
        if ($_.type -ne 'assertion') { return }
        
        if ($_.result) { $summary.passed += 1 }
        else { $summary.failed += 1 }
    }
    end { return $summary }
}

function Write-Assertion {
    process {
        write-output $_
        if ($_.type -ne 'assertion') { return }
        
        $text = $_.assertion
        if ($_.result) {
            $text += ' PASSED'
        }
        else {
            $text += ' FAILED'
        }
        write-success "`t$text"
    }
}

function Test-Script {
    process {
        $name = (split-path $_ -leaf).Trim()
        write-host $name

        split-path $_ | push-location
        try {
            &$_ | write-assertion | write-output
        }
        catch {
            write-success "`t$_" -failure
            write-host
        }
        finally {
            pop-location
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

export-moduleMember -function Test-Spec

$plugins = get-module "PowerSpec-*" |
    % { $_.ExportedCommands.GetEnumerator() } |
    % { $_.Value }
$plugins |
    ? { $_.CommandType -eq 'Function' } |
    % { export-moduleMember -function $_.Name }
