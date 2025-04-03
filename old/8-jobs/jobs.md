# Jobs

There are different kinds of jobs in PowerShell.

- Jobs
  * Introduced in PowerShell 2.0
  * Will run each job in a seperate process (use top/task manager to see)
- Thread Jobs
  * Introduced in PowerShell 6.1
  * Creates background jobs in separate threads but within the **same** PowerShell (pwsh) process

## Side by Side

This first example is from the `Start-ThreadJob` [PowerShell docs](https://learn.microsoft.com/en-us/powershell/module/threadjob/start-threadjob?view=powershell-7.2#example-2-compare-the-performance-of-start-job-and-start-threadjob).
I've made a couple tweaks to it but it's fundamentally the same thing.

```powershell
# Start-Sleep
# Job
Measure-Command {
    1..20 | ForEach-Object {Start-Job {Start-Sleep 1}} | Wait-Job
} | Tee-Object -Variable job

# Thread Job
Measure-Command {
    1..20 | ForEach-Object {Start-ThreadJob {Start-Sleep 1}} | Wait-Job
} | Tee-Object -Variable threadJob

tsd $job $threadJob

# Let's use the Fibonacci sequence
. ./Get-Fibonacci.ps1
# We'll get the 19th number in the Fibonacci sequence 10 times
1..10 | ForEach-Object {Get-Fibonacci -Number 19} 

# I don't know if Summit will allow the screen realestate...
# ... but if we can btop we should!

# Fibonacci with Start-Job and Start-ThreadJob
# Job
Measure-Command {
    1..10 | ForEach-Object {
        Start-Job {
            Get-Fibonacci -Number 19    
        }
    }
} | Tee-Object -Variable job

# Thread Job
Measure-Command {
    1..10 | ForEach-Object {
        Start-ThreadJob {
            Get-Fibonacci -Number 19
        }
    }
} | Tee-Object -Variable threadJob

tsd $job $threadJob
```

## Considerations

- Use `Start-Job` if what you are running will benefit more from executing in a separate process
- Use `Start-Job` if the overhead of new PowerShell processes isn't going to be a concern
- Use `Start-Job` if you're in an environment before `Start-ThreadJob` exists
- use `Start-Job` if there is a concern that one _thread_ will crash the process if using `Start-ThreadJob`
- Use `Start-ThreadJob` if you have resource concerns of launching multiple PowerShell processes
- Use `Start-ThreadJob` if what you are processing lends itself better to running with multiple threads in a single process

## Link

- [Github](https://github.com/PaulHigin/PSThreadJob)
