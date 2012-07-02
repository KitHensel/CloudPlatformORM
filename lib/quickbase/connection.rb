module Quickbase
  class Connection
    attr_reader :connection_name, :config, :client
    
    def initialize(connection_name)
      @connection_name = connection_name
    end
    
    def connect
      @config = configure
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

    def configure
      config = HashWithIndifferentAccess.new read_config
      config[quickbase_environment][connection_name]
    end

    def read_config
      YAML.load_file(File.join(Rails.root, "config", "quickbase.yml"))
    end
    
    def method_missing(method, *args, &block)
      @client.send(method, *args, &block)
    end
  end
end