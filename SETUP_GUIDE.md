# Love Message Bot - Setup Guide

## Overview
This AppleScript automatically sends random messages from a predefined list to phone numbers via the macOS Messages app. It includes logging, error handling, and can be scheduled to run automatically using cron.

---

## Prerequisites

- macOS computer with Messages app configured
- SMS/iMessage account set up in Messages
- Text files with phone numbers and messages
- Terminal access

---

## File Structure

```
automessage/
├── love_message_bot.scpt          # Main script
├── jokes_message.scpt              # Jokes variant
├── ~/personal/
│   ├── phone_numbers.txt           # List of phone numbers
│   └── love_messages.txt           # List of messages to send
```

---

## Step 1: Configure the Script

Edit the **CONFIGURATION** section at the top of `love_message_bot.scpt`:

```applescript
-- ============================================
-- CONFIGURATION - Edit these settings
-- ============================================
set logFilePath to "/tmp/love_message_bot2.log"
set phoneNumbersFile to "personal:phone_numbers.txt"
set messagesFile to "personal:love_messages.txt"
set maxRandomDelay to 60 -- seconds (0 to this value)
```

### Configuration Options:
- **logFilePath**: Where to store execution logs (default: `/tmp/love_message_bot2.log`)
- **phoneNumbersFile**: Relative path from home folder to phone numbers file
- **messagesFile**: Relative path from home folder to messages file
- **maxRandomDelay**: Maximum random delay in seconds before sending (0 to this value)

---

## Step 2: Create Input Files

### Phone Numbers File (`~/personal/phone_numbers.txt`)

Create the file with one phone number per line:

```bash
mkdir -p ~/personal
nano ~/personal/phone_numbers.txt
```

Example content:
```
+1234567890
+1987654321
+1555123456
```

**Format notes:**
- One phone number per line
- Include country code (e.g., +1 for US)
- Blank lines are automatically ignored

### Messages File (`~/personal/love_messages.txt`)

Create the file with one message per line:

```bash
nano ~/personal/love_messages.txt
```

Example content:
```
Thinking of you! ❤️
Hope you're having a wonderful day!
You make me smile 😊
Missing you!
```

**Format notes:**
- One message per line
- Blank lines are automatically ignored
- Each phone number receives ONE random message from this list

---

## Step 3: Grant macOS Permissions

### 3.1 Test Run the Script Manually

This triggers permission prompts:

```bash
osascript /Users/saifshams/code/automessage/love_message_bot.scpt
```

**Accept any permission dialogs that appear.**

---

### 3.2 Grant Full Disk Access

1. Open **System Settings → Privacy & Security → Full Disk Access**
2. Click the **lock icon** (bottom left) and authenticate
3. Click the **`+`** button

#### Add Terminal:
- Navigate to: **Applications → Utilities → Terminal**
- Select **Terminal** and click **Open**

#### Add osascript:
- Click **`+`** again
- Press **`Cmd + Shift + G`**
- Type: `/usr/bin/osascript`
- Click **Go**, then **Open**

---

### 3.3 Grant Automation Access to Messages

1. Open **System Settings → Privacy & Security → Automation**
2. Find **Terminal** or **osascript** in the list
3. Enable the checkbox for **Messages**

**Note:** These entries only appear after running the script manually at least once.

---

## Step 4: Verify Manual Execution

Test that everything works without permission prompts:

```bash
osascript /Users/saifshams/code/automessage/love_message_bot.scpt
```

Check the log:

```bash
cat /tmp/love_message_bot2.log
```

Expected log output:
```
Thu Nov 21 10:30:00 2025 - Script started
Thu Nov 21 10:30:00 2025 - Random delay: 45 seconds
Thu Nov 21 10:30:45 2025 - Reading files - Phone: ... Messages: ...
Thu Nov 21 10:30:45 2025 - Phone numbers loaded: 3
Thu Nov 21 10:30:45 2025 - Messages loaded: 4
Thu Nov 21 10:30:45 2025 - Starting message send process
Thu Nov 21 10:30:45 2025 - Messages app activated
Thu Nov 21 10:30:45 2025 - SMS service acquired
Thu Nov 21 10:30:45 2025 - Sending to +1234567890: Thinking of you! ❤️
Thu Nov 21 10:30:46 2025 - Message sent successfully to +1234567890
...
Thu Nov 21 10:30:50 2025 - All messages sent
Thu Nov 21 10:30:50 2025 - Script completed
```

---

## Step 5: Set Up Automated Execution with Cron

### 5.1 Open Crontab Editor

```bash
crontab -e
```

**Important:** The first time you run this, macOS will ask for permission. **Click "Allow"** when prompted.

---

### 5.2 Add Cron Job

Add one of the following lines based on your schedule preference:

#### Run once per day at 9 AM:
```bash
0 9 * * * /usr/bin/osascript /Users/saifshams/code/automessage/love_message_bot.scpt >> /tmp/cron_love_bot.log 2>&1
```

#### Run three times per day (9 AM, 2 PM, 8 PM):
```bash
0 9,14,20 * * * /usr/bin/osascript /Users/saifshams/code/automessage/love_message_bot.scpt >> /tmp/cron_love_bot.log 2>&1
```

