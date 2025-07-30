:: ----------------------------------------------------------------------------
:: @file    start.settings.bat
:: @author  (c) 2025 by paule32 - Jens Kallup
::          all rights reserved.
::
:: @brief   This file is part of the HelpNDoc.com Tools.
:: @details To use the HelpNDoc.com Tools you must have as munimum the HelNDoc
::          Professional Version. Ultimate is recommend.
::          This script is optimized for Microsoft Windows 10/11 PowerShel 2.0
::
::          YOU USE IT AT YOUR OWN RISK !!!
:: ----------------------------------------------------------------------------
@echo on
Unblock-File -Path ".\settings.ps1"
powershell -ExecutionPolicy Bypass -File ".\settings.ps1"
::powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File ".\settings.ps1"
