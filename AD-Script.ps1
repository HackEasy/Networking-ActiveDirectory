#        Th3 M4d_Sc13nT15t is here to stay...
#    We trust you have received teh usual lecture
#        from the local System Administrator. 
#   It usually boils down to these three things:
#       #1) Respect the privacy of others.
#       #2) Think before you type.
#       #3) With great poewr comes great responsibility.


Get-ADGroup -filter * -Properties * | Select SamAccountName, Description |
Export-csv C:\Users\$ENV:Username\Desktop\ADGroups.csv -NoTypeInformation -Encoding UTF8

cls
Write-Host "Starting Export.. The script is estimated to take about 30 minutes to complete." -ForegroundColor Green
$ErrorActionPreference= 'silentlycontinue'

$csv = Import-csv C:\Users\$ENV:Username\Desktop\ADGroups.csv 

foreach ($row in $csv) {
    Get-ADGroupMember -Identity $row.SamAccountName |
        Get-ADObject -Properties * |
        Select-Object @{Name="Type";Expression={$_.ObjectClass}},
        @{Name="Full Name";Expression={$_.DisplayName}},
            @{Name="Username";Expression={$_.SamAccountName}},
            @{Name="Company";Expression={$_.Company}},
            @{Name="Department";Expression={$_.Department}},
            @{Name="Title";Expression={$_.Title}},
            @{Name="Manager";Expression={(Get-ADUser -property DisplayName $_.Manager).DisplayName}},
        @{Name="Managers initials";Expression={(Get-ADUser -property SamAccountName $_.Manager).SamAccountname}},
        @{Name="Last logon date";Expression={(Get-ADUser -property LastLogonDate $_.SamAccountName).LastLogonDate}},
        @{Name="Last password change";Expression={(Get-ADUser -property PasswordLastSet $_.SamAccountName).PasswordLastSet}},
            @{Name="Groupname";Expression={$row.SamAccountName}},
            @{Name="Group description";Expression={$row.Description}} |
Export-csv "C:\Users\$ENV:Username\Desktop\Export.csv" -NoTypeInformation -Encoding UTF8 -Append}