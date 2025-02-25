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

#connect to the sample_restaraunts database
restaurants_db = client.sample_restaurants


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

ex_1_cursor = restaurants_db.restaurants.find({"$and":[{"cuisine":"Italian"},{"borough":"Manhattan"}]})
ex_1_list = list(ex_1_cursor)

print(len(ex_1_list))
  
"""
Exercise 2
Using find, determine how many Japanese and Italian restaurants have an A rating in Queens.

"""
# {$and:[{$or:[{cuisine:"Italian"},{cuisine:"Japanese"}]},{borough:"Queens"},{grades:{$elemMatch:{grade:"A"}}}]}

ex_2_cursor = restaurants_db.restaurants.find({"$and":[{"$or":[{"cuisine":"Italian"},{"cuisine":"Japanese"}]},{"borough":"Queens"},{"grades":{"$elemMatch":{"grade":"A"}}}]})
ex_2_list = list(ex_2_cursor)

print(len(ex_2_list))

"""
Exercise 3
The following MongoDB aggregation query is missing a aggregation expression that will calculate the BSON size of the documents. 
A list of these can be found at the end of this week's notes. Identify the missing aggregation expression.
Print the 10 document ids and sizes that have the highest BSON size. 
"""

res = restaurants_db.restaurants.aggregate([
    { "$addFields": {
        "bsonsize": { "$bsonSize": "$$ROOT" }
    }},
    { "$sort": { "bsonsize": -1 }},
    { "$limit":10 },
    { "$project": {
        "_id":1,
        "bsonsize":1
    }}
])
    
ex_3_list = list(res)

for doc in ex_3_list:
    print(doc.items())
    
"""
Exercise 4
Find all of the restaurants that have NOT had an 'A', 'B', and 'Not Yet Graded' rating. How many restaurants is this?
"""

ex_4_cursor = restaurants_db.restaurants.find({"grades.grade":{"$nin":["A","B","Not Yet Graded"]}})
ex_4_list = list(ex_4_cursor)

print(len(ex_4_list))


client.close()
 