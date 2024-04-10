# Before We Begin

## Measuring Throughout This Session

- ⚠️ BE KIND, I AM NOT A MATH MAJOR
- I will be using `Get-TimeSpanDiffPercent` throughout this
- It has an alias of `tsd` for _**Time Span Diff**_
- It outputs text _(No it does not use `Write-Host` I have _some_ self respect)
- It leverages **Ticks**

What's a tick?

From the docs:

> The smallest unit of time is the tick, which is equal to 100 nanoseconds or one ten-millionth of a second. 
> There are 10,000 ticks in a millisecond. 
> The value of the Ticks property can be negative or positive to represent a negative or positive time interval.

---

Our testing function isn't perfect but we've established there are _**infinite**_ variables involved in measuring performance.

Luckily this is Summit and we're not trying to land a spacecraft, so our `Get-TimeSpanDiffPercent` will get us by.

- It takes 2 parameters both as a `[System.TimeSpan]`
  * The `$Reference` timespan _(position 0)_
  * The `$Difference` timespan _(position 1)_
- These `[System.TimeSpan]` objects can be the result of a `Measure-Command`
  * You can also pass in the raw **Ticks** as `[long]`( a.k.a `[Int64]`) and it will instantiate a `[TimeSpan]`
- It uses the **Ticks** of each and does _math™_ to calculate the following:
  * The approximate increase in performance in %
  * The approximate decrease in time in %
  * The approximate times faster the faster run/timespan of the two was

---

Let's see how it works.

```powershell
# Our helper
bat Get-TimeSpanDiffPercent.ps1

# This is why we can pass a whole [TimeSpan] or just a [Long]
[Timespan]::new

# Dot source the function in
. ./Get-TimeSpanDiffPercent.ps1

# Using 2 and 4 as examples
Get-TimeSpanDiffPercent 2 4

# Using more bigger-er numbers
tsd 32892 2377
```

Onto the show!

## Links

[Percentage Calculator](https://www.calculator.net/percent-calculator.html)
[.Net Ticks](https://learn.microsoft.com/en-us/dotnet/api/system.timespan.ticks?view=net-8.0#remarks)