#### Run every hour:
```bash
0 * * * * /usr/bin/osascript /Users/saifshams/code/automessage/love_message_bot.scpt >> /tmp/cron_love_bot.log 2>&1
```

#### Run every day at random time between 9 AM - 5 PM:
You'll need multiple entries with random delays in the script itself (already configured with `maxRandomDelay`):
```bash
0 9 * * * /usr/bin/osascript /Users/saifshams/code/automessage/love_message_bot.scpt >> /tmp/cron_love_bot.log 2>&1
```

---

### 5.3 Save and Exit

- In **nano**: Press `Ctrl + O`, then `Enter`, then `Ctrl + X`
- In **vim**: Press `Esc`, type `:wq`, then `Enter`

---

### 5.4 Verify Cron Job is Active

```bash
crontab -l
```

You should see your cron job listed.

---

## Step 6: Monitor and Troubleshoot

### Check Script Logs

```bash
# View latest logs
tail -f /tmp/love_message_bot2.log

# View all logs
cat /tmp/love_message_bot2.log
```

### Check Cron Logs

```bash
# View cron execution logs
tail -f /tmp/cron_love_bot.log

# View system cron logs
log show --predicate 'process == "cron"' --last 1h
```

### Common Issues

#### Script doesn't run via cron:
- Verify permissions are granted (Step 3)
- Check that Terminal has Full Disk Access
- Ensure cron job path is absolute (not relative)

#### Messages not sending:
- Check Messages app is configured with SMS account
- Verify phone numbers are in correct format (with country code)
- Check log file for error messages

#### Permission denied errors:
- Re-grant Full Disk Access to Terminal and osascript
- Run script manually once to trigger permission prompts

---

## Cron Schedule Format Reference

```
* * * * * command
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

### Examples:

| Schedule | Cron Expression |
|----------|----------------|
| Every day at 9 AM | `0 9 * * *` |
| Every Monday at 9 AM | `0 9 * * 1` |
| Every 2 hours | `0 */2 * * *` |
| Every 30 minutes | `*/30 * * * *` |
| Weekdays at 9 AM | `0 9 * * 1-5` |

---

## Testing Tips

### Test with Small Dataset First
Start with 1-2 phone numbers to verify everything works before scaling up.

### Use Test Phone Number
Add your own number first to verify messages are sent correctly.

### Monitor First Few Runs
Watch the logs closely for the first few scheduled executions:
```bash
tail -f /tmp/love_message_bot2.log
```

---

## Advanced Configuration

### For Multiple Message Lists (e.g., Jokes)

Duplicate the script and modify the configuration:

```applescript
set logFilePath to "/tmp/jokes_message.log"
set phoneNumbersFile to "personal:jokes_numbers.txt"
set messagesFile to "personal:jokes_messages.txt"
```

Add separate cron job:
```bash
0 12 * * * /usr/bin/osascript /Users/saifshams/code/automessage/jokes_message.scpt >> /tmp/cron_jokes.log 2>&1
```

### Rate Limiting for Large Lists

If sending to 50+ numbers, consider:

1. **Increase delay between messages** (edit line with `delay 1`):
```applescript
delay 2  -- or 3 seconds
```

2. **Split into batches** and run at different times:
   - Create `phone_numbers_batch1.txt`, `phone_numbers_batch2.txt`
   - Run different batches at different hours

3. **Add pauses every N messages** (requires script modification)

---

## Log Management

### Rotate Logs Weekly

Add to crontab:
```bash
0 0 * * 0 mv /tmp/love_message_bot2.log /tmp/love_message_bot2_$(date +\%Y\%m\%d).log 2>/dev/null || true
```

### Clear Old Logs Monthly

```bash
0 0 1 * * find /tmp -name "love_message_bot2_*.log" -mtime +30 -delete
```

---

## Security & Privacy Notes

- Phone numbers and messages are stored in plain text files
- Logs contain sent messages and phone numbers
- Keep `/tmp` logs secure or use alternative secure location
- Consider encryption for sensitive data
- Regularly review and clean up old log files

---

## Support & Troubleshooting

### Enable Detailed Logging

The script already includes comprehensive logging. Check:
```bash
cat /tmp/love_message_bot2.log
```

### Test Cron Environment

Create test cron job:
```bash
* * * * * date >> /tmp/cron_test.log 2>&1
```

Wait a minute and verify:
```bash
cat /tmp/cron_test.log
```

If this works but your script doesn't, it's a permissions issue.

---

## Uninstalling

### Remove Cron Job
```bash
crontab -e
# Delete the line with love_message_bot.scpt
```

### Remove Files
```bash
rm /Users/saifshams/code/automessage/love_message_bot.scpt
rm ~/personal/phone_numbers.txt
rm ~/personal/love_messages.txt
rm /tmp/love_message_bot2.log
rm /tmp/cron_love_bot.log
```

### Revoke Permissions
1. System Settings → Privacy & Security → Full Disk Access
2. Remove Terminal and osascript

3. System Settings → Privacy & Security → Automation
4. Disable Messages for Terminal/osascript

---

## License & Disclaimer

Use this script responsibly. Be mindful of:
- Message frequency (avoid spamming)
- Recipient preferences (ensure they want to receive messages)
- Carrier message limits
- Potential spam detection by Apple/carriers

The author is not responsible for any misuse or issues arising from the use of this script.
