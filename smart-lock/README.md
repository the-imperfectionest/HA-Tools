### Smart Lock and NFC Integration Using ESPHome and Home Assistant
**⚠️ This is a Work in Progress ⚠️**
**⚠️ JSON Read Bug - Beware ⚠️**

This guide provides instructions for setting up a master bedroom smart lock system integrating ESPHome, an NFC reader, and Home Assistant. It also explains how to use the exit button physically and operate the lock via Home Assistant.

---

### Hardware Components - Not affiliate links, just what I used

1. **Control Module:** ESP32-C3 DevKitM-1  https://www.amazon.com/dp/B0CNGH75XD
2. **NFC Reader:** PN532 connected via I2C  https://www.amazon.com/dp/B0DDKX2JCD
3. **Door Lock Strike, Relay, Exit Button** SY-2320  https://www.amazon.com/dp/B0BRM9YDJB
5. **Temperature & Humidity Sensor:** DHT11 - These might secretely be DHT22's https://www.amazon.com/dp/B092M8GSTD
6. **Reed sensor**  https://www.amazon.com/dp/B0DKW7K26G

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

---

### LDAP-Based Unlock Automation

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


