function Invoke-BubbleSort {
    param (
        # File
        [Parameter(Mandatory = $true)]
        [String]
        $File
    )

    try {
        $fileLookup = Get-Item -Path $File -ErrorAction Stop
    } catch {
        throw ("Error opening file: {0}" -f $File)
    }

    [int[]]$numbers = [System.IO.File]::ReadAllLines($fileLookup.FullName)
    $n = $numbers.Length

    for ($i = 0; $i -lt $n; $i++ ) {
        for ($j = 0; $j -lt $n - $i - 1; $j++) {
            if ($numbers[$j] -gt $numbers[$j + 1]) {
                $placeHold = $numbers[$j]
                $numbers[$j] = $numbers[$j + 1]
                $numbers[$j + 1] = $placeHold
            }
        }
    }

    $numbers
}

