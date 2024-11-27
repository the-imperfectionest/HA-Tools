### Smart Lock and NFC Integration Using ESPHome and Home Assistant
**⚠️ This is a Work in Progress ⚠️**  
**⚠️ JSON Read Bug - Beware ⚠️**

This guide provides instructions for setting up a master bedroom smart lock system integrating ESPHome, an NFC reader, and Home Assistant. It also explains how to wire the components, use the exit button physically, and operate the lock via Home Assistant.

---

### Hardware Components - Not affiliate links, just what I used

1. **Control Module:** [ESP32-C3 DevKitM-1](https://www.amazon.com/dp/B0CNGH75XD)
2. **NFC Reader:** [PN532 connected via I2C](https://www.amazon.com/dp/B0DDKX2JCD)
3. **Door Lock Strike, Relay, Exit Button:** [SY-2320](https://www.amazon.com/dp/B0BRM9YDJB)
4. **Temperature & Humidity Sensor:** [DHT11 (possibly DHT22)](https://www.amazon.com/dp/B092M8GSTD)
5. **Reed Sensor:** [Magnetic Door Sensor](https://www.amazon.com/dp/B0DKW7K26G)

---

### Features

- **NFC Authentication:** Scans NFC tags, publishing UIDs to Home Assistant for LDAP-based authentication.
- **LDAP Cache Integration:** Validates NFC tags against a dynamic user cache.
- **Exit Button:** Allows physical unlocking of the door for easy exit.
- **Home Assistant Control:** Operate the lock directly via Home Assistant’s interface.
- **Environment Monitoring:** Measures temperature and humidity using DHT11.
- **Binary Door Sensor:** Detects door state (open/closed).
- **Failsafe:** Includes a fallback hotspot for initial configuration or troubleshooting.

---

### Physical and Home Assistant Lock Controls

#### Using the Exit Button
- **Purpose:** The exit button provides a manual override to unlock the door.
- **How It Works:** 
  - Pressing the button unlocks the door for 5 seconds.
  - After 5 seconds, the door automatically relocks.
- **Location:** Typically installed near the door for easy access.

#### Controlling the Lock via Home Assistant
1. **Home Assistant Dashboard:**
   - Locate the switch named `Master Bedroom Door Lock` in your dashboard or under **Devices & Services**.
   - Toggle the switch:
     - **On:** Unlocks the door.
     - **Off:** Relocks the door.
2. **Automation Use:** 
   - Automate the lock based on schedules, NFC scans, or other triggers.

---

### Wiring Instructions

#### **ESP32-C3 Connections**
- **Power Supply:**
  - 3.3V and GND pins on ESP32-C3 to power PN532, DHT11, and magnetic sensor.
- **NFC Reader (PN532):**
  - **SDA:** Connect to GPIO1 (I2C SDA).
  - **SCL:** Connect to GPIO3 (I2C SCL).
- **Door Lock Relay:**
  - **Control Pin:** GPIO5 connects to the relay input (IN).
  - **Relay Power:** Connect VCC and GND on the relay module to a 5V source and GND on the ESP32-C3.
  - **Relay Output:** Wire the relay NO (Normally Open) and COM (Common) to the door strike's power input.
  - **Door Strike Power:** Connect to a 12V DC power supply.
- **Exit Button:**
  - One side of the button connects to GPIO7.
  - The other side connects to GND.
- **Reed Sensor (Door Sensor):**
  - Connect one wire of the reed sensor to GPIO18.
  - Connect the other wire to GND.
- **DHT11 Sensor:**
  - Data pin connects to GPIO2.
  - Power pins connect to 3.3V and GND.

---



---

### Notes on Security

1. **Store Secrets in `secrets.yaml`:**
   - Move sensitive information (e.g., passwords, keys) to `secrets.yaml` for better security.

2. **Restricted Groups:**
   - Replace `authorized-group-1` and `authorized-group-2` in your Home Assistant automation with the actual LDAP groups permitted for access.

3. **Secure Wi-Fi:** Ensure you use a secure Wi-Fi network for ESP32 communication.

---

This guide includes detailed instructions for both wiring and configuration, ensuring a comprehensive and secure setup. Let me know if further clarifications are needed!
