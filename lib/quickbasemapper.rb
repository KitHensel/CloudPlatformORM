module QuickbaseMapper
    class << self
        def add_connection(name, params)
            connections[name] = params
        end

        def connections
            @connections ||= HashWithIndifferentAccess.new()
        end
    end
end

require 'QuickBaseClient'
require 'quickbase_mapper/connection'
require 'quickbase_mapper/storable'
require 'quickbase_mapper/queryable'
require 'quickbase_mapper/selectable'
require 'quickbase_mapper/record'
