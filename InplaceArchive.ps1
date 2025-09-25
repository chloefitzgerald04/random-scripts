# Not to be run as one file, run selectively

# Variables
$email = ""

# Pre-requisites
Set-ExecutionPolicy remotesigned
Install-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement

# Logs in to a tenant
Connect-ExchangeOnline


#Enables the online archive - equivalent is in Exchange Online and viewing mailbox > others > Mailbox Archive 
enable-mailbox  -identity $email -archive

# Fetches retention hold status and sets it to false
Get-Mailbox $email | Select-object RetentionHoldEnabled
Set-Mailbox $email -RetentionHoldEnabled $false

# Creates a retention policy for 2 Years by default - equivalent is in purview > solutions > data lifecycle management > Exchange (legacy) > MRM tags and policies
New-RetentionPolicyTag "2 Year Archive" -Type All –RetentionEnabled $true -AgeLimitForRetention 730 -RetentionAction MoveToArchive
New-RetentionPolicy "2 Year Archive" -RetentionPolicyTagLinks "2 Year Archive"

# Applies Retention policy - equivalent is in Exchange Online and viewing mailbox > Mailbox > Retention policy 
Set-Mailbox $email -RetentionPolicy "2 Year Archive"


# starts / speeds up adding emails into archive and scanning folders 
Start-ManagedFolderAssistant $email
# Fetches it by mailbox UUID if the previous errors with "The call to Mailbox Assistants Service on server...Error from RPC is -2147220992"
$ui = get-mailboxlocation -user $email -MailboxLocationType Primary
Start-ManagedFolderAssistant $ui

# Displays archive status
get-mailboxstatistics -identity $email -archive | Select-object DisplayName, totalitemsize, itemcount
