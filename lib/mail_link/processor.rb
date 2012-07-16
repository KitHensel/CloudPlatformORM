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
      def username(email=nil)
        @email = email if email
        @email
      end

      def password(password=nil)
        @password = password if password
        @password
      end

      def run
        mailbox = Mailbox.new(username, password)
        mailbox.each_unread_message do |message|
          self.new(message).process
        end
      end
    end
  end
end