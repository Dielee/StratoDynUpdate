$DOMAIN="deinedomain.de"
$USERNAME="deinedomain.de"
$SUBDOMAIN=""
$DOMPW="deintratopw"

$LASTIPFILE="LASTEXTIP-Strato"
$UPDATE_URL="http://dyndns.strato.com/nic/update"
$UPDATE_URL_PARAM=""

$SECPASSWD = ConvertTo-SecureString $DOMPW -AsPlainText -Force
$CREDENTIAL = New-Object System.Management.Automation.PSCredential($USERNAME, $SECPASSWD)

$EXTIP=Invoke-WebRequest -Uri "http://ipecho.net/plain"
$EXTIP=$EXTIP.Content

$UPDATE="https://dyndns.strato.com/nic/update?hostname=${DOMAIN}&myip=${EXTIP}"

$LASTIP=type $LASTIPFILE

if ( "$LASTIP" -ne "$EXTIP" )
{
    $EXTIP | Out-File $LASTIPFILE

    $RESULT=Invoke-WebRequest -Uri $UPDATE -Credential $CREDENTIAL
}


if ( "$RESULT.Content" -notmatch "good" )
{
    Write-Host "Fehler, IP konnte nicht aktualisiert werden. CODE: $RESULT"
}
else
{
    Write-Host "Update erfolgreich. Neue DynDns IP ist: $EXTIP"
}