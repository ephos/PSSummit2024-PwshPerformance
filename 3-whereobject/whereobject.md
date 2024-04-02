# `Where-Object` vs `.where()`

## Differences

This is another "magic method" that was introduced when the `.foreach()` method was.
Collections in PowerShell will usually have `.where()` method.

High-level differences.

- `Where-Object`
  * Our beloved filtering from `Microsoft.PowerShell.Core` 
  * Two different syntactical ways of implementing this _(Since PowerShell 3.0)_
- `.where()`_"magic method"_
  * Introduced in PowerShell 3.0
  * Contains functionality that also overlaps a bit with `Select-Object`

## Compare

```powershell
# Magic card list is big, Git and Github get unhappy
Expand-Archive -Path cards.zip -DestinationPath .
```

But... Is one faster than the other? Let's use a big list of Magic cards to find out.

```powershell
# Get all the Magic cards
$mtgJson = Get-Content ./all_magic_cards.json | ConvertFrom-Json -AsHashtable 
$cards = $mtgJson.data.GetEnumerator() | ForEach-Object {$_} | Select-Object -Property Name
$cards | Get-Random -Count 10

# Where-Object (Script Block)
Measure-Command -Expression { $cards | Where-Object -FilterScript {$_.Name -like '*cheese*'} }

# Where-Object (Comparison Statement)
Measure-Command -Expression { $cards | Where-Object Name -like '*cheese*' }
# The problem with the Comparison Statement is that you can only use one single condition

# .where()
Measure-Command -Expression { $cards.data.GetEnumerator().where({$_.Name -like '*cheese*'}) }
```

We can see that `.where()` has better performance compared to it's `Where-Object` counter part.
The `.where()` method can also be used in a similar way to `Select-Object`.

```powershell
# Get all the 'zombie' cards
$cards.where({$_.Name -like '*zombie*'})

# Selecting and sorting with the .where() method
$cards.where({$_.Name -like '*zombie*'},'First',10)
$cards.where({$_.Name -like '*zombie*'},'Last',10)
```

## Do

1. Consider if you need the performance of `.where()`
2. Consider that the syntax of `Where-Object` tends to be a little more friendly and PowerShell-y _(if this is important to you)_.

## Don't

1. Just arbitrarily pick one, give some thought to your collection size and if the performance gains matter.
  a. Anecdotal: There have been very few times in my 10+ years of PowerShell that I have used `.where()`, maybe it's just me though.

## Links

- [PowerShellMagazine - Kirk Munro](https://powershellmagazine.com/2014/10/22/foreach-and-where-magic-methods/)
- [Where-Object PowerShell Docs](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/where-object?view=powershell-7.4)
