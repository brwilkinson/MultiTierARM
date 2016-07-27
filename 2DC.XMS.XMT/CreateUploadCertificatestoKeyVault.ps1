#
# CreateUploadCertificatestoKeyVault.ps1
#
$kVaultName = 'kvContoso'
$rgName = 'rgContosoGlobal'
$CertPath = 'D:\Azure'
#--------------------------------------------------------
# Create Web cert *.contoso.com
$cert = New-SelfSignedCertificate -DnsName *.contoso.com -CertStoreLocation Cert:\LocalMachine\My
$cert
$PW = read-host -AsSecureString
Export-PfxCertificate -Password $PW -FilePath $CertPath\contosowildcard.pfx -Cert $cert
Export-Certificate -FilePath $CertPath\contosowildcard.cer -Cert $cert 

#--------------------------------------------------------
# Create encryption/decryption cert (Windows 10/2016 only)
$cert2 = New-xSelfSignedDscEncryptionCertificate -EmailAddress brw@contoso.com `
                -ValidityYears 5 -ExportFilePath $CertPath\contosoEncrypt.cer
$cert2
Export-PfxCertificate -Password $PW -FilePath $CertPath\contosoDecrypt.pfx -Cert $cert2

#--------------------------------------------------------
# Upload certs to KeyVault

$FileName = "$CertPath\contosowildcard.pfx"
$fileName = "$CertPath\contosoDecrypt.pfx"
$certPassword = Read-Host -Prompt EnterPlainTextPassword

$fileContentBytes = get-content $fileName -Encoding Byte
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)

$jsonObject = @"
 {
 "data"     : "$filecontentencoded",
 "dataType" : "pfx",
 "password" : "$certPassword"
 }
"@

$jsonObjectBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonObject)
$jsonEncoded     = [System.Convert]::ToBase64String($jsonObjectBytes)

$secret = ConvertTo-SecureString -String $jsonEncoded -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $kVaultName -Name contosoDecrypt -SecretValue $secret

$contosoDecrypt = Get-AzureKeyVaultSecret -VaultName $kVaultName -Name contosoDecrypt
$contosoDecrypt.Id
# e.g. https://kvcontoso.vault.azure.net:443/secrets/contosoDecrypt

$contosowildcard = Get-AzureKeyVaultSecret -VaultName $kVaultName -Name contosowildcard
$contosowildcard.Id
# e.g. https://kvcontoso.vault.azure.net:443/secrets/contosowildcard

#--------------------------------------------------------

Set-AzureRmKeyVaultAccessPolicy -VaultName $kVaultName -ResourceGroupName $rgName -EnabledForDeployment -EnabledForTemplateDeployment -EnabledForDiskEncryption
Get-AzureRMKeyVault -VaultName $kVaultName

#Set-AzureKeyVaultAccessPolicy -VaultName kvContoso -ServicePrincipalName '8b58c31d-7cab-4152-979b-096f8f88621e' -PermissionsToKeys all