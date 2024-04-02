# PowerShell vs .Net

What does this section mean?

There are a lot of functions and Cmdlets that bubble up functionality that overlaps raw .Net.

For Example:

You can use `New-Guid` _or_ you can use `[System.Guid]::NewGuid()`.

Functionally they will both generate you a GUID.  But is one faster?

---

Generating a GUID.

```powershell
# GUIDs

Measure-Command -Expression {
    New-Guid
} | Tee-Object -Variable pwsh

Measure-Command -Expression {
    [System.Guid]::NewGuid()
} | Tee-Object -Variable dotnet

tsd $pwsh $dotnet
```

---

Parsing a file.

```powershell
# Parsing Moby Dick

Measure-Command -Expression {
    Get-Content -Path ./mobydick.txt
} | Tee-Object -Variable pwsh

Measure-Command -Expression {
    [System.IO.File]::ReadAllText("$pwd/mobydick.txt")
} | Tee-Object -Variable dotnet

tsd $pwsh $dotnet
```

---

`New-Object` versus the type accelerator, creating an `ArrayList`

```powershell
# New-Object vs []

Measure-Command -Expression {
    $al1 = New-Object -TypeName System.Collections.ArrayList
} | Tee-Object -Variable pwsh

Measure-Command -Expression {
    $al2 = [System.Collections.ArrayList]::new()
} | Tee-Object -Variable dotnet

tsd $pwsh $dotnet
```

## Considerations

- The `New-Object` performance win was surprising
- Put some thought into what the code is doing and what option makes the most sense
  * Also consider maintainability of the code, is one easier to read in the given code base?
