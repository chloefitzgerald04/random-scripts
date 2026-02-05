# Register Enterprise APP

Register-PnPEntraIDApp -ApplicationName PnPEntraSharepoint -Tenant "" -Store CurrentUser

# Actually set the region

$SiteURL = ""
$LocaleId = 2057 # UK
$TimeZoneId = 2 # London

$clientid = ""
$thumbprint = ""
$tenantid = ""

# Connect to Admin Center
Connect-PnPOnline $SiteURL -clientID $clientid -Thumbprint $thumbprint -tenant $tenantid

# Get all site collections
$Sites = Get-PnPTenantSite

foreach ($Site in $Sites) {
    Write-Host "Processing site: $($Site.Url)" -ForegroundColor Cyan
    try {
        Connect-PnPOnline $Site.Url -clientID $clientid -Thumbprint $thumbprint -tenant $tenantid
        
        $web = Get-PnPWeb -Includes RegionalSettings, RegionalSettings.TimeZones
        
        # Set Locale and Time Zone
        $web.RegionalSettings.LocaleId = $LocaleId
        $timeZone = $web.RegionalSettings.TimeZones | Where-Object {$_.Id -eq $TimeZoneId}
        $web.RegionalSettings.TimeZone = $timeZone
        
        # Update Web
        $web.Update()
        Invoke-PnPQuery
        
        Write-Host "Updated regional settings for: $($Site.Url)"
    }
    catch {
        Write-Host "Error updating site: $($Site.Url). Error: $($_.Exception.Message)"
    }
}
disconnect-pnponline
