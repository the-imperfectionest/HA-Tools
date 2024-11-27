# Home Assistant NWS Alerts Integration and Lighting Configuration

This repository provides step-by-step instructions to configure NWS Alerts integration and group lighting in Home Assistant. The setup allows dynamic responses to weather events by controlling grouped lights.

---

## 🚀 Getting Started

### Prerequisites

- A working **Home Assistant** instance.
- Compatible smart lights (e.g., WiZ or other supported devices).
- Access to Home Assistant's YAML configuration.

---

## 🛠 Setup Instructions

### 1. Install NWS Alerts Integration

1. Open Home Assistant and navigate to **Settings > Integrations**.
2. Search for **NWS Alerts**.
3. Click **Add Integration** and enter your location to filter alerts for your area.
4. Save the configuration.

---

### 2. Configure Group Lighting

A `light` group consolidates multiple lights into a single entity, simplifying control during alerts.

#### Add the `light` Group

1. Open your `configuration.yaml` file.
2. Add the following configuration:

   ```yaml
   light:
     - platform: group
       name: all_wiz_lights
       entities:
         - light.wiz_rgbww_tunable_f76132  # Replace with your light entity IDs
         - light.wiz_rgbw_tunable_d9e9fd
         - light.wiz_rgbw_tunable_4781a0
         - light.wiz_rgbw_tunable_8fd746
   ```

   > **Note:** Replace the `light.wiz_rgbww_tunable_*` entries with your actual light entity IDs. You can find these in **Settings > Devices & Services** under your light integration.

3. Save the file and restart Home Assistant.

---

### 3. Test the Configuration

1. Open **Developer Tools > States** in Home Assistant.
2. Search for `light.all_wiz_lights` to confirm the group entity exists.
3. Test the group by calling a service in **Developer Tools > Services**:
   - **Service:** `light.turn_on`
   - **Target:** `light.all_wiz_lights`

---

## 📖 Example Automation

Use the NWS Alerts integration to respond dynamically to weather alerts. Below is an example automation for a **Tornado Warning**:

```yaml
- alias: Tornado Warning Alert
  trigger:
    - platform: state
      entity_id: sensor.nws_alerts
  condition:
    - condition: template
      value_template: >
        {{ state_attr('sensor.nws_alerts', 'Alerts') | selectattr('Event', 'equalto', 'Tornado Warning') | list | length > 0 }}
  action:
    - repeat:
        count: 6
        sequence:
          - service: light.turn_on
            target:
              entity_id: light.all_wiz_lights
            data:
              brightness: 255
              color_name: "red"
              transition: 0
          - delay: "00:00:00.25"
          - service: light.turn_off
            target:
              entity_id: light.all_wiz_lights
            data:
              transition: 0
          - delay: "00:00:00.25"
    - service: light.turn_on
      target:
        entity_id: light.all_wiz_lights
      data:
        brightness: 255
        color_name: "red"
        transition: 0
```

---

## 📋 Full Configuration Example

Below is a consolidated example of `configuration.yaml` for the NWS Alerts integration and lighting group:

```yaml
# Light Group Configuration
light:
  - platform: group
    name: all_wiz_lights
    entities:
      - light.wiz_rgbww_tunable_f76132
      - light.wiz_rgbw_tunable_d9e9fd
      - light.wiz_rgbw_tunable_4781a0
      - light.wiz_rgbw_tunable_8fd746

# Tornado Warning Automation
automation:
  - alias: Tornado Warning Alert
    trigger:
      - platform: state
        entity_id: sensor.nws_alerts
    condition:
      - condition: template
        value_template: >
          {{ state_attr('sensor.nws_alerts', 'Alerts') | selectattr('Event', 'equalto', 'Tornado Warning') | list | length > 0 }}
    action:
      - repeat:
          count: 6
          sequence:
            - service: light.turn_on
              target:
                entity_id: light.all_wiz_lights
              data:
                brightness: 255
                color_name: "red"
                transition: 0
            - delay: "00:00:00.25"
            - service: light.turn_off
              target:
                entity_id: light.all_wiz_lights
              data:
                transition: 0
            - delay: "00:00:00.25"
      - service: light.turn_on
        target:
          entity_id: light.all_wiz_lights
        data:
          brightness: 255
          color_name: "red"
          transition: 0
```

---

## 📝 Notes

- Replace the example light entity IDs (`light.wiz_rgbww_tunable_*`) with your actual IDs.
- Use the `all_wiz_lights` entity in additional automations to easily control all lights as a group.
- Ensure you test automations thoroughly to confirm compatibility with your setup.

For more details, check the [Home Assistant documentation](https://www.home-assistant.io/) or visit the [Home Assistant Community Forum](https://community.home-assistant.io/).
