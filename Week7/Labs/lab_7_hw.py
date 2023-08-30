# -*- coding: utf-8 -*-
"""
Created on Sat Jul 22 21:26:37 2023

@author: Lowhorn
"""

#import pymongo
import pymongo

"""
Exercise 1
Create a mongo_db connection with pymongo to your database
https://pymongo.readthedocs.io/en/stable/examples/authentication.html

For the homework we will be using the sample_restaurants.restaurants collection. 

Using find(), write a find query to extract the Italian restaurants in Manhattan to a Python list. 
Use len() to count the number of restaurants located in Manhattan. 

***Note*** All MongoDB functions and fields MUST be in quotes inside of the find() method. Ex $and should be "$and".

https://www.w3schools.com/python/python_mongodb_find.asp
"""


  
"""
Exercise 2
Using find, determine how many Japanese and Italian restaurants have an A rating in Queens.

"""

  
"""
Exercise 3
The following MongoDB aggregation query is missing a aggregation expression that will calculate the BSON size of the documents. 
A list of these can be found at the end of this week's notes. Identify the missing aggregation expression.
Print the 10 document ids and sizes that have the highest BSON size. 
"""

res = mycol.aggregate([
    { "$addFields": {
        "bsonsize": { "<missing expression>": "$$ROOT" }
    }},
    { "$sort": { "bsonsize": -1 }},
    { "$limit": <'missingvalue'> },
    { "$project": {
        "_id": <'missingvalue'>,
        "bsonsize": <'missingvalue'>
    }}
])
    

    
"""
Exercise 4
Find all of the restaurants that have NOT had an 'A', 'B', and 'Not Yet Graded' rating. How many restaurants is this?
"""


    