# Pre-requisites
Set-ExecutionPolicy remotesigned
Install-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement


# Logs in to a tenant
Connect-ExchangeOnline
# Variables
$emails = @("")


# Creates a retention policy for 2 Years by default - equivalent is in purview > solutions > data lifecycle management > Exchange (legacy) > MRM tags and policies
New-RetentionPolicyTag "2 Year Archive" -Type All –RetentionEnabled $true -AgeLimitForRetention 730 -RetentionAction MoveToArchive
New-RetentionPolicy "2 Year Archive" -RetentionPolicyTagLinks "2 Year Archive"

foreach($email in $emails){
    if ((get-mailbox $email | select ArchiveStatus) -notmatch "active"){
        #Enables the online archive - equivalent is in Exchange Online and viewing mailbox > others > Mailbox Archive 
        enable-mailbox  -identity $email -archive

        # Fetches retention hold status and sets it to false
        Get-Mailbox $email | Select-object RetentionHoldEnabled
        Set-Mailbox $email -RetentionHoldEnabled $false

        # Applies Retention policy - equivalent is in Exchange Online and viewing mailbox > Mailbox > Retention policy 
        Set-Mailbox $email -RetentionPolicy "2 Year Archive"
    }
}

# starts / speeds up adding emails into archive and scanning folders 
#Start-ManagedFolderAssistant $email

for($i=0;$i -lt 100;$i++){
    foreach($email in $emails){
        # Fetches it by mailbox UUID if the previous errors with "The call to Mailbox Assistants Service on server...Error from RPC is -2147220992"
        $ui = get-mailboxlocation -user $email -MailboxLocationType Primary
        Start-ManagedFolderAssistant $ui
        get-mailboxstatistics -identity $email -archive | Select-object DisplayName, totalitemsize, itemcount  
    }
    start-sleep -Seconds 120
}


