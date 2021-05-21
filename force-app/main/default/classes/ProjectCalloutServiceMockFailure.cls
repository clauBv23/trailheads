@isTest

global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here 
   global HTTPResponse respond(HTTPRequest request) {
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json');
      response.setBody('Error');
      response.setStatusCode(500);
      return response; 
  }
}