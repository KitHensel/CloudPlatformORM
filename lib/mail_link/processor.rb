module MailLink
  module Processor
  
    attr_reader :message

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < MailLink::Processor }
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize(message)
      @message = message
    end

    def process
      raise "'process' method not implemented"
    end

    module ClassMethods
      @queue = :mail_monkey2

      def username(email=nil)
        @email = email if email
        @email
      end

      def password(password=nil)
        @password = password if password
        @password
      end

      def self.perform
        mailbox = Mailbox.new(username, password)
        mailbox.each_unread_message do |message|
          self.new(message).process
        end
      end
    end
  end
end