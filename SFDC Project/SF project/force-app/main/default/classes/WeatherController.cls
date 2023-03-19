public class WeatherController {
    private  Account account;
    public String temperature { get; private set; }
    public String description { get; private set; }
    public String iconUrl { get; private set; }
    
    public WeatherController(ApexPages.StandardController controller) {
        this.account = (Account)controller.getRecord();
        this.account = [SELECT Id, Name, BillingCity FROM Account WHERE Id = :account.Id];
        
        String city = account.BillingCity;
        if (city != null ) {
            String apiKey = '&appid=a50ba90381d00a995888746b5d948a1b';
            String url = 'https://api.openweathermap.org/data/2.5/weather?q=' + city + apiKey;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(url);
            request.setMethod('GET');
            
            HttpResponse response = http.send(request);
            System.debug(response.getBody());
            
            if (response.getStatusCode() == 200) {
                Map<String, Object> weatherInfo = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                Map<String, Object> mainInfo = (Map<String, Object>)weatherInfo.get('main');
                List<Object> weatherArray = (List<Object>)weatherInfo.get('weather');
                if (!weatherArray.isEmpty()) {
                    Map<String, Object> weather = (Map<String, Object>)weatherArray[0];
                    
                    Double temperatureInKelvin = (Double) mainInfo.get('temp');
                    Double temperatureInCelsius = temperatureInKelvin - 273.15;
                    mainInfo.put('temp', temperatureInCelsius); 
                    
                    this.temperature = Double.valueOf(mainInfo.get('temp')) + ' °C';
                    this.description = String.valueOf(weather.get('description'));
                    String iconCode = String.valueOf(weather.get('icon'));
                    this.iconUrl = 'https://openweathermap.org/img/w/' + iconCode + '.png';
                    System.debug('temp' + this.temperature);
                    System.debug('desc' + this.description);
                    System.debug('icon' + this.iconUrl);
                    
                }
            }
        }else {
            this.description = 'Billing city is not available';
            this.temperature = 'No weather information available';  
            this.iconUrl = null;
        }
    }
}