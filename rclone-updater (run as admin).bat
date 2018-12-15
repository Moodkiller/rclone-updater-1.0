@echo OFF
:: This batch file exists to run rclone-updater.ps1 without hassle
pushd %~dp0
if exist "%~dp0\installer\rclone-updater.ps1" (
    set rclone-updater_script="%~dp0\installer\rclone-updater.ps1"
) else (
    set rclone-updater_script="%~dp0\rclone-updater.ps1"
)
powershell -noprofile -nologo -executionpolicy bypass -File %rclone-updater_script%
echo.
echo You are currently running:
rclone.exe version
echo.
@pause
