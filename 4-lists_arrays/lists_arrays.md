# Lists and Arrays in PowerShell

## Knowing Better is the First Step

If you didn't know, you now know, there are different types of lists in PowerShell beyond `@()`!

Hot take, you should _almost_ never use `@()`!

Also for the sake of being pedantic let's clear up the following terms _(for .Net/PowerShell)_.

- PowerShell Array: Fixed sized list, generally an array cannot be altered after instantiation...
  * Enter the PowerShell dark arts of `+=`, you can add but it comes at a price of complete re-creation.
- Array List: A non-strongly typed list that is alterable, you can add and remove after instantiation.
- List (Generic): A strongly typed list that is alterable, you can add and remove after instantiation. 

## Compare

### PowerShell Array `@()`

```powershell
# Create a PowerShell Array
$myPsArray = @()
# Let's add to it!
$myPsArray.Add(1)

# Whoops! Add method doesn't work, let's modify it the PowerShell way!
$myPsArray += 1
$myPsArray

$myPsArray += 'BobbyCodes'
$myPsArray
```

---

So far so good but the performance scales HORRIBLY on this approach/pattern!

```powershell
# Oh my... we have A LOT of items to add!
$bigNumList = 1..20000

Measure-Command -Expression {
  foreach ($number in $bigNumList) {
    $myPsArray += $number
  }
} | Tee-Object -Variable tsArray
```

---

### .Net `[System.Collection.ArrayList]`

Let's look at an `ArrayList`.

```powershell
# Instantiate an ArrayList (You can do this with New-Object as well)
$myArrayList = New-Object -TypeName System.Collections.ArrayList
# or...
$myArrayList = [System.Collections.ArrayList]::new()

# Adding to the ArrayList
$myArrayList.Add(1)
$myArrayList
$myArrayList.Add('BobbyCodes')
$myArrayList

# Adding LOTS-O items again
$bigAddition = 1..20000

Measure-Command -Expression {
  foreach ($number in $bigAddition) {
    $myArrayList.Add($number)
  }
} | Tee-Object -Variable tsArraylist
```

---

### .Net `[System.Collection.Generic.List[<Type>]`

Now onto the `Generic.List<Type>`.

```powershell
# Instantiate an Generic List, like before you can do this 2 ways
$myGenericListInt = New-Object -TypeName System.Collections.Generic.List[Int]
# or...
$myGenericListInt= [System.Collections.Generic.List[Int]]::new()

# Adding to the Generic List
$myGenericListInt.Add(42)
$myGenericListInt.Add(1234)
$myGenericListInt
# Add a non-int type
$myGenericListInt.Add('BobbyCodes')

# Adding many MANY items one final time
$bigAddition = 1..20000

Measure-Command -Expression {
  foreach ($number in $bigAddition) {
    $myGenericListInt.Add($number)
  }
} | Tee-Object -Variable tsGenericList
```

## Do

Use either a `[System.Collections.ArrayList]` or `[System.Collections.Generic.List[<Type>]]` over PowerShell's `@()`.

Our example was simple and still seconds vs milliseconds. Imagine a larger dataset!

## Don't

Please... 

Please please please!!!! Just don't use `@()`, it's not that hard to use a better collection type.
Every time you append to an array with `+=` you're creating a new array, copying everything into it, and appending the new item.
This of how slow an expensive this is.

## Fun Facts!

- If we have time we can watch the processor suffer with `btop` when using `@()` and `+=`
- Subjective, my personal preference is to use a generic typed list.
- With `[System.Collections.Generic.List[String]]` just be aware it will convert anything added to a **String**!!!

## Links

- [Everything About Arrays](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-arrays?view=powershell-7.4)
- [about_arrays Documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arrays?view=powershell-7.4)
