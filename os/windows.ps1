Set-StrictMode -Version latest
# TODO: Exit on failure (set -e like)
# => https://stackoverflow.com/q/9948517
# If not possible, consider using bash script (call winget.exe) with previous manual WSL installation instead?

# Packages
winget install --disable-interactivity --accept-package-agreements --accept-source-agreements --exact --id Microsoft.PowerToys
winget install --disable-interactivity --accept-package-agreements --accept-source-agreements --exact --id Microsoft.Sysinternals.ProcessMonitor

## Game platforms
winget install --disable-interactivity --accept-package-agreements --accept-source-agreements --exact --id EpicGames.EpicGamesLauncher
winget install --disable-interactivity --accept-package-agreements --accept-source-agreements --exact --id Valve.Steam

## Web browsers
winget install --disable-interactivity --accept-package-agreements --accept-source-agreements --exact --id Google.Chrome
winget install --disable-interactivity --accept-package-agreements --accept-source-agreements --exact --id Mozilla.Firefox
# TODO: Ensure default browser configuration (procmon -> registry set ?)
# -> https://www.tenforums.com/performance-maintenance/124376-settings-using-powershell-cmd-2.html

# TODO: WSL install
