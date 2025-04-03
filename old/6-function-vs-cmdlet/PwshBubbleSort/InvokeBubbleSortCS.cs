using System;
using System.IO;
using System.Management.Automation;

namespace PwshBubbleSort
{
    // Declare the cmdlet name, verb (Invoke), and noun (BubbleSort)
    [Cmdlet(VerbsLifecycle.Invoke, "BubbleSortCS")]
    public class InvokeBubbleSortCmdlet : PSCmdlet
    {
        // Declare the parameters and attributes
        [Parameter(Mandatory = true, ValueFromPipelineByPropertyName = true, Position = 0, HelpMessage = "Path to the file containing numbers to sort.")]
        public string File { get; set; }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();
            
            try
            {
                string currentDirectory = this.SessionState.Path.CurrentFileSystemLocation.Path;
                string fullPath = Path.Combine(currentDirectory, this.File);
                string resolvedFilePath = Path.GetFullPath(fullPath);

                WriteVerbose($"Resolved file path: {resolvedFilePath}");

                if (!System.IO.File.Exists(resolvedFilePath))
                {
                    throw new FileNotFoundException($"Could not find file: {resolvedFilePath}");
                }

                int[] numbers = Array.ConvertAll(System.IO.File.ReadAllLines(resolvedFilePath), int.Parse);
                BubbleSort(numbers);

                foreach (int num in numbers)
                {
                    WriteObject(num);
                }
            }
            catch (Exception ex)
            {
                WriteError(new ErrorRecord(ex, "FileReadError", ErrorCategory.OpenError, this.File));
            }
        }

        private void BubbleSort(int[] numbers)
        {
            int n = numbers.Length;
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < n - i - 1; j++)
                {
                    if (numbers[j] > numbers[j + 1])
                    {
                        // Swap the numbers
                        int temp = numbers[j];
                        numbers[j] = numbers[j + 1];
                        numbers[j + 1] = temp;
                    }
                }
            }
        }
    }
}
