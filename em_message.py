# -*- coding: utf-8 -*-

import datetime

class EMMessage:

    def __init__(self, array):
        self.msgId = array[0]
        self.ts = array[1]
        self.message = array[2]
        self.is_from_me = array[3]

    def datetime(self):
        zero_datetime = datetime.datetime(2000, 1, 1)
        return zero_datetime + datetime.timedelta(seconds=self.ts)
