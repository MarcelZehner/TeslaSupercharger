#Connect and select Azure subscription
Login-AzureRmAccount
Select-AzureRmSubscription d-sub-main-01

#Prepare resource group and deploy
$rg = New-AzureRmResourceGroup -Location "West Europe" -Name "d-rgr-teslademo-01"
$rgd = New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $rg.ResourceGroupName `
    -TemplateFile .\master.json `
    -TemplateParameterFile .\master.parameters.json
$rgd