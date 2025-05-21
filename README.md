# CS2 Ultimate Optimization Script - 2025

## Changelogs

✅ v1.1 - Major Bug Fixes & Usability Improvements (2025)
This update resolves several critical issues that prevented the menu from appearing or caused crashes during startup. It also improves path detection and input handling across different Windows versions and languages.

🔧 Fixed
- Fixed menu not showing : Replaced unreliable choice command with PowerShell-based input handler for better compatibility.
- Fixed date/time log issue : Switched to PowerShell for consistent log file naming across all regional settings.
- Fixed incorrect registry syntax : Corrected /nul arguments in FPS unlocker to proper /f.
- Fixed early exit on missing CS2 path : Script no longer exits if CS2 path is not found automatically; now prompts user to enter it manually.
- Improved error handling : Better logging and fallback behavior for services like powercfg.
💡 New Features
- Manual CS2 path entry : If automatic detection fails, the user is prompted to enter the full path to cs2.exe.
- PowerShell-based input : Allows clean key press menu navigation even on non-English systems where choice may fail.
- Safer logging : Ensures log file is always created before any function tries to write to it.
🛠️ Improved
- CS2 path detection logic : More robust search through Steam library folders.
- Log file formatting : Uses yyyyMMdd_HHmm format for consistent log filenames.
- User experience : Added clearer instructions during manual path input and launch phases.
- Script stability : Prevents silent crashes and handles missing commands gracefully.
🧹 Code Quality
- Cleaned up duplicate code and improved flow control.
- Enhanced comments and structure for easier maintenance.
- Added timeout/pause feedback after invalid inputs.
🚀 Next Features (Planned)
GUI version using HTA or PowerShell Forms
Option to restore original settings (firewall, power plan, etc.)
Auto-check for updates
Configurable launch options
Discord/webhook integration for notifications

# v1.0.2 - 16/04/2025
- Better structure & readability
- Enhanced administrator check
- Power plan fix using GUID fallback
- Improved NVIDIA shader cache removal
- CS2 path detection flexibility

# v1.0.1 - 23/02/2025
- Added error checking to ensure commands execute correctly.
- Reduced redundant operations and improved logic flow.
- Enhanced network optimizations with more TCP tweaks.
- Ensured admin rights check at the start to avoid permission issues.
- Improved GPU assignment method for better compatibility.
- Added logging to help diagnose issues if needed.

## Overview

The **CS2 Ultimate Optimization Script** is designed to optimize your system for running **Counter-Strike 2 (CS2)** at peak performance. This script cleans up unnecessary files, configures system settings, and applies network and GPU optimizations to improve gameplay performance and reduce latency.

---

## Support Us
We offer premium PC and game optimization on our discord!

Join discord https://dc.gg/precisionoptimize
Our website https://precisioncompany.xyz

---

## Features

1. **Terminate CS2 Process**: Ensures the game is closed before optimization begins.
2. **Clean Temporary Files**: Deletes Windows temporary files, prefetch, and DNS cache to free up space and improve system efficiency.
3. **NVIDIA Shader Cache Cleanup**: Removes unnecessary DX and Vulkan shader caches for a smoother experience.
4. **Disable Unnecessary Services**: Turns off Xbox Game Bar, Game DVR, and Windows Update Medic Service.
5. **High-Performance GPU Settings**: Ensures CS2 uses the high-performance GPU.
6. **Network Optimizations**: Configures TCP/IP settings for lower latency and better connection stability.
7. **Set High-Performance Power Plan**: Switches your system to a high-performance power plan.
8. **Audio Latency Enhancements**: Reduces audio latency for better in-game sound responsiveness.
   MORE FEATURES SOON, FEEL FREE TO CONTRIBUTE TO PROJECT.

---

## Requirements

- Windows 10/11 (Administrator access required)
- Counter-Strike 2 installed on your system

---

## Installation

1. Download the `CS2 Ultimate Optimization.exe` file from release.
2. Save it in a directory of your choice.

---

## Usage

1. **Run the Script**:
   - Right-click the `CS2_Ultimate_Optimization.bat` file and select **Run as Administrator**.
   - Or download the `CS2 Ultimate Optimization.exe` file from release, you don't have to run as administrator by yourself.

2. **Follow Instructions**:
   - The script will guide you through each step of the optimization process.

3. **Verify Changes**:
   - After the script completes, your system will be optimized for CS2.

---

## Notes

- **Backup Files**: The script does not delete critical game or system files, but always ensure your important data is backed up before running optimization scripts.
- **Post-Update Optimization**: After a major CS2 or system update, rerun the script to reapply optimizations.
- **Re-enable Firewall**: The script disables the firewall temporarily for network optimization. If needed, re-enable it manually after completing the script.

---

## Troubleshooting

- If the script fails to run, ensure:
  - You have administrator rights.
  - Windows security software isn’t blocking batch scripts.

- If issues persist, feel free to open a bug report or customize the script to suit your specific needs.

---

## License

This script is provided as-is and is free to use and modify. Use it at your own risk. The author is not responsible for any damage caused to your system.
You can request an contribution.

---
