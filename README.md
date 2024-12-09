
---

# **Home Assistant Budget Security Project**

This repository is not intended to be a polished GitHub project but a practical collection of tools, configurations, and instructions to help secure your home using Home Assistant OS on a tight budget.

---

## **Overview**

This project is organized into modular directories, each providing specific functionality:

- **`smart-lock/`**: Standalone NFC-based smart lock code, configuration, and a basic how-to guide.
- **`ldap-cache/`**: Tools for Active Directory (AD) or LDAP synchronization to automate user management hourly.
- **`nws-wiz-alerts/`**: Automations for Wiz lights to perform actions based on National Weather Service (NWS) alerts.

Each module is designed to work independently but can also be combined for a more comprehensive home security and safety solution.

---

## **Directories**

### **1. `smart-lock/`**

This directory includes:

- **Code**: Implements NFC-based smart locking using ESPHome and Home Assistant.
- **Configuration Files**: YAML files for Home Assistant integration.
- **How-To Guide**: Step-by-step setup instructions.

**Key Features**:
- NFC reader integration (e.g., PN532) for secure access.
- Control locks via Home Assistant UI or automations.
- Reed sensor monitoring for door open/closed state.

---

### **2. `ldap-cache/`**

This directory includes:

- **Scripts**: Synchronize user data from AD/LDAP.
- **Configuration Files**: Integrate LDAP with Home Assistant.
- **Automation**: Schedule hourly LDAP synchronization.

**Key Features**:
- Synchronizes user NFC tags and group memberships.
- Automatically updates user permissions based on LDAP group assignments.

---

### **3. `nws-wiz-alerts/`**

This directory includes:

- **Automations**: YAML configurations for controlling Wiz lights based on NWS alerts.
- **Predefined Alerts**: Customizable light actions for different alert types.

**Key Features**:
- Uses Wiz RGBWW lights for visual notifications.
- Supports multiple NWS alert types with customizable behaviors (e.g., red lights for fire alerts, flashing lights for tornado warnings).

---

## **Getting Started**

Follow these steps to set up the desired functionality:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/home-assistant-budget-security.git
   cd home-assistant-budget-security
   ```

2. **Navigate to the Desired Directory**:
   ```bash
   cd smart-lock/
   cd ldap-cache/
   cd nws-wiz-alerts/
   ```

3. **Follow the Documentation**:
   Each directory contains its own README or setup guide with detailed instructions.

---

## **Planned Enhancements**

- Comprehensive how-to guides for each module, including sanitized YAML files.
- Expanded LDAP/AD integration for more robust user management.
- Additional NWS alert types and improved light automation.

---

## **Contributions**

This project is personal and straightforward. Contributions are welcome if they align with the goal of keeping things simple, accessible, and budget-friendly.

---

## **License**

This project is licensed under the **beerware license**:  
If you find this project helpful and meet me someday, feel free to buy me a beer. 🍺

---
