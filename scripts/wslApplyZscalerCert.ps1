#########################################################################
# What this script does							#
# 1. Installs Zscaler Certificate on Ubuntu wsl distros.                #
# Author : Amar Deep Singh (amar.deep.singh@mmc.com)			#
# Version: 0.1								#
# From: https://github.com/mmctech/mmc-developer-utility-scripts
#########################################################################

echo "Detected following Wsl Linux Distro Installed on your machine."
echo "*************************************************************"
wsl --list --verbose
echo "*************************************************************"

$options = @("Ubuntu", "Ubuntu-20.04", "Ubuntu-22.04")

Write-Host "Please choose the Linux Distro on Your machine to fix DNS issues:"
for ($i=0; $i -lt $options.Length; $i++) {
    Write-Host ("[{0}] {1}" -f ($i+1), $options[$i])
}

do {
    $choice = Read-Host "Please choose a number between 1 and 3. default is Ubuntu, simply press Enter for Ubuntu" 
    if ($choice -eq "") {
        $chosenOption = "Ubuntu"
        Write-Host "You did not select any option. Setting default to '$chosenOption'"
        break
    }
    $intChoice = [int]$choice
    if ($intChoice -ge 1 -and $intChoice -le $options.Length) {
        $chosenOption = $options[$intChoice - 1]
        Write-Host "You chose '$chosenOption'"
    } else {
        Write-Host "Invalid choice. Please choose a number between 1 and $($options.Length)"
    }
} until ($chosenOption -ne $null)

if ($chosenOption -eq "Ubuntu") {
    wsl --set-default Ubuntu
} else {
    wsl --set-default $chosenOption
}

$userHome=[Environment]::GetFolderPath("UserProfile")
$ShellScriptPath=$userHome+"\setUpZscaler.sh"

function ReplaceTextInFile($fileName, $originalText, $newText) {
	$original_file = $fileName
	$text = [IO.File]::ReadAllText($original_file) -replace $originalText, $newText
	[IO.File]::WriteAllText($original_file, $text)
}

function FindDNSServerIPAddress() {
	$dnsServerIP = (Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses
	Write-Host "Detecting DNS Servers on Windows Host..."
	#$dnsServerIP = (Get-DnsClientServerAddress).ServerAddresses
	return $dnsServerIP
}


function GenerateShellScript($ShellScriptPath) {
	Write-Host "Generating Shell Script....."
	$ShellScriptContentPart1 = @" 
#!/bin/bash

# Install Zscaler root certificate

echo "-----BEGIN CERTIFICATE-----
MIIE0zCCA7ugAwIBAgIJANu+mC2Jt3uTMA0GCSqGSIb3DQEBCwUAMIGhMQswCQYD
VQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTERMA8GA1UEBxMIU2FuIEpvc2Ux
FTATBgNVBAoTDFpzY2FsZXIgSW5jLjEVMBMGA1UECxMMWnNjYWxlciBJbmMuMRgw
FgYDVQQDEw9ac2NhbGVyIFJvb3QgQ0ExIjAgBgkqhkiG9w0BCQEWE3N1cHBvcnRA
enNjYWxlci5jb20wHhcNMTQxMjE5MDAyNzU1WhcNNDIwNTA2MDAyNzU1WjCBoTEL
MAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExETAPBgNVBAcTCFNhbiBK
b3NlMRUwEwYDVQQKEwxac2NhbGVyIEluYy4xFTATBgNVBAsTDFpzY2FsZXIgSW5j
LjEYMBYGA1UEAxMPWnNjYWxlciBSb290IENBMSIwIAYJKoZIhvcNAQkBFhNzdXBw
b3J0QHpzY2FsZXIuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
qT7STSxZRTgEFFf6doHajSc1vk5jmzmM6BWuOo044EsaTc9eVEV/HjH/1DWzZtcr
fTj+ni205apMTlKBW3UYR+lyLHQ9FoZiDXYXK8poKSV5+Tm0Vls/5Kb8mkhVVqv7
LgYEmvEY7HPY+i1nEGZCa46ZXCOohJ0mBEtB9JVlpDIO+nN0hUMAYYdZ1KZWCMNf
5J/aTZiShsorN2A38iSOhdd+mcRM4iNL3gsLu99XhKnRqKoHeH83lVdfu1XBeoQz
z5V6gA3kbRvhDwoIlTBeMa5l4yRdJAfdpkbFzqiwSgNdhbxTHnYYorDzKfr2rEFM
dsMU0DHdeAZf711+1CunuQIDAQABo4IBCjCCAQYwHQYDVR0OBBYEFLm33UrNww4M
hp1d3+wcBGnFTpjfMIHWBgNVHSMEgc4wgcuAFLm33UrNww4Mhp1d3+wcBGnFTpjf
oYGnpIGkMIGhMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTERMA8G
A1UEBxMIU2FuIEpvc2UxFTATBgNVBAoTDFpzY2FsZXIgSW5jLjEVMBMGA1UECxMM
WnNjYWxlciBJbmMuMRgwFgYDVQQDEw9ac2NhbGVyIFJvb3QgQ0ExIjAgBgkqhkiG
9w0BCQEWE3N1cHBvcnRAenNjYWxlci5jb22CCQDbvpgtibd7kzAMBgNVHRMEBTAD
AQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAw0NdJh8w3NsJu4KHuVZUrmZgIohnTm0j+
RTmYQ9IKA/pvxAcA6K1i/LO+Bt+tCX+C0yxqB8qzuo+4vAzoY5JEBhyhBhf1uK+P
/WVWFZN/+hTgpSbZgzUEnWQG2gOVd24msex+0Sr7hyr9vn6OueH+jj+vCMiAm5+u
kd7lLvJsBu3AO3jGWVLyPkS3i6Gf+rwAp1OsRrv3WnbkYcFf9xjuaf4z0hRCrLN2
xFNjavxrHmsH8jPHVvgc1VD0Opja0l/BRVauTrUaoW6tE+wFG5rEcPGS80jjHK4S
pB5iDj2mUZH1T8lzYtuZy0ZPirxmtsk3135+CKNa2OCAhhFjE0xd
-----END CERTIFICATE-----
" > /usr/local/share/ca-certificates/Zscaler.crt
sudo update-ca-certificates
"@

	# Generate the Shell script
	Set-Content -Path $ShellScriptPath -Value $ShellScriptContentPart1	
}

# Generate Shell Scripts with dns ip address
GenerateShellScript $ShellScriptPath

# Replce Windows style CRLF with UNIX style LF in geterated shell script
ReplaceTextInFile $ShellScriptPath "`r`n" "`n"

# Make selected Linux default
wsl --setdefault $chosenOption

# Go to Home directory Run the shell script
cd $userHome
Write-Host "Applying Zscaler certs, please enter your password when prompted"
wsl sudo ./setUpZscaler.sh
Write-Host "Testing internet connectivity..."
wsl ping -c 5 google.com
