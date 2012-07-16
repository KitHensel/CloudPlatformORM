require 'rubygems'
require 'bundler/setup'

gem 'activesupport'

require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/string_inquirer'
require 'QuickBaseClient'
require 'csv'

require 'quickbasemapper' # and any other gems you need

class Rails
    def self.root
        Dir.pwd
    end

    def self.env
        ActiveSupport::StringInquirer.new("test")
    end
end

class String
    def escape_xml
        self
    end
end

RSpec.configure do |config|
  # some (optional) config here
end