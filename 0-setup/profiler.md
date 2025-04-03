# Profiler

## Overview

- Profiler was created by Jakub Jares!  
  * You may remember him from other PowerShell modules such as... Pester!
- Compatible with Windows PowerShell (5) and PowerShell 7+.

---

## Install Profiler

Installing from the PSGallery.

```powershell
# Install Profiler (current version is 4.3.0)
# Why do we trust this module?  Come find out in room 406@2:45PM for...
# "Stop Writing Insecure PowerShell! Seriously."
Install-PSResource -Name Profiler -TrustRepository -Reinstall -Confirm:$false
Get-PSResource -Name Profiler

# What's in the box?
Get-Command -Module Profiler
```

---

## High Level

- `Trace-Script` will trace everything in the `-ScriptBlock` parameter
  * It will trace everything contained within the script block
    + Inclusive of other function calls or other modules leveraged.
