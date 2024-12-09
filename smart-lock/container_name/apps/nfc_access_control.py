import appdaemon.plugins.hass.hassapi as hass
import json
import os

class NFCAccessControl(hass.Hass):
    def initialize(self):
        # Load door access configuration from apps.yaml
        self.door_access = self.args.get('door_access', {})
        # Path to the JSON user cache file
        self.ad_user_cache_file = "/config/ad_user_cache.json"
        # Listen for NFC scan events
        self.listen_event(self.handle_nfc_scan, event='esphome.nfc_scan')

    def handle_nfc_scan(self, event_name, data, kwargs):
        nfc_tag_id = data.get('tag_id')
        door_id = data.get('door_id')

        if not nfc_tag_id or not door_id:
            self.log("Missing tag_id or door_id in the event data. Access denied.")
            return

        user = self.get_user_by_nfc_tag(nfc_tag_id)
        if not user:
            self.log(f"Unknown NFC tag scanned: {nfc_tag_id}. Access denied.")
            return

        cn = user.get('cn')
        groups = user.get('groups', [])
        allowed_groups = self.get_allowed_groups_for_door(door_id)

        if not allowed_groups:
            self.log(f"No allowed groups configured for door '{door_id}'. Access denied.")
            return

        if any(group in allowed_groups for group in groups):
            self.log(f"{cn} was granted access to the {door_id.replace('_', ' ').title()}.")
            self.unlock_door(door_id)
        else:
            self.log(f"{cn} was denied access to the {door_id.replace('_', ' ').title()}.")
    
    def get_user_by_nfc_tag(self, nfc_tag_id):
        if not os.path.isfile(self.ad_user_cache_file):
            self.log(f"User cache file not found at {self.ad_user_cache_file}.")
            return None
        try:
            with open(self.ad_user_cache_file, 'r') as f:
                users = json.load(f)
        except Exception as e:
            self.log(f"Error reading user cache file: {e}")
            return None

        for user in users:
            if user.get('nfcTagID') == nfc_tag_id:
                return user
        return None

    def get_allowed_groups_for_door(self, door_id):
        door_config = self.door_access.get(door_id, {})
        return door_config.get('allowed_groups', [])

    def unlock_door(self, door_id):
        self.log(f"Unlocking the {door_id.replace('_', ' ')}.")
        # Call the service exposed by the ESPHome device
        service_name = f"esphome/{door_id}_unlock_door"
        self.call_service(service_name)
