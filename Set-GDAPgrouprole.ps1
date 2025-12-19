$groupname = "All_Users_For_GDAP_GA"
$Group = "5941edab-088c-45fe-94ae-5ee0b8a1a4f4"
$params = @{
	accessContainer = @{
		accessContainerId = $group
		accessContainerType = "securityGroup"
	}
	accessDetails = @{
		unifiedRoles = @(
			@{
				roleDefinitionId = "62e90394-69f5-4237-9190-012177145e10"
			}
			@{
				roleDefinitionId = "3a2c62db-5318-420d-8d74-23affee5d9d5"
			}
            @{
				roleDefinitionId = "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9"
			}
            @{
				roleDefinitionId = "c4e39bd9-1100-46d3-8c65-fb160da0071f"
			}
            @{
				roleDefinitionId = "194ae4cb-b126-40b2-bd5b-6091b380977d"
			}
            @{
				roleDefinitionId = "fe930be7-5e62-47db-91af-98c3a49a38b1"
			}
            @{
				roleDefinitionId = "5d6b6bb7-de71-4623-b4af-96380a352509"
			}
            @{
				roleDefinitionId = "966707d0-3269-4727-9be2-8c3a10f19b9d"
			}
		)
	}
}

Connect-MgGraph -scope "DelegatedAdminRelationship.Read.All","DelegatedAdminRelationship.ReadWrite.All", "Directory.Read.All"

$gdaprelationships = Get-MgTenantRelationshipDelegatedAdminRelationship | Where Status -eq Active | Select -ExpandProperty Id

ForEach ($gdaprelationship in $gdaprelationships) {

	$gdaprelationshipname = Get-MgTenantRelationshipDelegatedAdminRelationship -gdaprelationship $gdaprelationship | Select -ExpandProperty DisplayName
	Write-Host -ForegroundColor DarkYellow "Assigning GDAP group roles to $groupname for $gdaprelationshipname"
	New-MgTenantRelationshipDelegatedAdminRelationshipAccessAssignment -gdaprelationship $gdaprelationship -BodyParameter $params

}
Disconnect-MgGraph
