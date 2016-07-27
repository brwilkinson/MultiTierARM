#
# CreateKeyVaultAndStoreSecrets.ps1
#
$kVaultName = 'kvContoso'
$rgName = 'rgContosoGlobal'
$location = 'EastUS'
$AdminUserName = 'EricLang'

New-AzureRmResourceGroup -Name $rgName -Location $Location
Get-AzureRmResourceGroup -Name $rgName -Location $Location 

New-AzureRmKeyVault -ResourceGroupName $rgName -VaultName $kVaultName -Location eastus -Sku premium -EnabledForTemplateDeployment
#Get-AzureRmKeyVault -VaultName contoso -ResourceGroupName rgglobal | Remove-AzureRmKeyVault

$Secret = Read-Host -AsSecureString -Prompt "Enter the Password for $AdminUserName"
Set-AzureKeyVaultSecret -VaultName $kVaultName -Name $AdminUserName -SecretValue $Secret -ContentType txt
#Set-AzureKeyVaultSecret -VaultName "Contoso" -Name "ITSecret" -SecretValue $Secret -Expires $Expires -NotBefore $NBF -ContentType $ContentType -Enable $True -Tags $Tags -PassThru

$contosokey = Get-AzureKeyVaultSecret -VaultName $kVaultName -Name $AdminUserName
$contosokey.Id
$contosokey.SecretValue      # SecureString
$contosokey.SecretValueText  # Text
$contosokey | gm
$contosokey | select *

# most recent key
# E.g. https://kvcontoso.vault.azure.net:443/secrets/ericlang

# specific version of key
# E.g. https://kvcontoso.vault.azure.net:443/secrets/ericlang/afa351084bba48449cc5deb984c7c4a1
