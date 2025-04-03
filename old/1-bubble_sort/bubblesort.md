# The Elephant in the Room

Looking at performance with the [Bubble Sort](https://en.wikipedia.org/wiki/Bubble_sort) sorting algorithm.

The Powershell function and the Go program are both doing the same things:

- Takes a parameter for a file as input _(This file is a list of numbers)_
- Validates the file passed in exists
- Parses the file and converts the numbers from `string` to `int`
- Performs the bubble sort on it and outputs the sorted list

## Setup

```powershell
# Compile Go Program
bat ./gobubblesort/main.go
go build -o bubblesort ./gobubblesort/main.go

# Dot Source PowerShell Function
bat ./Invoke-BubbleSort.ps1
. ./Invoke-BubbleSort.ps1

# View the test data set
bat numlist_10.txt

# Ensure our functions/programs are working
./bubblesort --file ./numlist_10.txt 
Invoke-BubbleSort -File ./numlist_10.txt
```

## Run It

Let's see how they stack up!

```powershell
# 100 numbers
Measure-Command -Expression {./bubblesort --file ./numlist_100.txt} | Tee-Object -Variable go
Measure-Command -Expression {Invoke-BubbleSort -File ./numlist_100.txt} | Tee-Object -Variable pwsh
tsd $go $pwsh

# 1000
Measure-Command -Expression {./bubblesort --file ./numlist_1000.txt} | Tee-Object -Variable go
Measure-Command -Expression {Invoke-BubbleSort -File ./numlist_1000.txt} | Tee-Object -Variable pwsh
tsd $go $pwsh

# 10000
Measure-Command -Expression {./bubblesort --file ./numlist_10000.txt} | Tee-Object -Variable go
Measure-Command -Expression {Invoke-BubbleSort -File ./numlist_10000.txt} | Tee-Object -Variable pwsh
tsd $go $pwsh
```

## Fun Facts!

Fun fact! You can always learn something.
I learned the following when writing the PowerShell function.

`Sort` is an unapproved verb despite the `Sort-Object` Cmdlet. Background [PowerShell Github Issue 3370](https://github.com/PowerShell/PowerShell/issues/3370#issuecomment-295010104)

## Conclusion

If you need raw performance PowerShell is NOT the language you'd likely want to use.

But wait, there is hope!  Within the realm of PowerShell we can make it faster!
