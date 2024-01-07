import requests
from flask import Flask, request, jsonify
api_key="cad31c7091c048b1ae88e949b5167636"

#using flask to develop api to post/get to/from 
app = Flask(__name__)
weather = {}
@app.route('/weather_post', methods=['POST'])
def get_weather_data():
    #data = request.json
    city = 'Cupertino' #data['city'] = 
   
    country =  'USA' #data['country'] =
    url = f'http://api.weatherbit.io/v2.0/current?city={city}&country={country}=US&key={api_key}&include=minutely'

   
    
    response = requests.get(url)
       
    if response.status_code == 200:
        data = response.json()
        weather['latest'] = data
        return weather['latest'] #jsonify(data)
    else:
        print(response.status_code)  

@app.route('/weatherReport', methods=['GET'])
def getData():
    return jsonify(weather['latest'])
    
if __name__ == '__main__':
    app.run(debug=True)