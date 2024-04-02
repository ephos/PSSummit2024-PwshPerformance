function Get-TimeSpanDiffPercent {
    [CmdletBinding()]
    param (
        # TimeSpan 1, or if Int passed will convert to Timespan and populate ticks
        [Parameter(Mandatory=$true, Position = 0)]
        [TimeSpan]$Reference,

        # TimeSpan 2, or if Int passed will convert to Timespan and populate ticks
        [Parameter(Mandatory=$true, Position = 1)]
        [TimeSpan]$Difference
    )
    process {
        # Get the Ticks
        $refTicks = $Reference.Ticks
        $diffTicks = $Difference.Ticks
        Write-Verbose -Message ('Reference Ticks: {0}' -f $refTicks)
        Write-Verbose -Message ('Difference Ticks: {0}' -f $diffTicks)

        # Absolute difference between reference and difference
        $absDiff = [Math]::Abs($refTicks - $diffTicks)

        # Absolute difference between reference and difference
        $avg = ($refTicks + $diffTicks) / 2

        # Percentage Difference
        $percentageDiff = ($absDiff / $avg) * 100
        
        # Speed improvement of the faster timespan!
        $largerTs = $refTicks
        $smallerTs = $diffTicks
        if ($diffTicks -gt $refTicks){
            Write-Verbose -Message ('Difference ticks ({0}) are larger than reference ticks ({1}).' -f $diffTicks, $refTicks)
            $largerTs = $diffTicks
            $smallerTs = $refTicks
        }
        $speedInc = (($largerTs - $smallerTs) / $smallerTs) * 100
        $speedDec = (($largerTs - $smallerTs) / $largerTs * 100)

        # How many times faster was the faster run?
        $timesFaster = $largerTs / $smallerTs

        # Ta-Da!
        Write-Verbose -Message ("Difference: {0}%" -f [Math]::Round($percentageDiff,3))
        "Increase in Perf:    `e[38;2;0;255;171m{0}%`e[0m" -f [Math]::Abs([Math]::Round($speedInc,3))
        "Decrease in Time:    `e[38;2;0;255;171m{0}%`e[0m" -f [Math]::Abs([Math]::Round($speedDec,3))
        "Faster By:           `e[38;2;0;255;171m~{0}x`e[0m" -f [Math]::Round($timesFaster,2) 
        if ($timesFaster -gt 100) {"🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥"}
    }
}
New-Alias -Name tsd -Value Get-TimeSpanDiffPercent -Force
