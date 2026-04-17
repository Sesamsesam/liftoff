# Google Workspace CLI - Command Reference

> **Agent cheat sheet.** Consult this file when the user asks to perform a Google Workspace action. Use helper commands (`+`) whenever available - they're simpler and handle common patterns automatically.

---

## Gmail

### Helper Commands

```bash
# Send an email
gws gmail +send --to "user@example.com" --subject "Subject" --body "Body text"

# Send with CC/BCC
gws gmail +send --to "user@example.com" --cc "cc@example.com" --bcc "bcc@example.com" --subject "Subject" --body "Body"

# Send with attachment
gws gmail +send --to "user@example.com" --subject "Subject" --body "Body" --attach ./file.pdf

# Reply to a message
gws gmail +reply --message-id MESSAGE_ID --body "Reply text"

# Reply-all
gws gmail +reply-all --message-id MESSAGE_ID --body "Reply text"

# Forward a message
gws gmail +forward --message-id MESSAGE_ID --to "recipient@example.com"

# Inbox triage (unread summary)
gws gmail +triage

# Watch for new emails (streaming)
gws gmail +watch
```

### Raw API Commands

```bash
# List messages (most recent)
gws gmail users messages list --params '{"userId":"me","maxResults":10}'

# Search messages
gws gmail users messages list --params '{"userId":"me","q":"from:boss@company.com is:unread"}'

# Get a specific message
gws gmail users messages get --params '{"userId":"me","id":"MESSAGE_ID"}'

# List labels
gws gmail users labels list --params '{"userId":"me"}'

# Modify labels on a message
gws gmail users messages modify --params '{"userId":"me","id":"MESSAGE_ID"}' --json '{"addLabelIds":["STARRED"]}'
```

---

## Drive

### Helper Commands

```bash
# Upload a file
gws drive +upload ./document.pdf --name "My Document"

# Upload to a specific folder
gws drive +upload ./file.pdf --name "Report" --parent FOLDER_ID
```

### Raw API Commands

```bash
# List files (most recent)
gws drive files list --params '{"pageSize":10,"orderBy":"modifiedTime desc"}'

# Search for files by name
gws drive files list --params '{"q":"name contains '\''report'\''","pageSize":10}'

# Search for files by type
gws drive files list --params '{"q":"mimeType='\''application/vnd.google-apps.spreadsheet'\''","pageSize":10}'

# Get file metadata
gws drive files get --params '{"fileId":"FILE_ID","fields":"id,name,mimeType,size,modifiedTime"}'

# Create a folder
gws drive files create --json '{"name":"New Folder","mimeType":"application/vnd.google-apps.folder"}'

# Move a file to a folder
gws drive files update --params '{"fileId":"FILE_ID","addParents":"FOLDER_ID","removeParents":"OLD_PARENT_ID"}'

# Delete a file (moves to trash)
gws drive files update --params '{"fileId":"FILE_ID"}' --json '{"trashed":true}'

# Share a file
gws drive permissions create --params '{"fileId":"FILE_ID"}' --json '{"role":"reader","type":"user","emailAddress":"user@example.com"}'
```

---

## Calendar

### Helper Commands

```bash
# Today's agenda
gws calendar +agenda

# Today's agenda in a specific timezone
gws calendar +agenda --today --timezone America/New_York

# Create a new event
gws calendar +insert
```

### Raw API Commands

```bash
# List upcoming events
gws calendar events list --params '{"calendarId":"primary","maxResults":10,"orderBy":"startTime","singleEvents":true,"timeMin":"2026-01-01T00:00:00Z"}'

# Get a specific event
gws calendar events get --params '{"calendarId":"primary","eventId":"EVENT_ID"}'

# Create an event
gws calendar events insert --params '{"calendarId":"primary"}' --json '{"summary":"Team Meeting","start":{"dateTime":"2026-04-20T10:00:00","timeZone":"America/New_York"},"end":{"dateTime":"2026-04-20T11:00:00","timeZone":"America/New_York"},"attendees":[{"email":"colleague@example.com"}]}'

# Update an event
gws calendar events update --params '{"calendarId":"primary","eventId":"EVENT_ID"}' --json '{"summary":"Updated Title"}'

# Delete an event
gws calendar events delete --params '{"calendarId":"primary","eventId":"EVENT_ID"}'

# List calendars
gws calendar calendarList list
```

