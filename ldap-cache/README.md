

# LDAP Cache Script for Home Assistant

This script fetches user data from an LDAP server, formats it as JSON, and saves it to a cache file. It's designed for environments where LDAP integration is required, and caching user data simplifies subsequent operations.

---

## 📋 Prerequisites

To use this script on a **Home Assistant OS instance**, you'll need the following:

1. **File Editor Add-on**: 
   - Provides a simple file editor to manage and edit configuration files directly within Home Assistant.
   - Install it from the **Add-on Store** under **Settings > Add-ons > Add-on Store**.

2. **SSH & Web Terminal Add-on**:
   - Enables SSH access for running commands on the Home Assistant OS.
   - Install it from the **Add-on Store**, then configure it under **Settings > Add-ons > SSH & Web Terminal**.

3. **LDAP Utilities**:
   - The script requires `ldapsearch`, which can be installed by running:
     ```bash
     apk add openldap-clients
     ```
   - This command works directly in the SSH terminal on Home Assistant OS.

---

## 🛠️ Installation Steps

Follow these steps to set up and use the script on Home Assistant:

### 1. Enable SSH Access
1. Install and configure the **SSH & Web Terminal Add-on**.
2. Ensure you can access the Home Assistant OS via SSH.

### 2. Install `ldapsearch`
1. Open the SSH terminal.
2. Run the following command to install `ldapsearch`:
   ```bash
   apk add openldap-clients
   ```
3. Confirm installation by typing:
   ```bash
   ldapsearch --help
   ```
   If the help menu appears, `ldapsearch` is installed successfully.

### 3. Download the Script
1. Use the **File Editor Add-on** or `scp` (secure copy) to upload the script to a desired location in the Home Assistant file system (e.g., `/config/ldap_cache.sh`).

### 4. Configure the Script
1. Open the script file using the **File Editor** or a text editor of your choice:
   ```bash
   nano /config/ldap_cache.sh
   ```
2. Update the following configuration fields:
   - `SERVER`: Replace with your LDAP server URL.
   - `BIND_DN`: Replace with your LDAP Bind Distinguished Name.
   - `SEARCH_BASE`: Replace with your LDAP search base.
   - `CACHE_FILE`: Set the path where the cache file will be stored (e.g., `/config/ad_user_cache.json`).

3. **Set the Password**:
   For security, set your LDAP password as an environment variable:
   ```bash
   export LDAP_PASSWORD="your_password_here"
   ```

### 5. Test the Script
1. Make the script executable:
   ```bash
   chmod +x /config/ldap_cache.sh
   ```
2. Run the script:
   ```bash
   /config/ldap_cache.sh
   ```
3. Verify the output:
   - Check the cache file for JSON data:
     ```bash
     cat /config/ad_user_cache.json
     ```

### 6. Automate Script Execution
To keep the cache updated regularly, you can set up a cron job or a Home Assistant automation. Example automation (using the Home Assistant SSH Add-on):
1. Create an automation to run the script periodically.
2. Use the `shell_command` integration:
   ```yaml
   shell_command:
     update_ldap_cache: "/bin/bash /config/ldap_cache.sh"
   ```
3. Trigger the `shell_command.update_ldap_cache` in automations.

---

## 🚑 Troubleshooting

1. **JSON Validation Fails**:
   - If the cache file has invalid JSON, the script will attempt to correct it automatically.
   - Check the logs for any errors or inspect the cache file manually.

2. **Permission Issues**:
   - Ensure the script has executable permissions (`chmod +x /config/ldap_cache.sh`).

3. **LDAP Connectivity**:
   - Use the `ldapsearch` command to test connectivity:
     ```bash
     ldapsearch -H ldap://your-server.com -D "cn=your-user,dc=example,dc=com" -w your_password -b "dc=example,dc=com"
     ```

---

## 📜 License

This project is licensed under the [Beerware License](LICENSE). Feel free to use, modify, and share. If you find it useful, raise a toast to ChatGPT!

---

This guide ensures clarity for beginners and experts alike. Let me know if you'd like further customization or enhancements!
