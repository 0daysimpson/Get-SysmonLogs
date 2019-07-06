Function Get-SysmonLogs {
    [cmdletbinding()]param(
        $ComputerName,
        $Count = 20,
        $FilePath,
        [array]$Search,
        [datetime]$Since = ((get-date).adddays(-2)),
        [datetime]$Until = (get-date),
        [switch]$File,
        [switch]$Network,
        [switch]$Process,
        [switch]$DNS,
        [switch]$all, [switch]$GetOldest)

    if ($Process) {
        #Process creation and termination
        $EventID = @(1, 2, 5, 10)
    }
    if ($Network) {
        #Network Connections
        $EventID = @(3, 8)
    }
    if ($File) {
        #Network Connections
        $EventID = @(11, 15)
    }
    if ($DNS) {
        #DNS requests
        $EventID = @(22)
    }
    if ((!$DNS) -and (!$File) -and (!$network) -and (!$process) -or $all) { $EventID = 1..22 }

    #allow running  query without search terms
    if ($search -eq $Null) { $Search = "" }
    Foreach ($SearchTerm in $Search) {
        try {
            $HashTable = @{
                logname   = "Microsoft-Windows-Sysmon/Operational";
                StartTime = $Since;
                EndTime   = $Until;
                ID        = $EventID
            }
            if ($FilePath) { $HashTable.Remove("logname"); $HashTable.add("Path", $FilePath) }
            if ($search) { $HashTable.Add("Data", $SearchTerm) }
            if ($ComputerName) {
                if ((Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) -ne $true) { "$computername unreachable at this time"; continue; }
                if (!$GetOldest) {
                    $Events = (Get-WinEvent -FilterHashtable $HashTable -MaxEvents $Count -ComputerName $ComputerName -ErrorAction stop)
                }
                else {
                    $HashTable.Remove("startime");
                    $HashTable.Remove("endtime");
                    $Events = (Get-WinEvent -FilterHashtable $HashTable -MaxEvents 1 -ComputerName $ComputerName -ErrorAction stop -Oldest)
                }
            }
            #For directly loading evtx files 
            else {
                if (!$GetOldest) { $Events = (Get-WinEvent -FilterHashtable $HashTable -MaxEvents $Count -ErrorAction stop) }
                else {
                    $HashTable.Remove("startime");
                    $HashTable.Remove("endtime");
                    (Get-WinEvent -FilterHashtable $HashTable -MaxEvents 1  -ErrorAction stop -Oldest)
                }
            }
    
        }
        catch [exception] {
            if (($_.Exception) -match "No events were found") {
                if ($search.count -gt 1) { continue }
                Write-Output "No results for specified time frame" 
            }
            if (($_.Exception) -match "There is not an event log ") { Write-Output "SysMon is not Installed" }
            else { $_.exception }
        }
        Foreach ($sample in $Events) {
            $Flow = $sample.message.Split("`n")
            #Table Builder
            $SystemEvent = New-Object Psobject -Property @{Name = ($flow[0].replace(':', '')) }
            $EndNumber = ($Flow.Length - 1)
            Foreach ($Item in $flow[-1..$EndNumber]) {
                $HashPair = $Item.Split(":", 2)
                $HashPair.Trim()
                $SystemEvent | add-member -MemberType NoteProperty -name $HashPair[0].Trim()  -value $HashPair[1].Trim() -Force
            }
            $SystemEvent
        }
    }

}
