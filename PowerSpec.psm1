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
    end {
        write-statistic -failed 0 -passed 0
    }
}

export-moduleMember `
    Test-Spec