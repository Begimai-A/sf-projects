@isTest
private class WeatherControllerTest {
    @isTest
    static void testWeatherController() {
        Account acc = new Account(Name='Test Account', BillingCity='Ankara');
        insert acc;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new WeatherHttpMock());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        WeatherController controller = new WeatherController(sc);
        String temperature = controller.temperature;
        String description = controller.description;
        String iconUrl = controller.iconUrl;
        
        Test.stopTest();
        
        System.assertEquals('20.84 °C', temperature);
        System.assertEquals('few clouds', description);
        System.assertEquals('https://openweathermap.org/img/w/02d.png', iconUrl);        
    }
    
    @isTest
    static void testWeatherControllerElse() {
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WeatherHttpMock());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        WeatherController controller = new WeatherController(sc);
        String temperature = controller.temperature;
        String description = controller.description;
        String iconUrl = controller.iconUrl;
        
        Test.stopTest();
        
        System.assertEquals('No weather information available', temperature);
        System.assertEquals('Billing city is not available', description);
        
    }
    
}



//System.assertNotEquals('Billing city is not available', weatherController.description);
//  System.assertNotEquals('No weather information available', weatherController.temperature);
// System.assertNotEquals(null, weatherController.iconUrl);
// 
/*acc.BillingCity = 'New York';
update acc;

Test.startTest();
Test.setMock(HttpCalloutMock.class, new WeatherHttpMock());

sc = new ApexPages.StandardController(acc);
controller = new WeatherController(sc);
temperature = controller.temperature;
description = controller.description;
iconUrl = controller.iconUrl;

Test.stopTest();

System.assertEquals('21.84 °C', temperature);
System.assertEquals('few clouds', description);
System.assertEquals('https://openweathermap.org/img/w/02d.png', iconUrl);*/