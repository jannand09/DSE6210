# -*- coding: utf-8 -*-
"""
Created on Sun Jul  9 11:57:01 2023
Lab question 6 sample code

@author: jlowh
"""
#import pymongo
import pymongo

#create your connection string
connect_string = "mongodb+srv://annandj:kitkatbaka@cluster0.mmpel.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
#create a connection to your Atlas cluster
client = pymongo.MongoClient(connect_string)

#connect to the sample_restaraunts database
restaurants_db = client.sample_restaurants

#establish a connection to the restarants collection
rest_coll = restaurants_db["restaurants"]

#find a document with the restaraunt name Nordic Delicacies
nordic = rest_coll.find_one({"name": "Nordic Delicacies"})

#find the type of the queried document
type(nordic)

print(nordic)

print(nordic['cuisine'])
# db = client.sample_airbnb
# collection = db['listingsAndReviews']


# test = collection.find({'bedrooms':{'$gte':10}})


# test = my_collection.find()