---

## Sheets

### Helper Commands

```bash
# Append a row
gws sheets +append --spreadsheet SPREADSHEET_ID --values "Value1,Value2,Value3"

# Read a range
gws sheets +read --spreadsheet SPREADSHEET_ID --range "Sheet1!A1:C10"
```

### Raw API Commands

```bash
# Create a new spreadsheet
gws sheets spreadsheets create --json '{"properties":{"title":"My Spreadsheet"}}'

# Read values
gws sheets spreadsheets values get --params '{"spreadsheetId":"SPREADSHEET_ID","range":"Sheet1!A1:C10"}'

# Write values
gws sheets spreadsheets values update --params '{"spreadsheetId":"SPREADSHEET_ID","range":"Sheet1!A1","valueInputOption":"USER_ENTERED"}' --json '{"values":[["Header1","Header2"],["Data1","Data2"]]}'

# Append values (adds to bottom)
gws sheets spreadsheets values append --params '{"spreadsheetId":"SPREADSHEET_ID","range":"Sheet1!A1","valueInputOption":"USER_ENTERED"}' --json '{"values":[["New1","New2"]]}'

# Get spreadsheet metadata
gws sheets spreadsheets get --params '{"spreadsheetId":"SPREADSHEET_ID"}'
```

---

## Docs

### Helper Commands

```bash
# Append text to a document
gws docs +write --document DOCUMENT_ID --text "New paragraph text"
```

### Raw API Commands

```bash
# Create a new document
gws docs documents create --json '{"title":"My Document"}'

# Get document content
gws docs documents get --params '{"documentId":"DOCUMENT_ID"}'

# Insert text at end of document
gws docs documents batchUpdate --params '{"documentId":"DOCUMENT_ID"}' --json '{"requests":[{"insertText":{"location":{"index":1},"text":"Hello World\n"}}]}'
```

---

## Meet

### Raw API Commands

```bash
# Create a meeting space
gws meet spaces create

# List conference records
gws meet conferenceRecords list

# List participants of a conference
gws meet conferenceRecords participants list --params '{"parent":"conferenceRecords/RECORD_ID"}'
```

---

## Cross-Service Workflows

These commands combine multiple services:

```bash
# Standup report (today's calendar + tasks)
gws workflow +standup-report

# Meeting prep (next meeting agenda, attendees, docs)
gws workflow +meeting-prep

# Convert email to task
gws workflow +email-to-task

# Weekly digest (meetings + email summary)
gws workflow +weekly-digest

# Announce a file in Chat
gws workflow +file-announce
```

---

## Output Parsing Tips

All `gws` commands return **JSON output** by default.

- To extract specific fields, pipe through `jq` if available
- For listing commands, results are typically in a top-level array or under a key like `files`, `messages`, `items`
- Empty results return `{}` or `[]` - this is a valid response, not an error
- Error responses include an `error` object with `code` and `message` fields

```bash
# Example: get just file names from Drive
gws drive files list --params '{"pageSize":5}' | jq '.files[].name'

# Example: get message subjects from Gmail
gws gmail users messages list --params '{"userId":"me","maxResults":5}' | jq '.messages[].id'
```

---

## Common Patterns

### Find then act
Most multi-step operations follow a "find then act" pattern:
1. List/search to find the ID (`gws drive files list`, `gws gmail users messages list`)
2. Use the ID in a follow-up command (`gws drive files get --params '{"fileId":"THE_ID"}'`)

### Pagination
Large result sets use pagination. Look for `nextPageToken` in the response and pass it with `pageToken` in the next request.

### Date/time formats
Google APIs use RFC 3339 format: `2026-04-17T10:00:00Z` (UTC) or `2026-04-17T10:00:00+04:00` (with offset).
