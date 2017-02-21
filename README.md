# count-emoji-message #

Count number of messages sent by the Messages app (Mac) with each emoji. Aggreate the counts and calculate an average

# How to #

1) Run the script to perform the counting by the following command. 
   It will create a json file USER_NAME_message.json on your Desktop.

    $ python my_emoji_messages.py

2) Once you collect all the counts from the people you can aggreate the counts by the following command. It will create json file and CSV file on your Desktop.

    $ python aggregate_counts.py <message_json_file> [<message_json_file>...]

