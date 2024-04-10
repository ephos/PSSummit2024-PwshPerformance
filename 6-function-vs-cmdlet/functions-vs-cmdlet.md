# Functions vs Cmdlets

Bubblesort is back for this one!

If this feels similar to where we started, that's because it is.

We're comparing an interpreted scripting language to a compiled language, but it's all .Net this time!!! 

## Differences

- Function
  * Implemented/written in PowerShell
  * Interpreted by the PowerShell interpreter
- Cmdlet
  * Implemented/written in C# generally
  * Compiled into a dll

## Compare

```powershell
# PowerShell (Advanced) Function
bat ./Invoke-BubbleSort.ps1
Get-Command -Name Invoke-BubbleSort

# PowerShell Compiled Cmdlet
bat ./PwshBubbleSort/InvokeBubbleSortCS.cs
# Import the Cmdlet
Import-Module ./PwshBubbleSort/bin/Debug/netstandard2.0/PwshBubbleSort.dll
Get-Command -Name Invoke-BubbleSortCS

# Let's test em' out
Measure-Command -Expression {
    Invoke-BubbleSort -File ./numlist_1000.txt
} | Tee-Object -Variable pwsh

Measure-Command -Expression {
    Invoke-BubbleSortCS -File ./numlist_1000.txt
} | Tee-Object -Variable cs

tsd $cs $pwsh
```

## Considerations

- Write a Cmdlet if it is needed and none of the other optimizations we cover are options
- Realize that a compiled peice of code will almost always be faster than interpreted code
- A Cmdlet is a whole new world of how to do not just PowerShell but code in general, consider the investment

## Links

[Microsoft Docs - Writing Cmdlets](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/how-to-write-a-simple-cmdlet?view=powershell-7.4)
