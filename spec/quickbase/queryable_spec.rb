require 'spec_helper'

class BasicTestModelQueryable
  include Quickbase::Record

  field :name, 1 => 2
end

describe Quickbase::Queryable do
    before do
        @config = {:test => {"default" => {"username" => "test", "password" => "password"}}}
        Quickbase::Connection.any_instance.stub(:read_config) { @config }
    end

    describe :query do
        it "should send a doQuery request to the connection's client" do
            BasicTestModelQueryable.connection.client.should_receive(:doQuery) { [] }
            BasicTestModelQueryable.where(:name => "steve").to_a
        end
    end
end