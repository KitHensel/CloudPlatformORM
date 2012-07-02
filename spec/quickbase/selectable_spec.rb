require 'spec_helper'

class BasicTestModelSelectable
  include Quickbase::Record

  field :name, 1 => 2
  field :date, 3
end

describe Quickbase::Selectable do
    before do
        @client_params = {"username" => "test", "password" => "password"}
        @config = {:test => {"default" => @client_params}}
        Quickbase::Connection.any_instance.stub(:read_config) { @config }
    end

    describe :build_query do
        it "should format the string correctly for the QB API" do
            query = BasicTestModelSelectable.where(:name => "test")
            query = query.where(:date => 5)
            query.send(:build_query).should == "{1.EX.'test'}AND{3.EX.'5'}"
        end
    end
end