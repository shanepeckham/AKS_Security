### RUN pip install -r requirements.txt /Python3

## This script grant OAuth2 permissions to an AAD native app. Used by kubectl
## users to authenticate via AAD for RBAC integration with AAD and AKS

import json
import requests

TOKEN=''
SERVER_APP_ID='' # Must be populated manually - The AppId or ClientId of your server app for AD integration
SERVER_SECRET='' # Must be populated manually - The password or ClientSecret of your server app
TENANT_ID='' # Must be populated manually - Your AD tenant id
CLIENT_APP_SPN='' # Populated automatically

# Let's go and get a token
TOKEN = 'Bearer ' + getToken()

# Now we need to get the Service Principal for the native app
CLIENT_APP_SPN = getSPN(CLIENT_APP_ID)

# Now we need to get the Service Principal ObjectIds so that we can grant OAuth2 permissions
grantOAuth2Permissions()

print("All Done")

def getToken():

    # Get Token parameters

    access_token=''

    headers = dict()
    headers['Content-Type'] = 'application/x-www-form-urlencoded'

    payload= {'grant_type': 'client_credentials', 'client_id': SERVER_APP_ID, 'resource': 'https://graph.windows.net', 'client_secret': SERVER_SECRET}

    # Use the requests library to make the POST call
    response = requests.request('post',
                                'https://login.microsoftonline.com/'+TENANT_ID+'/oauth2/token',
                                data=payload)

    if response.status_code != 200 and response.status_code != 201:
        print("Error code: %d" % (response.status_code))
        print("Message: %s" % (response.json()))

    print(response.status_code, response.reason, " Got Token")

    jbody = response.json()

    access_token= jbody['access_token']
    return access_token

def grantOAuth2Permissions():

    headers = {
        "Authorization": TOKEN,
        "Content-Type": "application/json"
    }

    appids = ['00000002-0000-0000-c000-000000000000', SERVER_APP_ID]

    for _, val in enumerate(appids):
        # Get the SPN ObjectId

        # Use the requests library to make the POST call
        response = requests.request('get',
                                    'https://graph.windows.net/myorganization/servicePrincipals?api-version=1.6&$filter=appId+eq' + "'" + val + "'",
                                    headers=headers)

        if response.status_code != 200 and response.status_code != 201:
            print("Error code: %d" % (response.status_code))
            print("Message: %s" % (response.json()))

        print(response.status_code, response.reason, ' Queried Service Principals')

        jbody = response.json()
        spn = jbody['value'][0]['objectId']

# Now we grant the permissions

        if val == '00000002-0000-0000-c000-000000000000': # This is AD Read
            scope = 'User.Read'
        else:
            scope = "user_impersonation"

        payload = {
        "odata.type": "Microsoft.DirectoryServices.OAuth2PermissionGrant",
        "clientId": CLIENT_APP_SPN,
        "consentType": "AllPrincipals",
        #"principalId": "",
        "resourceId": spn,
        "scope": scope,
        "startTime": "0001-01-01T00:00:00",
        "expiryTime": "9000-01-01T00:00:00"
        }

        data_json = json.dumps(payload)

        response = requests.request('post',
                                    'https://graph.windows.net/myorganization/oauth2PermissionGrants?api-version=1.6',
                                    headers=headers, data=data_json)

        if response.status_code != 200 and response.status_code != 201:
            print("Error code: %d" % (response.status_code))
            print("Message: %s" % (response.json()))

        print(response.status_code, response.reason, ' Granted permissions ')

def getSPN(clientId):

    headers = {
        "Authorization": TOKEN,
        "Content-Type": "application/json"
    }

    # Use the requests library to make the POST call
    response = requests.request('get',
                                'https://graph.windows.net/myorganization/servicePrincipals?api-version=1.6&$filter=appId+eq' + "'" + val + "'",
                                headers=headers)

    if response.status_code != 200 and response.status_code != 201:
        print("Error code: %d" % (response.status_code))
        print("Message: %s" % (response.json()))

    print(response.status_code, response.reason, ' Queried Native App Service Principal')

    jbody = response.json()
    spn = jbody['value'][0]['objectId']

    return spn