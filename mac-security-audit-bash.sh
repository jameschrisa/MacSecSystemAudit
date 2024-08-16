#!/bin/bash

# Mac Security Audit Script

echo "Mac Security Audit Report"
echo "========================="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "========================="

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a setting is enabled
is_enabled() {
    if [ "$1" == "1" ] || [ "$1" == "true" ] || [ "$1" == "yes" ]; then
        echo "Enabled"
    else
        echo "Disabled"
    fi
}

# Check FileVault status
echo "FileVault Status:"
if fdesetup status | grep -q "FileVault is On"; then
    echo "FileVault is enabled"
else
    echo "FileVault is disabled"
fi

# Check Firewall status
echo -n "Firewall Status: "
if [ "$(sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)" == "Firewall is enabled. (State = 1)" ]; then
    echo "Enabled"
else
    echo "Disabled"
fi

# Check SIP (System Integrity Protection) status
echo -n "SIP Status: "
if csrutil status | grep -q "enabled"; then
    echo "Enabled"
else
    echo "Disabled"
fi

# Check if automatic updates are enabled
echo -n "Automatic Updates: "
auto_update=$(sudo defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled)
is_enabled "$auto_update"

# Check if Gatekeeper is enabled
echo -n "Gatekeeper Status: "
gatekeeper_status=$(spctl --status)
is_enabled "$gatekeeper_status"

# Check if Find My Mac is enabled
echo -n "Find My Mac Status: "
fmm_status=$(sudo defaults read /Library/Preferences/com.apple.FindMyMac FMMEnabled)
is_enabled "$fmm_status"

# Check if Remote Login (SSH) is enabled
echo -n "Remote Login (SSH) Status: "
ssh_status=$(sudo systemsetup -getremotelogin | awk '{print $3}')
is_enabled "$ssh_status"

# Check if Screen Sharing is enabled
echo -n "Screen Sharing Status: "
screen_sharing=$(sudo launchctl list | grep com.apple.screensharing)
if [ -n "$screen_sharing" ]; then
    echo "Enabled"
else
    echo "Disabled"
fi

# Check if FileVault is enabled for the current user
echo -n "FileVault Status for current user: "
fv_status=$(sudo fdesetup list | grep "$(whoami)")
if [ -n "$fv_status" ]; then
    echo "Enabled"
else
    echo "Disabled"
fi

# Check if Password is required immediately after sleep or screen saver begins
echo -n "Immediate password requirement after sleep/screen saver: "
pwd_delay=$(defaults read com.apple.screensaver askForPassword)
is_enabled "$pwd_delay"

# Check if Secure Keyboard Entry is enabled in Terminal
echo -n "Secure Keyboard Entry in Terminal: "
secure_input=$(defaults read -app Terminal SecureKeyboardEntry)
is_enabled "$secure_input"

# Check for installed security software
echo "Installed Security Software:"
if command_exists "lsregister"; then
    lsregister -dump | grep -E "/Applications/(BitDefender|Malwarebytes|Sophos|Avast|AVG|Norton|McAfee)" | awk -F/ '{print $NF}' | sed 's/\.app//' | sort -u
else
    echo "Unable to check for security software (lsregister not found)"
fi

echo "========================="
echo "Security Audit Complete"
