#!/bin/bash

# Define sender email, subject, and message from script settings or command line arguments
from_email="support@test.com"
subject="Create new order"

# Read email list from a text file
email_list="emails.txt"
if [ ! -f "$email_list" ]; then
    echo "Email list file not found."
    exit 1
fi

# Define the HTML message content
message=$(cat <<EOF
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Order Request</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #007bff;
            color: #fff;
            text-align: center;
            padding: 20px 0;
        }
        .content {
            padding: 20px;
        }
        .signature {
            margin-top: 20px;
            font-style: italic;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>New Order Request</h1>
    </div>
    <div class="content">
        <p>Dear Team,</p>
        <p>We have received a new order request from <strong>Mohammad</strong>. Please proceed accordingly.</p>
        <p>Thank you!</p>
    </div>
    <div class="signature">
        <p>Best regards,</p>
        <p>Your Name</p>
        <p>Your Company</p>
    </div>
</body>
</html>
EOF
)

# Split email list into batches of 10 email addresses
split -l 10 -d "$email_list" emails_split_

# Loop through email batches and send emails
for file in emails_split_*; do
    while read -r to_email; do
        echo "Sending email to $to_email..."
        # Send email using mail command with HTML content
        echo "$message" | mail -s "$subject" -a "Content-Type: text/html" -a "From: $from_email" "$to_email"
        if [ $? -eq 0 ]; then
            echo "Email sent to $to_email successfully."
        else
            echo "Failed to send email to $to_email."
        fi
    done < "$file"
    sleep 5m  # Wait for 5 minutes between each batch of emails
done

# Generate sending report
echo "Sending report:"
echo "---------------"
echo "Total emails sent: $(wc -l < $email_list)"
echo "Success: $(grep -c "Email sent to" $0)"
echo "Failed: $(grep -c "Failed to send" $0)"
