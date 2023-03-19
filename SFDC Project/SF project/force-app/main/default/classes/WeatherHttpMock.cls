global class WeatherHttpMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"weather":[{"description":"few clouds","icon":"02d"}],"main":{"temp":293.99}}');
        res.setStatusCode(200);
        return res;
    }
}