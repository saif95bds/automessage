# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-21

### Added
- **Love Message Bot** (`love_message_bot.scpt`)
  - Automated message sending via macOS Messages app
  - Random message selection from text file
  - Support for multiple phone numbers
  - Random delay before execution (0-60 seconds configurable)
  - Comprehensive logging to `/tmp/love_message_bot2.log`
  - Error handling for file reading and message sending
  - Configuration section at top of script for easy customization

- **Jokes Message Bot** (`jokes_message.scpt`)
  - Similar functionality for sending jokes
  - Configurable message prefix feature
  - Separate log file and phone number list support

- **Phone Number Format Support**
  - Basic format: `+1234567890`
  - Extended format: `+1234567890, Name` (comma-separated)
  - Automatic whitespace trimming
  - Blank line filtering

- **Configuration Options**
  - Log file path customization
  - Phone numbers file path
  - Messages file path
  - Maximum random delay setting
  - Message prefix (jokes bot)

- **Logging Features**
  - Timestamped log entries
  - Script execution tracking
  - File reading confirmation
  - Message send success/failure logging
  - Error details for troubleshooting
  - Append mode (no log overwriting)

- **Documentation**
  - Comprehensive setup guide (`SETUP_GUIDE.md`)
  - macOS permissions instructions
  - Cron scheduling examples
  - Troubleshooting section
  - Security and privacy notes

- **Cron Support**
  - Automated execution via crontab
  - Multiple scheduling patterns supported
  - Separate log files for cron output

### Technical Details
- Platform: macOS only
- Language: AppleScript
- Requirements: Messages app with SMS/iMessage configured
- File format: Compiled AppleScript (`.scpt`)

### Files Structure
```
automessage/
├── love_message_bot.scpt      # Main love messages script
├── jokes_message.scpt          # Jokes messages script
├── SETUP_GUIDE.md              # Complete setup documentation
├── README.md                   # Project overview
└── CHANGELOG.md                # This file
```

### Known Limitations
- macOS only (requires Messages app)
- Requires manual permission grants for Full Disk Access and Automation
- Rate limiting may occur with large recipient lists (50+)
- Cron execution requires proper macOS security permissions

---

## [Unreleased]

### Planned
- Batch processing with pauses for large phone lists
- Retry logic for failed sends
- Log rotation automation
- Multiple message format support (sentence splitting)

---

[1.0.0]: https://github.com/saif95bds/automessage/releases/tag/v1.0.0
