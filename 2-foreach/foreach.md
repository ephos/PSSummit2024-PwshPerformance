# ForEach/foreach vs ForEach-Object vs .foreach

## Differences

High-level differences.

- `foreach` 
  * Front loads collection into memory before processing
  * Uses more memory but faster 
- `ForEach-Object`
  * Does not initially load entire collection into memory before processing
  * Can use PowerShell pipeline and functionality like `-Begin`, `-Process`, `-End`
- `.foreach()`_"magic method"_
  * Available on collections
  * Similar to `foreach` front loads collection into memory
  * Added in PowerShell 4

**NEW CONTENDER!** _(sort-of, I mean this is like 5 years old now...)_

- `ForEach-Object -Parallel`
  * This still uses the pipeline
  * Each script block is run in it's own Runspace
  * You can also specify `-Parallel` with `-AsJob` which will use PowerShell jobs instead.
    + Runspaces require slightly less overhead than Jobs
  * Runspaces need to load dependent modules and variables _(with `$using:`)_, this can be costly.
  * Generally `-ThrottleLimit` should match your machines cores.

## Compare

```powershell
# 10 Million!
$numbers = 0..10000000

# ForEach-Object
Measure-Command -Expression { $numbers | ForEach-Object {"Hello Number: + $_"} }

# foreach
Measure-Command -Expression { foreach ($n in $numbers) {"Hello Number: + $n"} }

# .foreach()
Measure-Command -Expression { $numbers.ForEach({"Hello Number: + $_"}) }

# ForEach-Object -Parallel
# This is actually a TERRIBLE use case for -Parallel since the overhead of the runspace isn't worth it for what we're processing
# Small scale example with only 100
$numbers = 0..100

Measure-Command -Expression { $numbers | ForEach-Object {"Hello Number: + $_"} }
Measure-Command -Expression { $numbers | ForEach-Object -Parallel {"Hello Number: + $_"} -ThrottleLimit 6 }
```

## Do

1. Do consider what you are processing! 
  a. Is memory consumption important?
  b. Is use of the PowerShell pipeline required?
  c. Are you processing simple code like we did or actually have something that Runspaces will benefit?

## Don't

1. Don't just use your favorite ForEach, there are differences behind how they all work!
2. Don't just use `-Parallel` and exclaim _"ForEach-Object go brrrrrrrrrrrrrr!"_, No!

## Fun Facts!

- You can use the `-PipelineVariable` when passing into `ForEach-Object` if you don't want to use `$_`

```powershell
Get-Process -PipelineVariable 'bobby' | ForEach-Object {
  $bobby | Select-Object -Property name
}
```

## Links

- [PowerShellMagazine - Kirk Munro](https://powershellmagazine.com/2014/10/22/foreach-and-where-magic-methods/)
- [PowerShell ForEach-Object -Parallel](https://devblogs.microsoft.com/powershell/powershell-foreach-object-parallel-feature/)
