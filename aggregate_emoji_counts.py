# -*- coding: utf-8 -*-

import os
import codecs
import em_emoji
import json


file_path = os.path.expanduser('~/Desktop/%s_messages.json' % os.getlogin())

with codecs.open('emoji_codes.json', 'r', 'utf-8') as code_file:
	codes = json.load(code_file)

def to_translate(code):
	index = codes.index(code)
	return(em_emoji.all_emoji[index])

with codecs.open(file_path, 'r', 'utf-8') as in_file:
	data = json.load(in_file)
