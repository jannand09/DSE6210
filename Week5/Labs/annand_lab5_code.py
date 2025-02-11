# -*- coding: utf-8 -*-
"""
Created on Mon Feb 10 19:47:47 2025

@author: janna
"""


from pymongo.mongo_client import MongoClient

uri = "mongodb+srv://annandj:kitkatbaka@cluster0.mmpel.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

# Create a new client and connect to the server
client = MongoClient(uri)

# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)