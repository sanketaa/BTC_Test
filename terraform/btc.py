import json
import requests
import time
import datetime
from datetime import datetime
def lambda_handler(event, context):
        response = requests.get('https://api.coindesk.com/v1/bpi/currentprice.json')
        data = response.json()


        # current date and time
        now = datetime.now()
        timestamp = datetime.timestamp(now)
        time = int(timestamp)


        ticker = "btcusd"
        Rate = data['bpi']['USD']['rate_float']
        output = { 
                "ticker": ticker,
                "current_price": Rate,
                "timestamp": time        
        }      

        print(json.dumps(output,indent=4))