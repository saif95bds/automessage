-- ============================================
-- CONFIGURATION - Edit these settings
-- ============================================
set logFilePath to "/tmp/love_message_bot2.log"
set phoneNumbersFile to "personal:phone_numbers.txt"
set messagesFile to "personal:love_messages.txt"
set maxRandomDelay to 6 -- seconds (0 to this value)

-- ============================================
-- Log helper function
-- ============================================
on writeLog(logMessage, logPath)
	set logEntry to (current date) as string
	set logEntry to logEntry & " - " & logMessage & return
	try
		set fileHandle to open for access POSIX file logPath with write permission
		write logEntry to fileHandle starting at eof
		close access fileHandle
	on error
		try
			close access POSIX file logPath
		end try
	end try
end writeLog

writeLog("Script started", logFilePath)

-- Random delay
set delaySeconds to (random number from 0 to maxRandomDelay)
writeLog("Random delay: " & delaySeconds & " seconds", logFilePath)
delay delaySeconds

-- Build file paths
set homePath to (path to home folder as text)
set phoneFile to homePath & phoneNumbersFile
set messageFile to homePath & messagesFile

writeLog("Reading files - Phone: " & phoneFile & ", Messages: " & messageFile, logFilePath)

-- Read phone numbers
try
	set phoneText to read file phoneFile
	set phoneLines to paragraphs of phoneText
	set phoneNumbers to {}
	repeat with p in phoneLines
		set thisPhone to contents of p
		if thisPhone is not "" then set end of phoneNumbers to thisPhone
	end repeat
	writeLog("Phone numbers loaded: " & (count of phoneNumbers), logFilePath)
on error errMsg
	writeLog("ERROR reading phone file: " & errMsg, logFilePath)
	display alert "Error reading phone numbers file: " & errMsg
	return
end try

-- Read messages
try
	set messageText to read file messageFile
	set messageLines to paragraphs of messageText
	set messageList to {}
	repeat with m in messageLines
		set thisMsg to contents of m
		if thisMsg is not "" then set end of messageList to thisMsg
	end repeat
	writeLog("Messages loaded: " & (count of messageList), logFilePath)
on error errMsg
	writeLog("ERROR reading message file: " & errMsg, logFilePath)
	display alert "Error reading messages file: " & errMsg
	return
end try

if (count of phoneNumbers) is 0 then
	writeLog("ERROR: No phone numbers found", logFilePath)
	display alert "No phone numbers found."
	return
end if

if (count of messageList) is 0 then
	writeLog("ERROR: No messages found", logFilePath)
	display alert "No messages found."
	return
end if

writeLog("Starting message send process", logFilePath)

tell application "Messages"
	activate
	my writeLog("Messages app activated", logFilePath)
	set theService to first account whose service type is SMS
	my writeLog("SMS service acquired", logFilePath)
	
	repeat with p in phoneNumbers
		set phoneNumber to contents of p
		
		set idx to (random number from 1 to (count of messageList))
		set chosenMessage to item idx of messageList
		
		my writeLog("Sending to " & phoneNumber & ": " & chosenMessage, logFilePath)
		
		try
			set theBuddy to participant phoneNumber of theService
			send chosenMessage to theBuddy
			my writeLog("Message sent successfully to " & phoneNumber, logFilePath)
		on error errMsg
			my writeLog("ERROR sending to " & phoneNumber & ": " & errMsg, logFilePath)
		end try
		
		delay 1
	end repeat
	
	my writeLog("All messages sent", logFilePath)
end tell

writeLog("Script completed", logFilePath)
