[English](README.md) | [Español](README.es.md)

# NyxUSB

Herramienta de extracción de datos mediante USB, diseñada para uso educativo y pruebas de seguridad autorizadas.

---

## 🖼️ Vista previa

![NyxUSB Prototype](nyxusb.jpg)

> Prototipo actual de NyxUSB (Digispark + USB + hub modificado)

---

## 🧠 Descripción

NyxUSB es una herramienta basada en hardware que automatiza la extracción de datos desde sistemas objetivo de forma silenciosa y sin conexión a red.

Inspirada en Nyx, la diosa de la noche, opera sin llamar la atención y ejecuta acciones sin intervención del usuario.

---

## ⚙️ Arquitectura

NyxUSB está compuesto por tres componentes principales:

### 1. Digispark (Inyector de comandos)
Actúa como un dispositivo HID que simula un teclado y ejecuta comandos automáticamente en el sistema objetivo.

### 2. USB Payload (Ejecución y almacenamiento)
Contiene un script (por ejemplo, `.bat`) encargado de realizar la extracción de datos y almacenar los archivos obtenidos.

### 3. Hub USB personalizado (PCB)
Un hub USB modificado que permite que ambos dispositivos funcionen simultáneamente como una sola unidad.

---

## 🚀 Funcionamiento

1. El dispositivo se conecta a la máquina objetivo.  
2. El Digispark ejecuta comandos automáticamente.  
3. El USB payload lanza un script de extracción silenciosa.  
4. Los archivos se recopilan y almacenan en el USB.  

---

## 📦 Estructura del proyecto
```text
digispark/
   ├── digispark_en.ino       # Inyector para teclado en inglés con feedback LED
   └── digispark_es.ino       # Inyector para teclado en español con feedback LED

payloads/
   ├── payload.bat            # Lanzador maestro (Reconocimiento del host + auditoría WiFi + submódulos)
   ├── wifi-extractor/
   │   └── payload.bat        # Extractor de credenciales WiFi agnóstico del idioma
   ├── data-extractor/
   │   └── payload.bat        # Extractor de documentos del usuario (PDF, DOCX, etc.)
   └── software-installer/
       ├── payload.bat        # Instalador silencioso dinámico para MSI / EXE / PS1
       └── CARPETA_PROGS/     # Directorio destino de instaladores
```

---

## 🔧 Requisitos

Para replicar este proyecto necesitas:

- Digispark (ATtiny85 con V-USB)
- Memoria USB Flash
- Hub USB (modificado o integrado)
- Arduino IDE con soporte para placas Digistump AVR
- Sistema operativo objetivo: Windows 7 / 8 / 10 / 11

---

## 🛠️ Uso / Configuración

### 1. Programar el Digispark
- Abrir Arduino IDE.
- Cargar el sketch correspondiente a tu entorno objetivo:
  - `digispark_en.ino` (distribución de teclado en inglés / US)
  - `digispark_es.ino` (distribución de teclado en español)
- Subir el código a la placa Digispark.
- **Comportamiento del indicador LED:**
  - **Parpadeo (~4 segundos):** Etapa de enumeración. Permite a Windows montar tanto el dispositivo HID como el almacenamiento USB.
  - **Encendido fijo:** Inyección de teclas finalizada y payload disparado con éxito.

### 2. Preparar el almacenamiento USB
- Copiar `payloads/payload.bat` (o el módulo específico de tu elección) en la **raíz** de la memoria USB.
- Los resultados se almacenarán automáticamente en la carpeta `Data/` de la USB.

### 3. Conexión y despliegue
- Conectar NyxUSB al sistema objetivo.
- El Digispark espera el montaje de la unidad, inyecta el lanzador mediante `Win + R` y ejecuta las acciones de forma oculta en segundo plano.
- La rutina OPSEC integrada limpia automáticamente la clave de registro `RunMRU` y el historial de PowerShell al finalizar.

---

## 🌍 Soporte Multi-idioma y Compatibilidad

- **Distribución de Teclado:** Incluye inyectores específicos para configuraciones de teclado en inglés y español.
- **Extracción Agnóstica del Idioma:** La recolección de contraseñas WiFi utiliza exportación nativa en XML, garantizando 100% de compatibilidad en sistemas en español, inglés, francés o cualquier configuración regional sin depender de cadenas de texto fijas.

---

## 🧪 Demo / Resultado

<p align="center">
  <a href="https://youtu.be/MU5QpXcOUq0">
    <img src="https://img.youtube.com/vi/MU5QpXcOUq0/0.jpg" width="600">
  </a>
</p>

---

## 🧩 Extensiones y payloads

NyxUSB no está limitado a la extracción de archivos.

El diseño permite agregar nuevos scripts dentro de la carpeta `payloads/`, ampliando sus capacidades.

Ejemplos de posibles usos:
- Automatización de tareas
- Ejecución de scripts personalizados
- Pruebas de seguridad

---

## ⚠️ Aviso

Este proyecto está destinado únicamente a fines educativos y pruebas de seguridad autorizadas.

No utilizar en sistemas sin permiso explícito.

---

## 🤝 Ideas y contribuciones

Si tienes ideas para nuevos payloads, mejoras o dispositivos similares:

- Puedes abrir un issue
- O dejar tu propuesta

---

## ⭐ Apoyo

Si este proyecto te parece interesante, puedes apoyarlo con una estrella ⭐ en el repositorio.
