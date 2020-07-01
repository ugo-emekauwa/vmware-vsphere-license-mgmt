# VMware vSphere License Update Script, written by Ugo Emekauwa (uemekauw@cisco.com) 

# Start VMware vSphere License Update Script
write-output "$(get-date) - Starting VMware vSphere License Update Script." | out-file -append "c:\logs\vmware-vsphere-license-update.log"

# Load VMware Powershell modules
write-output "$(get-date) - Loading VMware Powershell modules." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
Get-Module -Name VMware* -ListAvailable | Import-Module

# Create variable for new vCenter license
write-output "$(get-date) - Creating variable for new vCenter license." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$NewvCenterLicense = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"

# Create variable for new ESXi host license
write-output "$(get-date) - Creating variable for new ESXi host license." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$NewvSphereEnterpriseHostLicense = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"

# Create variable for outdated vCenter license
write-output "$(get-date) - Creating variable for outdated vCenter license." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$OutdatedvCenterLicense = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"

# Create variable for outdated ESXi host license variable
write-output "$(get-date) - Creating variable for outdated ESXi host license variable." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$OutdatedvSphereEnterpriseHostLicense = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"

# Create vCenter variable
write-output "$(get-date) - Creating vCenter variable." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$vCenter = Connect-VIServer -Server 192.168.1.30 -User administrator -Password Password! -Force

# Setup VMware License Manager
write-output "$(get-date) - Setting up VMware License Manager." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager = Get-View ($vCenter.ExtensionData.Content.LicenseManager)

# Add new vCenter license to vCenter inventory
write-output "$(get-date) - Adding new vCenter license to vCenter inventory." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager.AddLicense($NewvCenterLicense,$Null)

# Add new ESXi host license to vCenter inventory
write-output "$(get-date) - Adding new ESXi host license to vCenter inventory." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager.AddLicense($NewvSphereEnterpriseHostLicense,$Null)

# Setup VMware License Assignment Manager
write-output "$(get-date) - Setting up VMware License Assignment Manager." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$LicenseAssignmentManager = Get-View ($LicenseManager.LicenseAssignmentManager)

# Update assigned vCenter license
write-output "$(get-date) - Updating assigned vCenter license." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$LicenseAssignmentManager.UpdateAssignedLicense($vCenter.InstanceUuid,$NewvCenterLicense,$Null)

# Remove outdated vCenter license from vCenter inventory
write-output "$(get-date) - Removing outdated vCenter license from vCenter inventory." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager.RemoveLicense($OutdatedvCenterLicense)

# Remove outdated ESXi host license from vCenter inventory
write-output "$(get-date) - Removing outdated ESXi host license from vCenter inventory." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
$LicenseManager.RemoveLicense($OutdatedvSphereEnterpriseHostLicense)

# Disconnect from vCenter
write-output "$(get-date) - Disconnecting from vCenter." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
Disconnect-VIServer -Confirm:$false

# Exit VMware vSphere License Update Script
write-output "$(get-date) - Exiting VMware vSphere License Update Script." | out-file -append "c:\logs\vmware-vsphere-license-update.log"
Exit
