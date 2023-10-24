# -*- coding: utf-8 -*-
"""
Created on Wed Oct  4 16:12:00 2023

@author: Lowhorn
"""

import pymongo
import os
connect_string = os.environ['MONGODBCONN']
client = pymongo.MongoClient(connect_string)
del connect_string

db = client["test"]
test_collection = db['test']

test_record = {'_id':1,
               'name':'John Adams',
               'address':'123 Main Street'
               }

test_collection.insert_one(test_record)

test_record2 = {'_id':2,
                'fruit':'carrot',
                'vitamin':'beta-carrotine'}

test_collection.insert_one(test_record2)


test_record3 = [{'_id':3,
                 'name':'Tom Hardy'},
                {'_id':4,
                 'name':'Bob Dole'}
    ]

test_collection.insert_many(test_record3)


find_arg = { "fruit": "carrot"}
change_arg = {'$set':{ 'vitamin':'vitamin A'}}

test_collection.update_one(find_arg,change_arg)

test_collection.drop()