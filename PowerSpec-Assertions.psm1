#
# common array operations
#
function to_list {
    begin {
        $list = @()
    }
    process {
        $list += ,$_
    }
    end {
        return $list
    }
}

function tail {
    begin { $head = $true }
    process {
        if ($head) {
            $head = $false
            return
        }
        
        return @($_)
    }
}

function concat ([array]$other) {
    process {
        return ,$_
    }
    end {
        return @($other)
    }
}

#
# private routines
#
function write-assertion ($name, $result) {
    write-output @{
        type = 'assertion';
        assertion = $name;
        result = $result
    }
}

function eval {
    process {
        if ($_ -is [scriptblock]) {
            try { return ,(&$_) }
            catch { return $_ }
        }
        else { return ,$_ }
    }
}

function humanize {
    process {
        $text = "$_" `
            -replace '[{}]', '' `
            -replace '[_-]', ' ' `
            -replace '\s{2,}', ' '
        return $text.Trim()
    }
}

function format-assertion ($actual, $func, $tail) {
    $actual_value = $actual | eval
    if ("$actual" -ne "$actual_value") {
        $actual = "$actual ($actual_value)"
    }
    $items = $actual, $func, $tail | humanize
    return $items -join ' '
}

function call ($func, $func_args) {
    if ($func -ne 'throw'-and
        $func -ne 'not') {
        $func_args = @($func_args | eval)
    }
    return &$func @func_args
}

#
# public API
#
function each {
    begin {
        $func = $args[0]
        $func_args = $args | tail
    }
    process {
        ,$_ | &$func @func_args
    }
}

function should {
    $func = $args[0]
    $input_list = $input | to_list
    $name = format-assertion $input_list 'should' $args
    $args_tail = $args | tail
    $args[0] = $input_list
    $result = call $func $args
    write-assertion $name $result
}

function not {
    $first = $args[0]
    $func = $args[1]
    $func_args = ,$first | concat ($args | tail | tail)
    return -not (call $func $func_args)
}

function be_equal ($actual, $expected) {
    if ($actual -is [enum]) { return $actual -eq $expected }
    return [System.Object]::Equals($actual, $expected)
}

function contain ($collection, $expected) {
    return $collection -contains $expected
}

function be_true ($actual) {
    return be_equal $actual $true
}

function be_false ($actual) {
    return -not (be_true $actual)
}

function throw ([scriptblock]$script) {
    $thrown = $false
    try { &$script | out-null }
    catch { $thrown = $true }
    return $thrown
}

function be_null ($actual) {
    return $null -eq $actual
}

function be_greater ($actual, $expected) {
    return $actual -gt $expected
}

export-moduleMember -function `
    each,
    should,
    not,
    throw,
    be_equal,
    be_true,
    be_false,
    be_null
