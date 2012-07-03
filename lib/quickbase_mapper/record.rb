module QuickbaseMapper::Record
  def self.included(base)
    base.extend(ClassMethods)
    base.extend(QuickbaseMapper::Storable::ClassMethods)
    base.extend(QuickbaseMapper::Queryable::ClassMethods)
    base.extend(QuickbaseMapper::Selectable::ClassMethods)

    base.instance_eval do
      include QuickbaseMapper::Storable
    end
  end
  
  module ClassMethods
    def connection(name=nil)
      if (name)
        @connection_name = name
      else
        @connection ||= begin
          con = QuickbaseMapper::Connection.new(connection_name)
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

    def field_name(id)
      fields_for_environment.each {|key, value| 
        return key if value == id
      }
      nil
    end

    def fields_for_environment
      @fields.inject({}) do |memo, name_value|
        name, value = name_value
        memo[name] = value_for_environment(value)
        memo
      end
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

  def attributes
    fields.keys.inject({}) do |memo, field_name|
      memo[field_name] = self.send(field_name)
      memo
    end
  end

  def attributes_by_id
    fields.inject({}) do |memo, name_id|
      name, id = name_id
      memo[id] = self.send(name)
      memo
    end
  end

  def database_id
    self.class.database_id
  end
 
  def fields
    self.class.fields
  end

  def fields_for_environment
    self.class.fields_for_environment
  end

  def field_name(id)
    self.class.field_name(id)
  end

  def field_id(name)
    self.class.field_id(name)
  end

  def connection
    self.class.connection
  end
end