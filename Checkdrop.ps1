
Test-Path System.DefaultWorkingDirectory/_testweb-CI/drop/Webapp

Write-Output "=============================================================================================================="

$location = Get-Location

Write-Output $location

Write-Output "==============================================================================================================="


Get-ChildItem "$location/drop/Terraform"
