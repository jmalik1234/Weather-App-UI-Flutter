import firebase_admin 
from firebase_admin import credentials
from firebase_admin import firestore
import weather_data
import firebase_admin
from firebase_admin import credentials
from flask import Flask, request, jsonify

#get user search location
#go fetch from weather api
#store in db
f="/Users/rishikasrinivas/Documents/Rishika/UCSC/Projects/WeatherApp/Weather/weatherapp-6d528-firebase-adminsdk-4adbr-bab2f67e6d.json"
cred = credentials.Certificate(f)
firebase_admin.initialize_app(cred)

db = firestore.client()
city = "Cupertino"
d= weather_data.get_weather_data()
data = {
    'age' : 5
    
}

entry_doc = db.collection('searches').document('G72NlgU1hjTfIexRoOYe')
entry_doc.collection('age').document('cuperrtinpage').set(data)
print(entry_doc.id)