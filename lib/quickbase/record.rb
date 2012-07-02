module Quickbase
  module Record
    def self.included(base)
      base.extend(ClassMethods)
      base.extend(Quickbase::Storable)
      base.extend(Quickbase::Queryable)
      base.extend(Quickbase::Selectable)
    end
    
    module ClassMethods
      def connection(name=nil)
        if (name)
          @connection_name = name
        else
          @connection ||= begin
            con = Quickbase::Connection.new(connection_name)
            con.connect
            con
          end
        end
      end

      def database(id)
        if (id.kind_of?(Hash))
          @database = id
        else
          raise "Invalid database id format. Use the syntax   database 'DBID_dev' => 'DBID_prod'"
        end
      end

      def field(name, field_id)
        @fields ||= {}
        @fields[name.to_sym] = field_id
        self.send(:attr_accessor, name)
      end

      def connection_name
        @connection_name || "default"
      end

      def fields
        @fields_for_environment ||= begin
          @fields.keys.inject({}) do |memo, name|
            memo[name] = field_id(name)
            memo
          end
        end
      end
      
      def database_id
        value_for_environment @database
      end

      def field_id(name)
        value_for_environment @fields[name]
      end

      private

      def value_for_environment(ids)
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

    def database_id
      self.class.database_id
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