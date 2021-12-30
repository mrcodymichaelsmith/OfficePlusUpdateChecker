 
 #Logic Check
 $ConfirmDaComp = $null
 #Computer we are searching for updates on 
 $DaComp = $null


 #Assignes Value to $DaComp and makes sure it is online 
 while( $ConfirmDaComp -ne 'y' ){
    $DaComp = Read-Host -Prompt 'Enter the computer you would like an update report from'

    if( -not ( Test-Connection -ComputerName $DaComp -Count 2 -Quiet ) ){
        Write-Warning "$FromComputer is not online. Please enter another computer name."
        continue
        }

    $ConfirmDaComp = Read-Host -Prompt "The entered computer name was:`t$DaComp`r`nIs this correct? (y/n)"
    }

#Ensures that there is a value for $DaComp
if( $DaComp -ne $null) {
#Gets all software updates from MECM. Makes a pretty table and then places updates in text file with the date command was run. 
 get-wmiobject -computername $DaComp `
 -query "SELECT * FROM CCM_UpdateStatus where Status = 'installed'"  -namespace "root\ccm\SoftwareUpdates\UpdatesStore" `
 | sort-object -property article -unique `
 | Format-Table -Property Bulletin,Article,Title -Autosize `
 | out-file "$DaComp Update Report $(get-date -f yyyy-MM-dd).txt" 
 }

 