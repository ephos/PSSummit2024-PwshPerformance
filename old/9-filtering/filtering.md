# Filtering

## Overview

The old rule:

> Filter left, Format right.

Essentially, do the filtering as far left as possible on the pipeline.
Do the formatting as far right as possible.

```powershell
# Instead of this
Get-Process | Where-Object {$_.Name -eq 'pwsh'} | Format-Table -AutoSize

# Do this
Get-Process -Name pwsh | Format-Table -AutoSize

# Timing
Measure-Command {
    Get-Process | Where-Object {$_.Name -eq 'pwsh'} | Format-Table -AutoSize
} | Tee-Object -Variable bad

Measure-Command {
    Get-Process -Name 'pwsh' | Format-Table -AutoSize
} | Tee-Object -Variable better

tsd $bad $better
```

## Considerations

Honestly I tried to think of a better example but the point is...

- If the command you are running can filter, do it there to avoid piping to `Where-Object`
- ANY `Format-*` command is going to clobber your objects, it's just text, text can suck
  * Always `Format-*` at the end of your pipeline
