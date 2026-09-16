# 📡 Ultrasonic Radar System | Embedded Systems Project

An interactive radar system that scans objects across angles using an ultrasonic sensor mounted on a servo motor, displaying real-time distance visualization on a computer interface via serial communication.

---

# 🛠️ Tools & Technologies Used
- **Microcontroller:** ESP32
- **Sensors & Components:** HC-SR04 Ultrasonic Sensor, SG90 Servo Motor
- **Languages:** Embedded C / C++ (Firmware), Processing (Java-based GUI)
- **Software:** Arduino IDE, Processing IDE
- **Protocols:** Serial Communication

---

# ⚙️ Features & Key Learnings
- 🔄 **Servo Motor Control:** Smooth sweeping motion across continuous angles (0° to 180°).
- 📏 **Distance Measurement:** Accurate pulse-duration distance calculation using HC-SR04 ultrasonic echo processing.
- 💻 **Hardware-Software Interface:** Real-time data streaming over UART to render distance and angle vectors visually in Processing.
- 🎯 **Embedded Programming:** Efficient non-blocking sensor acquisition and hardware interface control in C/C++.

---

# 🚀 How to Run
1. **Hardware Setup:** Connect the HC-SR04 trigger/echo pins and SG90 servo data pin to your ESP32 GPIO pins.
2. **Flash Firmware:** Open the code in Arduino IDE, select the ESP32 board, set your COM port, and upload.
3. **Run GUI:** Open the Processing sketch in Processing IDE, select the matching COM port, and click **Run**.
