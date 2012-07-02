module Quickbase
  module Record
    def self.included(base)
      base.extend(ClassMethods)
      base.extend(Quickbase::Storage)
      base.extend(Quickbase::Storage::ClassMethods)
    end
    
    module ClassMethods
      def connection
        @connection ||= begin
          con = Quickbase::Connection.new(connection_name)
          con.connect
          con
        end
      end

      def connection_name
        @connection_name || "default"
      end

      def field(name, field_id)
        @fields ||= {}
        @fields[name.to_sym] = field_id
        self.send(:attr_accessor, name)
      end

      def fields
        @fields_for_environment ||= begin
          @fields.keys.inject({}) do |memo, name|
            memo[name] = field_id(name)
            memo
          end
        end
      end
      
      def field_id(name)
        ids = @fields[name]
        if (ids.kind_of?(Fixnum))
          ids
        elsif (ids.kind_of?(Hash))
          if (connection.send(:quickbase_environment).production?)
            ids.values.first
          else
            ids.keys.first
          end
        end
      end
    end
   
    def initialize(attributes={})
      attributes.each do |key, value|
        self.send("#{key}=", value)
      end
    end
   
    def fields
      self.class.fields
    end

    def field_id(name)
      self.class.field_id(name)
    end

    def connection
      self.class.connection
    end
  end
end