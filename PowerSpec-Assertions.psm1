function Should-Throw ([scriptblock]$script) {
    $thrown = $false
    try { &$script }
    catch { $thrown = $true }
    write-assertion `
        -name "$script should throw" `
        -failed:(-not $thrown)
}

function Should-BeEqual ($to) {
    process {
        $value = $_
        if ($_ -is [scriptblock]) {
            $value = &$_
        }
        
        write-assertion `
            -name "$_ should be equal to $to" `
            -failed:($value -ne $to)
    }
}

function Should-BeTrue {
    $input | should-beEqual -to $true
}

export-moduleMember -function `
    Should-Throw,
    Should-BeEqual,
    Should-BeTrue
