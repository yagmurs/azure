$tenantID="<Tenant Id>"
$graphAppId = "00000003-0000-0000-c000-000000000000"
$displayNameOfManagedIdentityName="<Automation-Account-Name>"
$permissionName = "Directory.Read.All"

Connect-AzureAD -TenantId $TenantID
$managedIdentity = (Get-AzADServicePrincipal -Filter "displayName eq '$displayNameOfManagedIdentityName'")
#Start-Sleep -Seconds 10
$graphServicePrincipal = Get-AzADServicePrincipal -Filter "appId eq '$graphAppId'"
$appRole = $graphServicePrincipal.AppRole | Where-Object {$_.Value -eq $permissionName -and $_.AllowedMemberType -contains "Application"}
New-AzureAdServiceAppRoleAssignment -ObjectId $managedIdentity.Id -PrincipalId $managedIdentity.Id -ResourceId $graphServicePrincipal.Id -Id $appRole.Id