Here’s the updated guide with the directory structure reflecting the `/addon_configs/[container_name]/` path for AppDaemon's containerized environment:

---

# **Smart Lock and NFC Integration Using ESPHome and Home Assistant**

**⚠️ This is a Work in Progress ⚠️**

This project implements an NFC-based access control system using ESPHome, AppDaemon, and Home Assistant. It integrates a PN532 NFC reader, a relay-controlled door strike, and Home Assistant's LDAP authentication for secure, automated door access.

If you want AD/LDAP integration/caching, check the /HA-Tools/ldap-cache/ directory of this repo

---

## **Features**

- **NFC Authentication**: Scans NFC tags, validates them against an LDAP-based user cache.
- **LDAP Cache Integration**: Authorization based on dynamic Active Directory group membership.
- **Exit Button**: Physical button for manual door unlocking.
- **Home Assistant Control**: Operate the lock via UI or automation.
- **Environmental Monitoring**: Tracks temperature and humidity using DHT11 sensors.
- **Door State Detection**: Uses a reed sensor to monitor door state (open/closed).

---

## **Hardware Components**

| Component                     | Example Link                                  |
|-------------------------------|-----------------------------------------------|
| **Control Module**            | [ESP32-C3 DevKitM-1](https://www.amazon.com/dp/B0CNGH75XD) |
| **NFC Reader**                | [PN532 (I2C Connection)](https://www.amazon.com/dp/B0DDKX2JCD) |
| **Door Lock Strike, Relay**   | [SY-2320](https://www.amazon.com/dp/B0BRM9YDJB) |
| **Temperature & Humidity**    | [DHT11](https://www.amazon.com/dp/B092M8GSTD) |
| **Magnetic Door Sensor**      | [Reed Sensor](https://www.amazon.com/dp/B0DKW7K26G) |

---

## **Physical and Digital Lock Controls**

### **Exit Button**
- **Purpose**: Manual override to unlock the door for 5 seconds.
- **Operation**: Relocks automatically after timeout.
- **Location**: Installed near the door.

### **Home Assistant Control**
1. **UI Control**:
   - Toggle the `Master Bedroom Door Lock` entity.
     - **On**: Unlocks the door.
     - **Off**: Relocks the door.
2. **Automation**:
   - Automate the lock based on NFC scans or schedules.

---

## **Hardware Wiring**

### **ESP32-C3 Connections**

| Component          | ESP32 Pin  | Connection |
|---------------------|------------|------------|
| **Power Supply**    | 3.3V/GND   | Power NFC reader, DHT11, reed sensor |
| **NFC Reader (PN532)** | GPIO1 (SDA) / GPIO3 (SCL) | I2C connections |
| **Relay (Control)** | GPIO5      | Relay input (IN) |
| **Relay (Output)**  | NO / COM   | Door strike power input |
| **Exit Button**     | GPIO7 / GND| Manual override button |
| **Reed Sensor**     | GPIO18 / GND | Detects door state |
| **DHT11 Sensor**    | GPIO2      | Measures temperature/humidity |

---

## **Configuration**

### **1. AppDaemon Setup**

#### Prerequisites
- Install the **AppDaemon Add-on** in Home Assistant.
- AppDaemon runs in a containerized environment:
  - `/addon_configs/[container_name]/` is the working directory for AppDaemon.

#### Directory Structure
- **Base Directory**: `/addon_configs/[container_name]/`
  - **LDAP Cache File**: `/addon_configs/[container_name]/ad_user_cache.json`
  - **Apps Directory**: `/addon_configs/[container_name]/apps/`

#### App Configuration
1. **Place Files**:
   - `nfc_access_control.py` in `/addon_configs/[container_name]/apps/`.
   - `apps.yaml` in `/addon_configs/[container_name]/apps/`.
2. **Edit `apps.yaml`**:
   ```yaml
nfc_access_control:
  module: nfc_access_control
  class: NFCAccessControl
  door_access:
    master_bedroom:
      allowed_groups:
        - "CN=group-adults,CN=Users,DC=example,DC=com"
        - "CN=group-bedroom,CN=Users,DC=example,DC=com"
    garage:
      allowed_groups:
        - "CN=group-adults,CN=Users,DC=example,DC=com"

   ```

3. **Restart AppDaemon**:
   - Go to Supervisor > AppDaemon > Restart.

---

### **2. LDAP Cache File**

#### File Details
- **Path**: `/addon_configs/[container_name]/ad_user_cache.json`
- **Example Content**:
   ```json
[
  {
    "cn": "John Doe",
    "username": "johnd",
    "nfcTagID": "12-34-56-78-9A-BC-DE-F0",
    "groups": ["CN=group-adults,CN=Users,DC=example,DC=com"]
  },
  {
    "cn": "Jane Smith",
    "username": "janes",
    "nfcTagID": "98-76-54-32-10-FE-DC-BA",
    "groups": ["CN=group-bedroom,CN=Users,DC=example,DC=com"]
  }
]


---

### **3. NFC Tag Events**

#### Fire Test Events
- Use Developer Tools > Events to simulate `esphome.nfc_scan`.
- Example Payload:
   ```json
   {
     "tag_id": "YOUR_NFC_TAG_ID",
     "door_id": "master_bedroom"
   }
   ```

---

## **Security Recommendations**

1. **Restrict Access**:
   - Limit door access to predefined LDAP groups.
2. **Secrets Management**:
   - Store sensitive credentials (e.g., API tokens) in `secrets.yaml`.
3. **Secure Wi-Fi**:
   - Use WPA2 or stronger for ESP32 connectivity.

---

## **Common Issues and Debugging**

| Issue                 | Solution                                          |
|------------------------|--------------------------------------------------|
| **JSON Bug**           | Use AppDaemon for robust JSON handling.          |
| **Tag Denied**         | Check tag ID and group association in `ad_user_cache.json`. |
| **Door Not Unlocking** | Verify relay wiring and ESPHome configuration.   |
| **AppDaemon Errors**   | Check AppDaemon logs for syntax or runtime issues. |

---

