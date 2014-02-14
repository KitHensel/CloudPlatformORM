module MailLink
  class Message
    attr_accessor :sent, :received, :subject, :text_body
    attr_accessor :to_recipients, :from, :cc_recipients 
    attr_accessor :html_body, :sender, :attachments
    
    def initialize(params={})
      params.each {|key,value| self.send("#{key}=", value) }
    end
    
    def message_text
      text = text_body if text_body != ""
      text ||= html_body if html_body != ""
      text ||= ""
      text
    end
  end
end