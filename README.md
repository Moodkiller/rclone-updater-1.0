# rclone-updater-1.0

## Purpose:

To install and or update to the latest release of rclone for Windows users using the official static URL's. This script will also extract and move rlcone to the default directory of `C:\Windows\System32` or a user specific one by using the flag `-location C:\your\path\here`. The default directory will allow `rclone(.exe)` to be called from CMD (i.e a $PATH location). 

Note: If you already have an exisitng "install" of rclone, and dont specify your config file using the appropriate option, rclone will look for its config file in `C:\Users\<username>\.config\rclone`

## Instructions:
### To Install:
#### PowerShell:
1. N.B! Open PowerShell as an Administrator.
2. Paste the following: `curl https://raw.githubusercontent.com/Moodkiller/rclone-updater-1.0/master/rclone-updater.ps1 | iex`
3. Press `Enter`.

#### CMD (If you are running the latest Windows 10):
1. N.B! Open CMD as an Administrator.
2. Paste the following: `curl -O https://raw.githubusercontent.com/Moodkiller/rclone-updater-1.0/master/rclone-updater.ps1 | powershell.exe ./rclone-updater.ps1`
3. Press `Enter` and excuse the mess. 

#### Alternative:
1. Clone or download this repo from the releases tab.
2. Unzip to your desired location (doesn't matter where).
3. Right-click `rclone-updater (run as admin).bat` > Run as administrator (this will download the latest rclone from the source stated above and install it).

### Usage:
CLI: `rclone-updater.ps1`  
Scripts: `C:\Users\MK\Documents\rclone-updater.ps1 -beta y -location C:\Users\MK\Downloads\rclone`

## Sources:
rclone: https://github.com/ncw/rclone/releases  
Modified MPV update script from shinchiro: https://sourceforge.net/projects/mpv-player-windows/files/
