Add-Type -AssemblyName PresentationFramework

$DOMAIN="stermann.co"
$USERNAME="stermann.co"
$SUBDOMAIN=""
$DOMPW="!Schalke1904!"

$PATH="C:\Users\Administrator\StratoUpdater"
$LASTIPFILE="$PATH\LASTEXTIP-Strato"
$UPDATE_URL="http://dyndns.strato.com/nic/update"
$UPDATE_URL_PARAM=""
$DATE = (Get-date -UFormat "%d.%m.%Y - %H:%M" )

$SECPASSWD = ConvertTo-SecureString $DOMPW -AsPlainText -Force
$CREDENTIAL = New-Object System.Management.Automation.PSCredential($USERNAME, $SECPASSWD)

$EXTIP=Invoke-WebRequest -Uri "http://ipecho.net/plain"
$EXTIP=$EXTIP.Content

$UPDATE="https://dyndns.strato.com/nic/update?hostname=${DOMAIN}&myip=${EXTIP}"


$CHECKFILE=Test-Path $LASTIPFILE -PathType Leaf

if ( "$CHECKFILE" -eq "false" )
{
        $EXTIP | Out-File $LASTIPFILE

        $ButtonType = [System.Windows.MessageBoxButton]::OK
        $MessageIcon = [System.Windows.MessageBoxImage]::Information
        $MessageBody = "Dies ist der erste Program start. Initialisierung wurde abgeschlossen. Bitte starten Sie das Program erneut."
        $MessageTitle = "Info"

        [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
        
        exit
}
else 
{
    $LASTIP=type $LASTIPFILE
}


if ( "$LASTIP" -ne "$EXTIP" )
{
    $EXTIP | Out-File $LASTIPFILE

    $RESULT=Invoke-WebRequest -Uri $UPDATE -Credential $CREDENTIAL
        

        if ( "$RESULT.Content" -notmatch "good" )
        {
            Write-Output "$DATE - Fehler, IP konnte nicht aktualisiert werden. CODE: $RESULT" >> "$PATH\StratoUpdate.log"
        }
        else
        {
            Write-Output "$DATE - Update erfolgreich. Neue DynDns IP ist: $EXTIP" >> "$PATH\StratoUpdate.log"
        }
}
else
{
    Write-Output "$DATE - Die IP $LASTIP hat sich nicht verändert. Kein Update notwendig." >> "$PATH\StratoUpdate.log"
}

