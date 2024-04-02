# PSCustomObjects vs Hashtables

## Differences

A `PSCustomObject` and a `System.Collections.Hashtable` are both data structures that can store **key/value** pairs.

Though they have some similarities, the interactions with them are quite different.

The details of both data structures could have warranted it's own 30-40 minute discussion!
We're going to focus on performance.

- PSCustomObject
  * Specific data structure to PowerShell only (_by extension .Net_.
  * Access properties via dot notation
  * Can create with `[PSCustomObject]@{}`
    + You can also create with `New-Object -TypeName PSCustomObject` if you like typing.
  * If you've had to output a custom data object easily in a function, you've used one.
- HashTable
  * This data structure exists in almost all languages.
  * Access properties via the keys
  * Can create with `@{}` or `[ordered]@{}` 
    + You can also create with `[System.Collections.Hashtable]::new()` if you like typing.
  * If you've splatted, you've used one.
  * If you've used a _*.psd1_
  * If you've used custom expressions with Cmdlets like `Select-Object`, you've used one.

## Compare

### HashTables 

We're going to create 2 different hashtables (ordered and un-ordered).
We'll iterate through a range of numbers 1-100000 to add a key and value for each number.

```powershell
# Un-ordered (default)
Measure-Command {
    $hashTable = @{}
    for ($i = 0; $i -lt 100000; $i++) {
        $hashTable["Key$i"] = "Value$i"
    }
} | Tee-Object -Variable tsHash

# Ordered
Measure-Command {
    $hashTableOrdered = [ordered]@{}
    for ($i = 0; $i -lt 100000; $i++) {
        $hashTableOrdered["Key$i"] = "Value$i"
    }
} | Tee-Object -Variable tsHashOrdered

$hashTable
$hashTableOrdered

# Index into the hashtable
# One
$hashtable['Key37773'] 
# Doing what we just did with all
Measure-Command {
    foreach ($k in $hashTable.GetEnumerator()) {$hashTable[$k.Key]}
} | Tee-Object -Variable tsIndexHash
```

In my experience testing I found the instantiation of an un-ordered and ordered hashtable to be similar in timing.

---

### PSCustomObject

PSCustomObjects are a little slower but also generally serve slightly different use cases.
A very common and simple way to return a custom object in your functions is to use a `[PSCustomObject]`.

```powershell
Measure-Command {
    $customObject = [PSCustomObject]@{}
    for ($i = 0; $i -lt 100000; $i++) {
        Add-Member -InputObject $customObject -MemberType NoteProperty -Name "Key$i" -Value "Value$i"
    }
} | Tee-Object -Variable tsPSCustomObject

$customObject

# Iterate through values of a PSCustomObject
Measure-Command {
    foreach ($p in $customObject.PSObject.Properties) {
        $p.Value
    }
} | Tee-Object -Variable tsIteratePsCustomObj
```

What's faster?

```powershell
tsd $tsIndexHash $tsPSCustomObject
```

## Considerations

Again, use the right data structure for your use case.

- The use cases are generally different for PSCustomObjects and hashtables.
- Creation of larger hash tables tends to be faster than larger PSCustomObjects.
  * The same tends to be true for iteration.
- PSCustomObjects are a nice convenience we get in PowerShell for objects, not for large dictionaries.

## Fun Fact

You can convert a PSCustomObject to a Hashtable:

```powershell
# Our PSCustomObject (A very simple one)
$obj = [PSCustomObject]@{
    'Name' = 'Bobby'
    'Location' = 'Massachusetts'
}
$obj.GetType()

# Create the hash table then use a foreach loop to walk through each PSCustomObject property and add to the hash table.
$hash = @{}
foreach($p in $obj.PSObject.Properties.Name )
{
    $hash[$p] = $obj.$p
}
$hash.GetType()
```

You can also convert a hashtable to a PSCustomObject:

```powershell
# Create a new empty PSCustomObject with reference to the hash table
$objNew = [PSCustomObject]$hash
```

## Links

- [PowerShell Docs - Everything you want to know about PSCustomObject](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7.4)
- [PowerShell Docs - Everything you want to know about hashtables](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-hashtable?view=powershell-7.4) 
