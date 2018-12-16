# rclone-updater-1.0

## Purpose:

To install and update to the latest release of rclone for Windows users using the official static URL. This script will also extract and move rlcone to the `C:\indows` directory so that it can be called from the CMD prompt by just typing `rclone(.exe)`. In other words, one doesnt have to specify the absolute path of rclone. 

Note: If you already have an exisitng "install" of rclone, and dont specify your config file using the appropriate option, rclone will look for its config file in `C:\Users\<username>\.config\rclone`

## Instructions:
### If you are running the latest Windows 10, then:
1. Open CMD as an Administrator.
2. Paste the following: `curl -O https://raw.githubusercontent.com/Moodkiller/rclone-updater-1.0/master/rclone-updater.ps1 | powershell.exe .\rclone-updater.ps1`
3. Press enter and excuse the mess. 

### Alternativily, if you are running a version of Windows without curl installed, do the following:
1. Clone or download this repo.
2. Unzip to your desired location.
3. Run `rclone-updater (run as admin).bat` (this will download the latest rclone from the source stated below).

## Source:
rclone: https://rclone.org/downloads/
