//Class to create CustomNotification JSON payload
public class customNotificationJSON{
    public cls_inputs[] inputs;
    public class cls_inputs {
        public String customNotifTypeId;
        public String[] recipientIds;
        public String title;
        public String body;
        public String targetId; 
        public String senderId; 
    }
}