module Quickbase
  class Connection
    attr_reader :connection_name, :config, :client
    
    def initialize(connection_name)
      @connection_name = connection_name
    end
    
    def connect
      @config = Quickbase.connections[connection_name]
      @client = QuickBase::Client.init(
          "username" => @config["username"], 
          "password" => @config["password"], 
          "org" => @config["domain"], 
          "stopOnError" => true)
    end

    private

    def quickbase_environment
      # stub this out for rspecs
      Rails.env
    end
    
    def method_missing(method, *args, &block)
      @client.send(method, *args, &block)
    end
  end
end