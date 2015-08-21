@isTest
public class TestJSONSample {
    public static String s = '[' +
    '{"id": "0001","type": "donut","name": "Cake","ppu": 0.55,"batters":' + 
    '{"batter":[{ "id": "1001", "type": "Regular" },{ "id": "1002", "type": "Chocolate" },{ "id": "1003", "type": "Blueberry" },' + 
    '{ "id": "1004", "type": "Devils Food" }]},"topping":[' + 
    '{ "id": "5001", "type": "None" },{ "id": "5002", "type": "Glazed" },{ "id": "5005", "type": "Sugar" },{ "id": "5007", "type": "Powdered Sugar" },' +
    '{ "id": "5006", "type": "Chocolate with Sprinkles" },{ "id": "5003", "type": "Chocolate" },{ "id": "5004", "type": "Maple" }' + 
    ']},{"id": "0002","type": "donut","name": "Raised","ppu": 0.55,"batters":{"batter":[{ "id": "1001", "type": "Regular" }' + 
    ']},"topping":[{ "id": "5001", "type": "None" },{ "id": "5002", "type": "Glazed" },{ "id": "5005", "type": "Sugar" },' +
    '{ "id": "5003", "type": "Chocolate" },{ "id": "5004", "type": "Maple" }]}, {' +
    '"id": "0003","type": "donut","name": "Old Fashioned","ppu": 0.55,"batters":{"batter":[' +
    '{ "id": "1001", "type": "Regular" },{ "id": "1002", "type": "Chocolate" }]},"topping":' +
    '[{ "id": "5001", "type": "None" },{ "id": "5002", "type": "Glazed" },{ "id": "5003", "type": "Chocolate" },' + 
    '{ "id": "5004", "type": "Maple" }]}]';
    
    public static String s2 = '[{"color": "red","value": "f00"},{"color": "green","value": "0f0"},' +
    '{"color": "blue","value": "00f"},{"color": "cyan","value": "0ff"},{"color": "magenta","value": "f0f"},' +
    '{"color": "yellow","value": "ff0"},{"color": "black","value": "000"}]';
    
    
    public static String s3 = '{"id": "0001","type": "donut","name": "Cake","ppu": 0.55,"batters":{' + 
    '"batter":[{ "id": "1001", "type": "Regular" },{ "id": "1002", "type": "Chocolate" },{ "id": "1003", "type": "Blueberry" },' +
    '{ "id": "1004", "type": "Devils Food" }]},"topping":[{ "id": "5001", "type": "None" },{ "id": "5002", "type": "Glazed" },' + 
    '{ "id": "5005", "type": "Sugar" },{ "id": "5007", "type": "Powdered Sugar" },{ "id": "5006", "type": "Chocolate with Sprinkles" },' + 
    '{ "id": "5003", "type": "Chocolate" },{ "id": "5004", "type": "Maple" }]}';
    
    public static String s4 = 'true';
    
    static TestMethod void testone() {
        EasyJSON e = new EasyJSON (TestJSONSample.s);
        
        System.assertEquals(e.debugandlog(), true);
        System.assertEquals(e.getDetails().length(), 6182);
    }
    
    static TestMethod void testtwo() {
        EasyJSON e = new EasyJSON (TestJSONSample.s2);
        
        System.assertEquals(e.debugandlog(), true);
    }
    
    static TestMethod void testthree() {
        EasyJSON e = new EasyJSON (TestJSONSample.s3);
        
        System.assertEquals(e.debugandlog(), true);
    }        
    
    static TestMethod void testfour() {
        EasyJSON e = new EasyJSON (TestJSONSample.s4);
        
        System.assertEquals(e.debugandlog(), true);
    } 
}
