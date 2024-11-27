### Smart Lock and NFC Integration Using ESPHome and Home Assistant
**⚠️ This is a Work in Progress ⚠️**
**⚠️ JSON Read Bug - Beware ⚠️**

This guide provides instructions for setting up a master bedroom smart lock system integrating ESPHome, an NFC reader, and Home Assistant. It also explains how to use the exit button physically and operate the lock via Home Assistant.

---

### Hardware Components

1. **Control Module:** ESP32-C3 DevKitM-1
2. **NFC Reader:** PN532 connected via I2C
3. **Door Lock Strike:** SY-2320
4. **Exit Button:** GPIO-based switch
5. **Temperature & Humidity Sensor:** DHT11

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

### Sanitized ESPHome YAML Configuration

```yaml
esphome:
  name: master-bedroom
  friendly_name: master_bedroom

esp32:
  board: esp32-c3-devkitm-1
  framework:
    type: arduino

logger:

ota:
  - platform: esphome
    password: !secret ota_password

api:
  encryption:
    key: !secret api_encryption_key

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.x.y  # Replace with your desired static IP
    gateway: 192.168.x.1     # Replace with your network gateway
    subnet: 255.255.255.0

  ap:
    ssid: "Esp32-Test Fallback Hotspot"
    password: "FallbackPassword"

captive_portal:

i2c:
  sda: GPIO1
  scl: GPIO3
  scan: true

pn532_i2c:
  update_interval: 1s
  on_tag:
    then:
      - lambda: |-
          std::string scanned_uid = "";
          for (auto byte : x) {
            char buffer[4];
            sprintf(buffer, "%02X", byte);
            scanned_uid += buffer;
            scanned_uid += "-";
          }
          if (!scanned_uid.empty()) {
            scanned_uid.pop_back();
          }
          ESP_LOGD("NFC", "Scanned UID: %s", scanned_uid.c_str());
          id(uid_sensor).publish_state(scanned_uid);

text_sensor:
  - platform: template
    name: "Master Bedroom NFC UID Sensor"
    id: uid_sensor

binary_sensor:
  - platform: gpio
    pin:
      number: GPIO18
      mode: INPUT_PULLUP
    name: "Master Bedroom Door Sensor"
    id: door_sensor
    device_class: door
    filters:
      - delayed_on: 10ms
      - delayed_off: 10ms

  - platform: gpio
    pin:
      number: GPIO7
      mode: INPUT_PULLUP
    name: "Exit Button"
    id: exit_button
    device_class: door
    on_press:
      then:
        - logger.log: "Master Bedroom Button Pressed"
        - switch.turn_on: door_lock
        - delay: 5s
        - switch.turn_off: door_lock

switch:
  - platform: gpio
    name: "Master Bedroom Door Lock"
    id: door_lock
    pin: GPIO5
    restore_mode: ALWAYS_OFF

sensor:
  - platform: dht
    pin: GPIO2
    model: DHT11
    temperature:
      name: "Master Bedroom Temperature"
      id: master_bedroom_temperature
      unit_of_measurement: "°F"
    humidity:
      name: "Master Bedroom Humidity"
      id: master_bedroom_humidity
      unit_of_measurement: "%"
```

---

### Sanitized LDAP-Based Unlock Automation

```yaml
alias: Unlock Master Bedroom Door
trigger:
  - platform: state
    entity_id: sensor.master_bedroom_nfc_uid_sensor
action:
  - variables:
      ldap_cache: "{{ states('sensor.ad_user_cache') | from_json }}"
      scanned_uid: "{{ trigger.to_state.state }}"
      user: >
        {{ ldap_cache | selectattr('nfcTagID', 'eq', scanned_uid) | list | first }}
  - choose:
      - conditions:
          - condition: template
            value_template: >
              {{ user is not none and
                 ('CN=authorized-group-1,' in user.groups | join('') or
                  'CN=authorized-group-2,' in user.groups | join('')) }}
        sequence:
          - service: switch.turn_on
            target:
              entity_id: switch.master_bedroom_door_lock
          - delay: "00:00:05"
          - service: switch.turn_off
              target:
              entity_id: switch.master_bedroom_door_lock
      default:
        - service: logbook.log
          data:
            name: "Unauthorized NFC Scan"
            message: >
              {% if user is not none %}
                {{ user['cn'] }} attempted to scan at the Master Bedroom Door but is unauthorized.
              {% else %}
                Unknown UID {{ scanned_uid }} attempted to scan at the Master Bedroom Door.
              {% endif %}
```

---

### Notes on Security

1. **Store Secrets in `secrets.yaml`:**
   - Move sensitive information (e.g., passwords, keys) to `secrets.yaml` for better security.

2. **Restricted Groups:**
   - Replace `authorized-group-1` and `authorized-group-2` with the actual LDAP groups permitted for access.

3. **Secure Wi-Fi:** Ensure you use a secure Wi-Fi network for ESP32 communication.

---

This guide combines physical lock operation with automation via Home Assistant, making it user-friendly and secure. Let me know if further adjustments are needed!
