#!/bin/bash
# LDAP Cache Script
# Fetches users from LDAP, formats them as JSON, and writes them to a cache file.

########## CONFIGURATION ##########
DEBUG=1
CLIENT="ldapsearch"

# LDAP server details
SERVER="ldap://example.com" # Replace with your LDAP server
BIND_DN="cn=svc-user,ou=ServiceAccounts,dc=example,dc=com" # Replace with your Bind DN
BIND_PASSWORD="your_password_here" # Replace with a secure method of password management
SEARCH_BASE="ou=Users,dc=example,dc=com" # Replace with your search base

# Attributes to fetch
ATTRS="sAMAccountName cn nfcTagID memberOf"

# Filter to identify user objects
FILTER="(&(objectClass=person))"

# File to save the cache
CACHE_FILE="/path/to/ad_user_cache.json" # Adjust to your cache file path

# Timeout for LDAP queries
TIMEOUT=10
########## END CONFIGURATION ##########

# Log messages to stderr
log() {
  echo "$1" >&2
}

# Perform LDAP query and save results to JSON
ldap_query() {
  if [ "$CLIENT" = "ldapsearch" ]; then
    ldapsearch -o nettimeout=$TIMEOUT -H "$SERVER" -x -D "$BIND_DN" -w "$BIND_PASSWORD" \
      -b "$SEARCH_BASE" "$FILTER" $ATTRS | awk '
        BEGIN { 
          print "["; 
          is_first_entry = 1 
        }
        /^dn:/ { 
          if (!is_first_entry) { 
            printf "," 
          } 
          is_first_entry = 0; 
          user = "{"; 
          groups = "" 
        }
        /sAMAccountName:/ { 
          sub(/^sAMAccountName: /, ""); 
          user = user "\"username\":\"" $0 "\"," 
        }
        /cn:/ { 
          sub(/^cn: /, ""); 
          user = user "\"cn\":\"" $0 "\"," 
        }
        /nfcTagID:/ { 
          sub(/^nfcTagID: /, ""); 
          user = user "\"nfcTagID\":\"" $0 "\"," 
        }
        /memberOf:/ { 
          sub(/^memberOf: /, ""); 
          groups = groups "\"" $0 "\"," 
        }
        /^[[:space:]]*$/ { 
          if (user) { 
            sub(/,$/, "", groups);  # Remove trailing comma in groups
            user = user "\"groups\":[" groups "]}"
            print user; 
            user = ""; groups = "" 
          } 
        }
        END { 
          print "]" 
        }
      ' > "$CACHE_FILE"
  else
    log "Unsupported client '$CLIENT'."
    exit 2
  fi
}

########## EXECUTION ##########

log "Fetching LDAP data..."
ldap_query

# Validate JSON output
if jq empty "$CACHE_FILE" > /dev/null 2>&1; then
  log "LDAP data fetched successfully and saved to $CACHE_FILE."
else
  log "JSON validation failed. Attempting correction..."
  # Attempt to fix JSON issues by removing extra commas and rechecking
  sed -i '$s/,$//' "$CACHE_FILE"  # Remove trailing commas at the end of the JSON array
  if jq empty "$CACHE_FILE" > /dev/null 2>&1; then
    log "JSON corrected and saved to $CACHE_FILE."
  else
    log "Failed to correct JSON. Please check $CACHE_FILE for errors."
    exit 1
  fi
fi
