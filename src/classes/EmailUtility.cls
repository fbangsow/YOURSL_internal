public with sharing class EmailUtility {
    private Messaging.SingleEmailMessage Mail;

    private EmailUtility(){
        Mail = new Messaging.SingleEmailMessage();
    }

    public static EmailUtility getInstance(){
        return new EmailUtility();
    }

    public EmailUtility setSendTo(String send_to){
        List<String> send_to_list = new List<String>();
        send_to_list.add(send_to);
        Mail.setToAddresses(send_to_list);
        return this;
    }

    public EmailUtility setCcTo(String cc_to){
        List<String> cc_to_list = new List<String>();
        cc_to_list.add(cc_to);
        Mail.setCcAddresses(cc_to_list);
        return this;
    }

    public EmailUtility setReplyTo(String reply_to){
        Mail.setReplyTo(reply_to);
        return this;
    }

    public EmailUtility setSenderDisplayName(String sender_name){
        Mail.setSenderDisplayName(sender_name);
        return this;
    }

    public EmailUtility setSubject(String subject){
        Mail.setSubject(subject);
        return this;
    }

    public EmailUtility setHtmlBody(String html_body){
        Mail.setHtmlBody(html_body);
        return this;
    }

    public void send(){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        mails.add(Mail);
        Messaging.sendEmail(mails);
    }
}