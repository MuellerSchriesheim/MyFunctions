﻿# Changelog MyFunctions Modul

## 0.5.0 - 24.08.2018

### Added

- Export-ADUserToExcel
  Exports all User from AD to Excel.

- Import-ADUserFromExcel
  Read the Content from a special XLSX File and changes the according attributes in the Active Directory
  Before the import the Script checks what user and attributes are chaning and informs the user about the
  upcomming changes.

## 0.4.0 - 21.08.2018

### Added

- Get-PhoneList
  Retrieves the Phonelist from an  iDoit API Report

- Publish-PhoneList
  Uploads the Phonelist Files to our Intranetserver

## 0.3.0 - 15.08.2018

### Added

- New-EncryptedZipUsing7Zip
  Creates a new ZIP File encrypted with a password. Uses 7zip for compression.

- Update-PSFConfig
  Run through all the settings of a module to set or update settings and export
  them back to the central setting repository

## 0.2.0 - 14.08.2018

### Added

- Save-PSFConfig
  Saves a Module from PSF Configuration into the Powershell Configuration Path.
  From the Configuration path the configuration.ps1 of a the modul loads the Configuration Values

- Get-IpMac
  Return the IP and MAC Adress for an Computername. Can piped to Get-ImcSwitchPort

- Get-ImcSwitchPort
  Queries the IMC API for the Switch and Port where the device is connected.

## 0.1.0 - 13.08.2018

### Added

- Inital Release
