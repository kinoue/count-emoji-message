# -*- coding: utf-8 -*-
import sys
import os
import codecs
import json
from collections import defaultdict

import em_emoji

emoji_counts = defaultdict(int)
emoji_counts_per_day = defaultdict(int)
total_message_count = 0

sender_count = 0

for arg in sys.argv[1:]: 
    file_path = os.path.expanduser(arg)
    if os.path.isfile(file_path):
        print("Reading %s..." % file_path)
        with codecs.open(file_path, 'r', 'utf-8') as in_file:
            data = json.load(in_file)
            counts = data['counts']
            counts_per_day = data['counts_per_day']
            total_message_count += data['count_from_me']

            sender_count += 1

            for key in counts.keys():
                emoji_counts[key] += counts[key]
                emoji_counts_per_day[key] += counts_per_day[key]

avg_emoji_counts_per_day = { 
    key: value / sender_count for key, value in emoji_counts_per_day.iteritems()
}

file_path = os.path.expanduser('~/Desktop/avg_emoji_counts_per_day.json')
with codecs.open(file_path, 'w', 'utf-8') as out_file:
    json.dump(avg_emoji_counts_per_day, out_file, indent=4, separators=(',', ': '))
    

file_path = os.path.expanduser('~/Desktop/avg_emoji_counts_per_day.csv')
sorted_list = sorted(avg_emoji_counts_per_day.items(), key=lambda x: -x[1])

with codecs.open(file_path, 'w', 'utf-8') as out_file:
    out_file.write("emoji, count/day\n")
    for count in sorted_list:
        out_file.write("%s, %f \n" % count)



