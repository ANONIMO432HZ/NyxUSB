[English](README.md) | [Español](README.es.md)

# NyxUSB

Silent USB-based data extraction tool designed for educational and authorized security testing.

---

## 🖼️ Preview

![NyxUSB Prototype](nyxusb.jpg)

> Current NyxUSB prototype (Digispark + USB + modified hub)

---

## 🧠 Description

NyxUSB is a hardware-based tool designed to automate data extraction from target systems in a silent and offline manner.

Inspired by Nyx, the goddess of the night, it operates without drawing attention and executes actions without user interaction.

---

## ⚙️ Architecture

NyxUSB is composed of three main components:

### 1. Digispark (Command Injector)
Acts as a HID device that simulates a keyboard and automatically executes commands on the target system.

### 2. USB Payload (Execution & Storage)
Contains a script (e.g., `.bat`) responsible for performing the data extraction process and storing the collected files.

### 3. Custom USB Hub (PCB)
A modified USB hub that allows both devices to operate simultaneously as a single unit.

---

## 🚀 How It Works

1. The device is plugged into the target machine  
2. The Digispark injects commands automatically  
3. The USB payload executes a silent extraction script  
4. Data is collected and stored on the USB device  

---

## 📦 Project Structure
```text
digispark/
   ├── digispark_en.ino       # English keyboard layout injector with LED feedback
   └── digispark_es.ino       # Spanish keyboard layout injector with LED feedback

payloads/
   ├── payload.bat            # Master launcher (Host Recon + Wi-Fi audit + submodules)
   ├── wifi-extractor/
   │   └── payload.bat        # Language-agnostic Wi-Fi credential dumper
   ├── data-extractor/
   │   └── payload.bat        # User profile file collector (PDF, DOCX, etc.)
   └── software-installer/
       ├── payload.bat        # Dynamic MSI / EXE / PS1 silent installer
       └── CARPETA_PROGS/     # Target directory for installers
```

---

## 🔧 Requirements

To replicate this project, you will need:

- Digispark (ATtiny85 with V-USB)
- USB flash drive
- USB hub (modified or integrated)
- Arduino IDE with Digistump AVR board support
- Target OS: Windows 7 / 8 / 10 / 11

---

## 🛠️ Setup / Usage

### 1. Flash the Digispark
- Open Arduino IDE.
- Load the sketch corresponding to your target environment:
  - `digispark_en.ino` (US / English keyboard layout)
  - `digispark_es.ino` (Spanish keyboard layout)
- Upload to the Digispark board.
- **LED Indicator behavior:**
  - **Blinking (~4 seconds):** Enumeration stage. Gives Windows time to mount both the HID and Mass Storage devices.
  - **Solid ON:** Keystroke injection complete and payload triggered.

### 2. Prepare the USB Storage
- Copy `payloads/payload.bat` (or your chosen module) to the **root** of the USB flash drive.
- Output results will automatically be stored under the `Data/` folder on the USB.

### 3. Deploy
- Plug NyxUSB into the target system.
- The Digispark waits for drive enumeration, injects the launcher via `Win + R`, and executes silently in the background.
- Built-in OPSEC automatically cleans the `RunMRU` registry key and PowerShell history upon execution.

---

## 🌍 Multi-language & Cross-OS Support

- **Keyboard Layouts:** Includes dedicated injectors for English and Spanish keyboard configurations.
- **Language-Agnostic Extraction:** Wi-Fi harvesting utilizes native XML export, ensuring 100% compatibility across English, Spanish, French, or any Windows locale without hardcoded string parsing.


---

## 🧪 Demo / Result

<p align="center">
  <a href="https://youtu.be/MU5QpXcOUq0">
    <img src="https://img.youtube.com/vi/MU5QpXcOUq0/0.jpg" width="600">
  </a>
</p>

---

## 🧩 Extensions and Payloads

NyxUSB is not limited to file extraction.

Its design allows adding new scripts inside the `payloads/` folder, expanding its capabilities.

Possible use cases include:
- Task automation
- Custom script execution
- Security testing scenarios

---

## ⚠️ Disclaimer

This project is intended for educational purposes and authorized security testing only.

Do not use this tool on systems without explicit permission.

---

## 🤝 Ideas & Contributions

If you have ideas for new payloads, improvements, or similar hardware projects:

- Feel free to open an issue
- Or share your ideas

---

## ⭐ Support

If you find this project interesting, consider giving it a star ⭐ on GitHub.
