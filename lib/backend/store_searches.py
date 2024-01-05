import firebase_admin 
from firebase_admin import credentials
from firebase_admin import firestore
import weather_api 
import firebase_admin
from firebase_admin import credentials
from flask import Flask, request, jsonify


cred = credentials.Certificate("/Users/rishikasrinivas/Documents/Rishika/UCSC/Projects/Weather-App-UI-Flutter/weatherapp-6d528-firebase-adminsdk-4adbr-bab2f67e6d.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
city = "Cupertino"
w_data, min=weather_api.get_weather_data(city)
data = {
    'data':w_data,
    'min': min
}

entry_doc = db.collection('tasks').document()
entry_doc.set(data)

print(entry_doc.id)