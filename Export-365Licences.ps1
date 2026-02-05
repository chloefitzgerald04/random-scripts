Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -NoWelcome
Write-host "Connected to Graph"

#Path sets the Output location of the CSV file.
$path = "C:\temp\Licences-$(Get-Date -format "MM-dd-yyyy").csv"

#Hashmap containing all licenses in their tenant and a user friendly translation
$skuMap = @{
    "24c35284-d768-4e53-84d9-b7ae73dddf69" = "Microsoft 365 Business Premium (Donation)";
    "cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46" = "Microsoft 365 Business Premium";
    "3b555118-da6a-4418-894f-7df1e2096870" = "Microsoft 365 Business Basic";
    "078d2b04-f1bd-4111-bbd4-b4b1b354cef4" = "Microsoft Entra ID P1";
    "4ef96642-f096-40de-a3e9-d83fb2f90211" = "Microsoft Defender for Office 365 (Plan 1)";
    "f30db892-07e9-47e9-837c-80727f46fd3d" = "Microsoft Power Automate Free";
    "6634e0ce-1a9f-428c-a498-f84ec7b8aa2e" = "Office 365 E2";
    "a403ebcc-fae0-4ca2-8c8c-7a907fd6c235" = "Microsoft Fabric (Free)";

}

#Fetch all users with properties as below
$users = Get-MgUser `
    -All `
    -ConsistencyLevel eventual `
    -Property "UserPrincipalName,DisplayName,AssignedLicenses,EmployeeId"
Write-host "Users fetched: "$users.count

$licensedUsers = $users | Where-Object { $_.AssignedLicenses.Count -gt 0 }

$results = foreach ($user in $licensedUsers) {
    $licenses = foreach ($assigned in $user.AssignedLicenses) {
        $skuId = $assigned.SkuId.ToString().ToLower()
        if ($skuMap.ContainsKey($skuId)) {
            $skuMap[$skuId]
        } else {
            $skuId
        }
    }

    [PSCustomObject]@{
        UserPrincipalName = $user.UserPrincipalName
        DisplayName       = $user.DisplayName
        EmployeeId        = $user.EmployeeId
        AssignedLicenses  = ($licenses -join ", ")
    }
}

# Export to CSV
$results | Export-Csv -Path $path -NoTypeInformation -Encoding UTF8


Disconnect-MgGraph
Start-Process -FilePath "excel" -ArgumentList $path
