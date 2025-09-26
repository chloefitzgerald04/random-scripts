
import-Module AzureAD
Connect-AzureAD

# Define the users and get their OIDs
$Source = ""
$Target  = "" 
$groupsadded = 0

$SourceObj = Get-AzureADUser -ObjectID $Source
$TargetObj = Get-AzureADUser -ObjectID $Target

# Get list of groups for both users 
$SourceSecGroups = (Get-AzureADUserMembership -ObjectId $SourceObj.ObjectId -all $true | Where-object { $_.ObjectType -eq "Group" })
$TargetSecGroups = (Get-AzureADUserMembership -ObjectId $TargetObj.ObjectId -all $true | Where-object { $_.ObjectType -eq "Group" })

foreach ($SourceSecGroup in $SourceSecGroups) {
    # Compare whether user has the group 
    if ($SourceSecGroup -notin $TargetSecGroups){
        # Add group from source to target
        Add-azureADGroupMember -ObjectId $SourceSecGroup.ObjectId -RefObjectId $TargetObj.ObjectId -ErrorAction SilentlyContinue
        write-host "Adding $($sourcesecgroup.description) to $Target" -ForegroundColor yellow
        $groupsadded += 1
    } else {
        write-host "$Target already in $($sourcesecgroup.description). Skipping...." -ForegroundColor green
    }
}
Write-host "`n`n--------------------------------------------------------------------"
Write-host "Total groups added: $groupsadded"
Write-host "--------------------------------------------------------------------"

