# Mac Security Audit Scripts

This repository contains two scripts for conducting a comprehensive security audit on a Mac system. These scripts are designed for users who are concerned about their system's security and want to perform a quick check of various security settings and features.

## Scripts

1. `mac_security_audit_bash.sh`: Bash version of the security audit script
2. `mac_security_audit_zsh.zsh`: Zsh version of the security audit script

Both scripts provide the same functionality and output. Choose the one that matches your preferred shell or the default shell on your system.

## Features

These scripts check the following security settings and features:

1. FileVault status
2. Firewall status
3. System Integrity Protection (SIP) status
4. Automatic updates
5. Gatekeeper status
6. Find My Mac status
7. Remote Login (SSH) status
8. Screen Sharing status
9. FileVault status for the current user
10. Password requirement after sleep/screen saver
11. Secure Keyboard Entry in Terminal
12. Installed security software

## Usage

1. Clone this repository or download the scripts to your local machine.

2. Make the scripts executable:
   ```
   chmod +x mac_security_audit_bash.sh mac_security_audit_zsh.zsh
   ```

3. Run the script with sudo privileges:
   
   For Bash:
   ```
   sudo ./mac_security_audit_bash.sh
   ```
   
   For Zsh:
   ```
   sudo ./mac_security_audit_zsh.zsh
   ```

4. Review the output, which will provide a summary of your system's security settings.

## Output

The script will generate a report with the following format:

```
Mac Security Audit Report
=========================
Date: [Current Date and Time]
Hostname: [Your Mac's Hostname]
=========================
[Security Check Results]
=========================
Security Audit Complete
```

## Note

- These scripts require sudo privileges to access certain system information.
- The scripts do not make any changes to your system; they only report the current status of various security settings.
- Some checks may require specific macOS versions or features to be present on your system.

## Customization

You can modify these scripts to add additional checks or remove existing ones based on your specific security requirements. Each check is clearly commented in the script, making it easy to understand and customize.

## Disclaimer

These scripts are provided as-is and are meant for informational purposes only. Always ensure you understand the implications of any security settings you modify on your system.

## Contributing

Feel free to fork this repository and submit pull requests with improvements or additional security checks that you find useful.

## License

[MIT License](LICENSE)

