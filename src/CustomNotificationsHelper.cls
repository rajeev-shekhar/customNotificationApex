//Author: Rajeev Shekhar
//Description: Helper class to publish custom notifications

/*
   JSON Payload expected structure 
   {
   "inputs":[
      {
         "title":"Exception",
         "targetId":"0MI1X0000004UVeWAM",
         "senderId":null,
         "recipientIds":[
            "0051v000006iGCaAAM"
         ],
         "customNotifTypeId":"0ML1X0000004EmMWAU",
         "body":"The job failed to process Visit data for this territory"
      },
      {
         "title":"Exception",
         "targetId":"0MI1X0000004UeCWAU",
         "senderId":null,
         "recipientIds":[
            "0051v000006iGCaAAM"
         ],
         "customNotifTypeId":"0ML1X0000004EmMWAU",
         "body":"The job failed to process Visit data for this territory"
      }
    ]
   }
    */

public class CustomNotificationsHelper {
    
    //Method to publish Custom Notifications
    public static customNotificationJSON.cls_inputs createCustomNotificationsPayload(String cId, String title, String body, String targetId, String[] rId) {
        customNotificationJSON.cls_inputs i = new customNotificationJSON.cls_inputs();
        if(cId != null) {
            i.customNotifTypeId = cId;
            i.title = title;
            i.body = body;
            i.targetId = targetId;
            i.recipientIds = rId;
        }
       return i; 
    }
    
    //Method to query Custom Notification type Id
    public static String queryCustomNotificationType(String name) {
        String Id = null;
        try{
            CustomNotificationType type = [SELECT Id, CustomNotifTypeName, DeveloperName FROM CustomNotificationType WHERE DeveloperName = :name];
            Id = type.Id;
        }    
        catch(System.QueryException e) {
            System.debug('Exception occured: ' + e);
        }
       return Id; 
    }
    
    //Method to publish notifications
    public static void publishCustomNotifications(String payload, String type) {
        Switch on type {
            When 'future' {
                publishCustomNotificationsFuture(payload);
            }
            When 'now' {
                makeCallout(payload);
            }
            When else {
            
            }
        }  
    }
    
    //Future method for callout
    @future(callout=true)
    private static void publishCustomNotificationsFuture(String payload) {
        makeCallout(payload);
    }
    
    //Method to make callout
    private static void makeCallout(String payload) {
        String endpoint = URL.getSalesforceBaseURL().toExternalForm() + '/services/data/v47.0/actions/standard/customNotificationAction';
        System.debug('payload: ' +payload);
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Authorization','Bearer ' + Userinfo.getSessionId());
        req.setHeader('Content-Type','application/json');
        req.setEndpoint(endpoint);
        req.setBody(payload);        
        Http http = new Http();
        if(Test.IsRunningTest() == false) HTTPResponse res = http.send(req);
    }
}