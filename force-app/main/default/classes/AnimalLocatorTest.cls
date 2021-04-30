@isTest
private class AnimalLocatorTest {
    @isTest 
    static  void testGetCallout() {

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 

        String result = AnimalLocator.getAnimalNameById(1);
        
        // Verify the right answer
        System.assertEquals('chicken', result,
        'The should be the chicken animal.');   
    }   
}
