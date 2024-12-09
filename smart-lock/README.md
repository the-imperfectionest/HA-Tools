

---

# **Smart Lock and NFC Integration Using ESPHome and Home Assistant**

**⚠️ Work in Progress ⚠️**

This project demonstrates how to implement an NFC-based access control system using ESPHome, AppDaemon, and Home Assistant. The setup integrates a PN532 NFC reader, a relay-controlled door strike, and LDAP authentication for secure door access.

If you require AD/LDAP integration and caching, explore the `/HA-Tools/ldap-cache/` directory in this repository.

---

## **Features**

- **NFC Authentication**: Validates NFC tags against an LDAP-based user cache.
- **LDAP Integration**: Access permissions based on Active Directory group membership.
- **Exit Button**: Physical button for manual door unlocking.
- **Home Assistant UI**: Manage locks via Home Assistant UI or automation.
- **Environmental Monitoring**: Includes temperature and humidity monitoring using DHT11.
- **Door State Detection**: Tracks door state with a reed sensor.

---

## **Hardware Components**

| Component                  | Example Link                                    |
|----------------------------|------------------------------------------------|
| **ESP32 Module**           | [ESP32-C3 DevKitM-1](https://www.amazon.com/dp/B0CNGH75XD) |
| **NFC Reader**             | [PN532 (I2C)](https://www.amazon.com/dp/B0DDKX2JCD) |
| **Door Strike & Relay**    | [SY-2320](https://www.amazon.com/dp/B0BRM9YDJB) |
| **Temp & Humidity Sensor** | [DHT11](https://www.amazon.com/dp/B092M8GSTD) |
| **Reed Switch**            | [Magnetic Sensor](https://www.amazon.com/dp/B0DKW7K26G) |

---

## **Wiring Diagram**

### **ESP32-C3 Pinout**

| Component          | ESP32 Pin | Notes                                      |
|---------------------|-----------|--------------------------------------------|
| **NFC Reader**      | SDA → GPIO1, SCL → GPIO3 | I2C communication           |
| **Relay Control**   | IN → GPIO5               | Controls the door strike    |
| **Exit Button**     | GPIO7 → Button           | Manual override             |
| **Reed Sensor**     | GPIO18 → Sensor          | Detects door state          |
| **DHT11 Sensor**    | GPIO2                    | Temperature & humidity      |

---

## **Configuration**

### **1. AppDaemon Setup**

#### Directory Structure
- **Base Directory**: `/addon_configs/[container_name]/`
  - **Apps Directory**: `/addon_configs/[container_name]/apps/`
  - **LDAP Cache File**: `/addon_configs/[container_name]/ad_user_cache.json`

#### Steps
1. **Place Files**:
   - Copy `nfc_access_control.py` to:
     ```
     /addon_configs/[container_name]/apps/
     ```
   - Copy `apps.yaml` to:
     ```
     /addon_configs/[container_name]/apps/
     ```

2. **Edit `apps.yaml`**:
   Add the following configuration:
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
   Navigate to:
   ```
   Supervisor > AppDaemon > Restart
   ```

---

### **2. LDAP Cache File**

#### Path
```
/addon_configs/[container_name]/ad_user_cache.json
```

#### Example Content
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
```

---

### **3. NFC Tag Events**

#### Testing NFC Tags
To test NFC tags, use Developer Tools in Home Assistant:
1. Go to **Developer Tools > Events**.
2. Fire the `esphome.nfc_scan` event with the payload:
   ```json
   {
     "tag_id": "YOUR_NFC_TAG_ID",
     "door_id": "master_bedroom"
   }
   ```

---

## **Security Recommendations**

1. **Restrict Access**:
   - Assign permissions to predefined LDAP groups only.
2. **Secrets Management**:
   - Store credentials securely in `secrets.yaml`.
3. **Network Security**:
   - Use WPA2/WPA3 for ESP32 connectivity.

---

## **Troubleshooting**

| Issue                 | Solution                                          |
|------------------------|--------------------------------------------------|
| **LDAP Cache Empty**   | Ensure the `ad_user_cache.json` file is updated. |
| **Access Denied**      | Verify tag group association in `apps.yaml`.     |
| **Relay Malfunction**  | Check wiring and ESPHome pin configurations.     |
| **AppDaemon Errors**   | Inspect logs for syntax or runtime issues.       |

---

This guide provides step-by-step instructions to integrate an NFC-based smart lock with Home Assistant. For advanced setups or troubleshooting, refer to the project repository or open an issue.
