-- Random delay between 0 and 600 seconds (0–10 minutes)
set delaySeconds to (random number from 0 to 600)
delay delaySeconds

-- Now the existing logic
set homePath to (path to home folder as text)
set phoneFile to homePath & "personal:phone_numbers.txt"
set messageFile to homePath & "personal:love_messages.txt"

-- Read phone numbers
set phoneText to read file phoneFile
set phoneLines to paragraphs of phoneText
set phoneNumbers to {}
repeat with p in phoneLines
	set thisPhone to contents of p
	if thisPhone is not "" then set end of phoneNumbers to thisPhone
end repeat

-- Read messages
set messageText to read file messageFile
set messageLines to paragraphs of messageText
set messageList to {}
repeat with m in messageLines
	set thisMsg to contents of m
	if thisMsg is not "" then set end of messageList to thisMsg
end repeat

if (count of phoneNumbers) is 0 then
	display alert "No phone numbers found."
	return
end if

if (count of messageList) is 0 then
	display alert "No messages found."
	return
end if

tell application "Messages"
	activate
	set theService to first account whose service type is SMS
	
	repeat with p in phoneNumbers
		set phoneNumber to contents of p
		
		set idx to (random number from 1 to (count of messageList))
		set chosenMessage to item idx of messageList
		
		set theBuddy to participant phoneNumber of theService
		send chosenMessage to theBuddy
		
		delay 1
	end repeat
end tell
