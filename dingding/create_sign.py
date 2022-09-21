import time 
import requests
import json
import time
import hmac
import hashlib
import base64
import urllib


current_milli_time = lambda: int(round(time.time() * 1000))
timestamp=current_milli_time()
print(timestamp)

secret = 'SEC88b9d106924a9591aca470841f0342e4669a8cf1dd2532478a85898854ef7fd3'
secret_enc = secret.encode('utf-8')
string_to_sign = '{}\n{}'.format(timestamp, secret)
string_to_sign_enc = string_to_sign.encode('utf-8')
hmac_code = hmac.new(secret_enc, string_to_sign_enc, digestmod=hashlib.sha256).digest()
sign = urllib.quote_plus(base64.b64encode(hmac_code))
print(sign)
