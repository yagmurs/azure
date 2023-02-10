<#
    reference article

    https://techcommunity.microsoft.com/t5/integrations-on-azure-blog/grant-graph-api-permission-to-managed-identity-object/ba-p/2792127#:~:text=Managed%20identities%20provide%20an%20identity%20for%20applications%20to,principal%20object%20in%20Azure%20or%20using%20Managed%20Identity.

#>

$tenantID="<Tenant Id>"
$graphAppId = "00000003-0000-0000-c000-000000000000"
$displayNameOfManagedIdentityName="<Automation-Account-Name>"
$permissionName = "Directory.Read.All"

Connect-AzureAD -TenantId $TenantID #this required for last line
$managedIdentity = (Get-AzADServicePrincipal -Filter "displayName eq '$displayNameOfManagedIdentityName'")
#Start-Sleep -Seconds 10
$graphServicePrincipal = Get-AzADServicePrincipal -Filter "appId eq '$graphAppId'"
$appRole = $graphServicePrincipal.AppRole | Where-Object {$_.Value -eq $permissionName -and $_.AllowedMemberType -contains "Application"}
New-AzureAdServiceAppRoleAssignment -ObjectId $managedIdentity.Id -PrincipalId $managedIdentity.Id -ResourceId $graphServicePrincipal.Id -Id $appRole.Id

try {
    
}
catch {
    Write-Error -Message ''
}