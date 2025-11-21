-- ============================================
-- CONFIGURATION - Edit these settings
-- ============================================
set logFilePath to "/tmp/jokes_message.log"
set phoneNumbersFile to "personal:jokes_numbers.txt"
set messagesFile to "personal:jokes_messages.txt"
set maxRandomDelay to 60 -- seconds (0 to this value)
set messagePrefix to "Smile a little: " -- Prefix added to each message (set to "" for no prefix)

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

-- Trim whitespace helper function
on trimWhitespace(theText)
	set whiteSpaceChars to {space, tab, return, linefeed}
	repeat while theText begins with space or theText begins with tab
		set theText to text 2 thru -1 of theText
	end repeat
	repeat while theText ends with space or theText ends with tab
		set theText to text 1 thru -2 of theText
	end repeat
	return theText
end trimWhitespace

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
		set thisLine to contents of p
		if thisLine is not "" then
			-- Extract phone number (before comma)
			set AppleScript's text item delimiters to ","
			set phoneNumber to text item 1 of thisLine
			set AppleScript's text item delimiters to ""
			-- Trim whitespace
			set phoneNumber to my trimWhitespace(phoneNumber)
			if phoneNumber is not "" then set end of phoneNumbers to phoneNumber
		end if
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
		set fullMessage to messagePrefix & chosenMessage
		
		my writeLog("Sending to " & phoneNumber & ": " & fullMessage, logFilePath)
		
		try
			set theBuddy to participant phoneNumber of theService
			send fullMessage to theBuddy
			my writeLog("Message sent successfully to " & phoneNumber, logFilePath)
		on error errMsg
			my writeLog("ERROR sending to " & phoneNumber & ": " & errMsg, logFilePath)
		end try
		
		delay 1
	end repeat
	
	my writeLog("All messages sent", logFilePath)
end tell

writeLog("Script completed", logFilePath)
