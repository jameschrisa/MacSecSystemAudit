#!/bin/zsh

# Mac Security Audit Script (Zsh version)

print "Mac Security Audit Report"
print "========================="
print "Date: $(date)"
print "Hostname: $(hostname)"
print "========================="

# Function to check if a command exists
command_exists() {
    whence -p "$1" >/dev/null
}

# Function to check if a setting is enabled
is_enabled() {
    if [[ "$1" == "1" || "$1" == "true" || "$1" == "yes" ]]; then
        print "Enabled"
    else
        print "Disabled"
    fi
}

# Check FileVault status
print "FileVault Status:"
if fdesetup status | grep -q "FileVault is On"; then
    print "FileVault is enabled"
else
    print "FileVault is disabled"
fi

# Check Firewall status
print -n "Firewall Status: "
if [[ "$(sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate)" == "Firewall is enabled. (State = 1)" ]]; then
    print "Enabled"
else
    print "Disabled"
fi

# Check SIP (System Integrity Protection) status
print -n "SIP Status: "
if csrutil status | grep -q "enabled"; then
    print "Enabled"
else
    print "Disabled"
fi

# Check if automatic updates are enabled
print -n "Automatic Updates: "
auto_update=$(sudo defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled)
is_enabled "$auto_update"

# Check if Gatekeeper is enabled
print -n "Gatekeeper Status: "
gatekeeper_status=$(spctl --status)
is_enabled "$gatekeeper_status"

# Check if Find My Mac is enabled
print -n "Find My Mac Status: "
fmm_status=$(sudo defaults read /Library/Preferences/com.apple.FindMyMac FMMEnabled)
is_enabled "$fmm_status"

# Check if Remote Login (SSH) is enabled
print -n "Remote Login (SSH) Status: "
ssh_status=$(sudo systemsetup -getremotelogin | awk '{print $3}')
is_enabled "$ssh_status"

# Check if Screen Sharing is enabled
print -n "Screen Sharing Status: "
screen_sharing=$(sudo launchctl list | grep com.apple.screensharing)
if [[ -n "$screen_sharing" ]]; then
    print "Enabled"
else
    print "Disabled"
fi

# Check if FileVault is enabled for the current user
print -n "FileVault Status for current user: "
fv_status=$(sudo fdesetup list | grep "$(whoami)")
if [[ -n "$fv_status" ]]; then
    print "Enabled"
else
    print "Disabled"
fi

# Check if Password is required immediately after sleep or screen saver begins
print -n "Immediate password requirement after sleep/screen saver: "
pwd_delay=$(defaults read com.apple.screensaver askForPassword)
is_enabled "$pwd_delay"

# Check if Secure Keyboard Entry is enabled in Terminal
print -n "Secure Keyboard Entry in Terminal: "
secure_input=$(defaults read -app Terminal SecureKeyboardEntry)
is_enabled "$secure_input"

# Check for installed security software
print "Installed Security Software:"
if command_exists "lsregister"; then
    lsregister -dump | grep -E "/Applications/(BitDefender|Malwarebytes|Sophos|Avast|AVG|Norton|McAfee)" | awk -F/ '{print $NF}' | sed 's/\.app//' | sort -u
else
    print "Unable to check for security software (lsregister not found)"
fi

print "========================="
print "Security Audit Complete"
