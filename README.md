# windowsIMDS

Some example Powershell scripts for obtaining metadata from Cloud providers

```
$Uri = "https://raw.githubusercontent.com/spottsmorpheus/windowsIMDS/refs/heads/main/src/GetIMDS.ps1"
$ProgressPreference = "SilentlyContinue"
# Load Powershell code from GitHub Uri and invoke as a temporary Module
$Response = Invoke-WebRequest -Uri $Uri -UseBasicParsing
if ($Response.StatusCode -eq 200) {
    $Module = New-Module -Name "windowsIDMS" -ScriptBlock ([ScriptBlock]::Create($Response.Content))
}
```


Work in progress
