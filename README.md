# HA-Tools

Welcome to **HA-Tools**, a practical collection of tools, configurations, and scripts designed to enhance your Home Assistant setup on a budget. This repository focuses on functionality, simplicity, and accessibility, making it easier for others to replicate and adapt these solutions for their own home automation projects.

---

## Overview

This repository is divided into directories, each addressing a specific aspect of home automation:

- [**`smart-lock/`**](smart-lock/): Implements a standalone NFC-based smart lock system.
- [**`ldap-cache/`**](ldap-cache/): Adds Active Directory (AD) or LDAP synchronization to automate user management hourly.
- [**`nws-wiz-alerts/`**](nws-wiz-alerts/): Automations for Wiz lights to perform specific actions based on National Weather Service (NWS) alerts.

Each directory contains everything needed for implementation, including code, configuration files, and guides.

---

## Directories

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

## Getting Started

### Steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/the-imperfectionest/HA-Tools.git
   cd HA-Tools
