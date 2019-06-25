# Overview
```
NAME
    Get-SysMonLogs
DESCRIPTION
    A PowerShell client for retrieving and searching Sysmon logs.
SYNTAX
    Get-SysMonLogs [[-ComputerName] <Object>] [[-Count] <Object>] [[-FilePath] <Object>] [[-Search] <array>] 
    [[-Since] <datetime>] [[-Until] <datetime>] [-File] [-Network] [-Process] [-DNS] [-all] 
    [-GetOldest]  [<CommonParameters>]
```    


## Features
* Serializes Sysmon logs into Powershell objects
* Supports remote log retrieval
* Extensible

# Installation

1. Install Sysmon - https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon
2. Configure monitoring rules
3. Import function into `profile.ps1`

# Usage 

## Example 1 - All process events 
 
`PS C:\> Get-SysmonLogs -Process`
```
Name               : Process terminated
Process terminated : 
RuleName           :  
UtcTime            :  2019-06-25 04:00:18.308
ProcessGuid        :  {1ec4209f-9c51-5d11-0000-00108b2d8105}
ProcessId          :  11464
Image              :  C:\Windows\System32\conhost.exe

Name               : Process terminated
Process terminated : 
RuleName           :  
UtcTime            :  2019-06-25 04:00:18.302
ProcessGuid        :  {1ec4209f-9c51-5d11-0000-0010822c8105}
ProcessId          :  21896
Image              :  C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe

Name              : Process Create
Process Create    : 
RuleName          :  
UtcTime           :  2019-06-25 04:00:17.406
ProcessGuid       :  {1ec4209f-9c51-5d11-0000-00108b2d8105}
ProcessId         :  11464
Image             :  C:\Windows\System32\conhost.exe
FileVersion       :  10.0.17763.404 (WinBuild.160101.0800)
Description       :  Console Window Host
Product           :  Microsoft® Windows® Operating System
                        .... snipped ...
ParentImage       :  C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
ParentCommandLine :  powershell.exe  -command "& ...
```

## Example 2 - All DNS requests 

`PS C:\> Get-SysmonLogs -DNS`
```
Name         : Dns query
Dns query    : 
RuleName     :  
UtcTime      :  2019-06-25 03:28:56.281
ProcessGuid  :  {1ec4209f-3533-5d10-0000-001082bcf800}
ProcessId    :  9484
QueryName    :  github-cloud.s3.amazonaws.com
QueryStatus  :  0
QueryResults :  type:  5 s3-1-w.amazonaws.com;52.216.9.235;
Image        :  C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
```


