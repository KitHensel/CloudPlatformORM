module Quickbase
    class << self
        def add_connection(name, params)
            connections[name] = params
        end

        def connections
            @connections ||= HashWithIndifferentAccess.new()
        end
    end
end