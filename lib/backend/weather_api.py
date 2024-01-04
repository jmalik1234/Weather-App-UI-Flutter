import requests
api_key="cad31c7091c048b1ae88e949b5167636"


def get_weather_data(city):
    

    url = f'http://api.weatherbit.io/v2.0/current?city={city}&country=US&key={api_key}&include=minutely'

    response = requests.get(url)
    if response.status_code == 200:
        l={}
        data = response.json()
        return data['data'], data['minutely']
    else:
        print(response.status_code)    