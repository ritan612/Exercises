@isTest
public class CompanyInfoMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        
        String jsonBody = '{' +
            '"totalSize": 1,' +
            '"done": true,' +
            '"records": [' +
                '{' +
                    '"attributes": {' +
                        '"type": "Account",' +
                        '"url": "/services/data/v54.0/sobjects/Account/001WU000024v9HlYAI"' +
                    '},' +
                    '"logoUrl__c": "https://logos-marques.com/wp-content/uploads/2021/03/Nouveau-logo-Google-500x313.png",' +
                    '"NumberOfEmployees": 156500,' +
                    '"Foundation_date__c": "1998-09-04",' +
                    '"BillingAddress": {' +
                        '"city": "Mountain View",' +
                        '"country": "United States",' +
                        '"geocodeAccuracy": null,' +
                        '"latitude": null,' +
                        '"longitude": null,' +
                        '"postalCode": "94043",' +
                        '"state": "CA",' +
                        '"street": "1600 Amphitheatre Parkway"' +
                    '},' +
                    '"Description": "This is a default description."' +
                '}' +
            ']' +
        '}';
        
        res.setBody(jsonBody);
        return res;
    }
}