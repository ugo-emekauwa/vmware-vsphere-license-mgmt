# VMware vSphere License Update Script, written by Ugo Emekauwa (uemekauw@cisco.com) 

# Start VMware vSphere License Update Script
Write-Output "$(Get-Date) - Starting VMware vSphere License Update Script." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"

# Load VMware Powershell modules
Write-Output "$(Get-Date) - Loading VMware Powershell modules." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
Get-Module -Name VMware* -ListAvailable | Import-Module

# Create variable for new vCenter license
Write-Output "$(Get-Date) - Creating variable for new vCenter license." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$NewvCenterLicense = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"

# Create variable for new ESXi host license
Write-Output "$(Get-Date) - Creating variable for new ESXi host license." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$NewvSphereEnterpriseHostLicense = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"

# Create variable for outdated vCenter license
Write-Output "$(Get-Date) - Creating variable for outdated vCenter license." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$OutdatedvCenterLicense = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"

# Create variable for outdated ESXi host license variable
Write-Output "$(Get-Date) - Creating variable for outdated ESXi host license variable." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$OutdatedvSphereEnterpriseHostLicense = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"

# Create vCenter variable
Write-Output "$(Get-Date) - Creating vCenter variable." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$vCenter = Connect-VIServer -Server 192.168.1.30 -User administrator -Password Password! -Force

# Setup VMware License Manager
Write-Output "$(Get-Date) - Setting up VMware License Manager." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager = Get-View ($vCenter.ExtensionData.Content.LicenseManager)

# Add new vCenter license to vCenter inventory
Write-Output "$(Get-Date) - Adding new vCenter license to vCenter inventory." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager.AddLicense($NewvCenterLicense,$Null)

# Add new ESXi host license to vCenter inventory
Write-Output "$(Get-Date) - Adding new ESXi host license to vCenter inventory." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager.AddLicense($NewvSphereEnterpriseHostLicense,$Null)

# Setup VMware License Assignment Manager
Write-Output "$(Get-Date) - Setting up VMware License Assignment Manager." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$LicenseAssignmentManager = Get-View ($LicenseManager.LicenseAssignmentManager)

# Update assigned vCenter license
Write-Output "$(Get-Date) - Updating assigned vCenter license." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$LicenseAssignmentManager.UpdateAssignedLicense($vCenter.InstanceUuid,$NewvCenterLicense,$Null)

# Remove outdated vCenter license from vCenter inventory
Write-Output "$(Get-Date) - Removing outdated vCenter license from vCenter inventory." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager.RemoveLicense($OutdatedvCenterLicense)

# Remove outdated ESXi host license from vCenter inventory
Write-Output "$(Get-Date) - Removing outdated ESXi host license from vCenter inventory." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager.RemoveLicense($OutdatedvSphereEnterpriseHostLicense)

# Disconnect from vCenter
Write-Output "$(Get-Date) - Disconnecting from vCenter." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
Disconnect-VIServer -Confirm:$false

# Exit VMware vSphere License Update Script
Write-Output "$(Get-Date) - Exiting VMware vSphere License Update Script." | Out-File -Append "c:\logs\vmware-vsphere-license-update.log"
Exit
