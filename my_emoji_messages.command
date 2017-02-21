# -*- coding: utf-8 -*-
#!/usr/bin/python
from __future__ import division
from __future__ import unicode_literals

import os
import datetime
import sqlite3
import re
import sys
import time
import codecs
import json
import codecs

from collections import defaultdict
from em_emoji import all_emoji
from em_message import EMMessage


class MyEmojiMessages():

    def __init__(self):
        db_path = os.path.expanduser('~/Library/Messages/chat.db')
        self.cnx = sqlite3.connect(db_path)
        self.base_query = "select guid, date, text, is_from_me from message" 

    def get_last_message(self, from_me=None):
        cursor = self.cnx.cursor()
        query = self.base_query
        if from_me is not None:
            query += " where is_from_me = %d " % (1 if from_me else 0)

        query += " order by date desc limit 1"
        row = next(cursor.execute(query))
        return EMMessage(row)

    def get_first_message(self, from_me=None):
        cursor = self.cnx.cursor()
        query = self.base_query
        if from_me is not None:
            query += " where is_from_me = %d " % (1 if from_me else 0)

        query += " order by date asc limit 1"
        row = next(cursor.execute(query))
        return EMMessage(row)

    def count_emoji_messages(self, emoji, from_me=True):
        cursor = self.cnx.cursor()
        query = u'select count(*) from message where text like "%' + emoji + u'%"'
        if from_me is not None:
            query += u" and is_from_me = %d " % (1 if from_me else 0)

        return next(cursor.execute(query))[0]

    def count_messages(self, from_me=None):
        cursor = self.cnx.cursor()
        query = "select count(*) from message"
        if from_me is not None:
            query += " where is_from_me = %d " % (1 if from_me else 0)
        cursor.execute(query)
        row = next(cursor)
        return row[0]


if __name__ == '__main__':
    mm = MyEmojiMessages()

    save = dict()

    save['count_total'] = mm.count_messages()
    save['count_from_me'] = mm.count_messages(from_me=True)
    save['count_from_others'] = mm.count_messages(from_me=False)        

    print("")
    print("Counting messages in your iMessages...")
    print("")

    print("Message count in total:    %d" % save['count_total'])
    print("Message count from you:    %d" % save['count_from_me'])
    print("Message count from others: %d" % save['count_from_others'])

    first_message = mm.get_first_message(from_me=True)
    last_message = mm.get_last_message(from_me=True)

    first_datetime =first_message.datetime()
    last_datetime =last_message.datetime()
    
    save['num_days'] = (last_datetime - first_datetime).days

    save['first_date_iso'] = first_datetime.date().isoformat()
    save['last_date_iso'] = last_datetime.date().isoformat()

    print("")
    print("First message from you on: %s" % save['first_date_iso'])
    print("Last message from you on:  %s" % save['last_date_iso'])
    print("Number of days in between: %d" % save['num_days'])
    print("Number of messages/day:    %.2f" % (save['count_from_me'] / save['num_days']))

    count_dict = dict()
    per_day_dict = dict()

    emoji_list = all_emoji
    for emoji in emoji_list:
        count = mm.count_emoji_messages(emoji, from_me=True)
        if count > 0:
            count_dict[emoji] = count 
            per_day_dict[emoji] = count / save['num_days']

    for count in sorted(count_dict.items(), key=(lambda x: -x[1])):
        print("%s   : %s" % count)

    save['counts_per_day'] = per_day_dict
    save['counts'] = count_dict

    file_path = os.path.expanduser('~/Desktop/%s_messages.json' % os.getlogin())
    with codecs.open(file_path, 'w', 'utf-8') as out_file:
        json.dump(save, out_file)









