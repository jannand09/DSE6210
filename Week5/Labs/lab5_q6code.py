# -*- coding: utf-8 -*-
"""
Created on Sun Jul  9 11:57:01 2023
Lab question 6 sample code

@author: jlowh
"""
#import pymongo
import pymongo

#create your connection string
connect_string = ""
#create a connection to your Atlas cluster
client = pymongo.MongoClient(connect_string)

#connect to the sample_restaraunts database
db = client.sample_restaurants

#establish a connection to the restarants collection
my_collection = db["restaurants"]

#find a document with the restaraunt name Nordic Delicacies
nordic = my_collection.find_one({"name": "Nordic Delicacies"})

#find the type of the queried document
type(nordic)