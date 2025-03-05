# -*- coding: utf-8 -*-
"""
Created on Sat Jul 22 21:26:37 2023

@author: Lowhorn
"""

#import pymongo
import pymongo

#create your connection string
connect_string = "mongodb+srv://annandj:kitkatbaka@cluster0.mmpel.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
#create a connection to your Atlas cluster
client = pymongo.MongoClient(connect_string)

#connect to the sample_mflix.movies db
collection = client['sample_mflix']['movies']

"""
Exercise 1
Create a mongo_db connection with pymongo to your database
https://pymongo.readthedocs.io/en/stable/examples/authentication.html

For the homework we will be using the sample_mflix.movies collection. 

What is the title of the movie with the highest IMDB rating?

***Note*** match, sort, limit, project.
collection.aggregate(query) is the syntax for aggregation pipelines in Python. 

https://pymongo.readthedocs.io/en/stable/examples/aggregation.html
"""

result1 = collection.aggregate([
    {
        '$match': {
            'imdb.rating': {
                '$type': 'number'
            }
        }
    }, {
        '$sort': {
            'imdb.rating': -1
        }
    }, {
        '$limit': 1
    }, {
        '$project': {
            'title': 1, 
            'imdb_rating': '$imdb.rating'
        }
    }
])

result1 = list(result1)

for doc in result1:
    print(doc.items())

"""
Exercise 2
Which year had the most titles released? 
***Note*** group, sort, limit

"""

result2 = collection.aggregate([
    {
        '$group': {
            '_id': '$year', 
            'count': {
                '$sum': 1
            }
        }
    }, {
        '$sort': {
            'count': -1
        }
    }, {
        '$limit': 1
    }
])
        
result2 = list(result2)

for doc in result2:
    print(doc.items())
  
"""
Exercise 3
What are the four directors with the most titles accredited to them? 
***Note*** project, unwind, group, sort, limit

"""

result3 = collection.aggregate([
    {
        '$project': {
            'title': 1, 
            'directors': 1
        }
    }, {
        '$unwind': {
            'path': '$directors'
        }
    }, {
        '$group': {
            '_id': '$directors', 
            'count': {
                '$sum': 1
            }
        }
    }, {
        '$sort': {
            'count': -1
        }
    }, {
        '$limit': 4
    }
])
        
result3 = list(result3)

for doc in result3:
    print(doc.items())
  
"""
Exercise 4
Show the title and number of languages the movie was produced in for the following: 
    Year:2013, genre:'Action'
"""

result4 = collection.aggregate([
    {
        '$unwind': {
            'path': '$genres'
        }
    }, {
        '$match': {
            '$and': [
                {
                    'genres': 'Action'
                }, {
                    'year': 2013
                }
            ]
        }
    }, {
        '$project': {
            'title': 1, 
            'num_of_lang': {
                # use $ifNull to replace null values with empty array
                # worked fine in Atlas without but Pymongo raised error
                '$size': { '$ifNull': ['$languages', []] }
            }
        }
    }
])
        
result4 = list(result4)

# print contents of first five documents
for i in range(5):
    print(result4[i])
