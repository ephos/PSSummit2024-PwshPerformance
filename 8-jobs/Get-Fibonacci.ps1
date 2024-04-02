function Get-Fibonacci {
    param (
        [int]$Number
    )

    if ($Number -le 0) {
        return 0
    } elseif ($Number -eq 1) {
        return 1
    } else {
        return (Get-Fibonacci -n ($Number-1)) + (Get-Fibonacci -n ($Number-2))
    }
}

