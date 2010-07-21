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

function Test-Script ($script) {
    $name = (split-path $script -leaf)

    try {
        &$script | out-null
        write-success "$name PASSED"
        return $true
    }
    catch {
        write-host
        write-success "$name FAILED"
        write-success "$_" -failure
        write-host
        return $false
    }
}

function Format-Summary ($failed, $passed) {
    write-host 'Test results: ' -nonewline
    if ($failed -gt 0) {
        write-success "$failed failed" -nonewline
        write-host ', ' -nonewline
    }
    if ($passed -gt 0) {
        write-success "$passed passed" -nonewline
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

function Should-Throw ([scriptblock]$script) {
    $file = $script.File
    $line = $script.StartPosition.StartLine
    $column = $script.StartPosition.StartColumn
    
    try { &$script }
    catch { return }
    throw @"
Expected error was not present in {$script}
$file Ln $line Col $column
"@
}

function Should-BeEqual ($to) {
    process {
        if ($_ -is [scriptblock]) {
            $value = &$_
            if ($value -ne $to) {
                $file = $_.File
                $line = $_.StartPosition.StartLine
                $column = $_.StartPosition.StartColumn
                throw @"
{$_} is not equal to $to
$file Ln $line Col $column
"@
            }
        }
        elseif ($_ -ne $to) {
            throw "$_ is not equal to $to"
        }
    }
}

function Should-BeTrue {
    $input | should-beEqual -to $true
}

export-moduleMember -function `
    Test-Spec,
    Should-Throw,
    Should-BeEqual,
    Should-BeTrue