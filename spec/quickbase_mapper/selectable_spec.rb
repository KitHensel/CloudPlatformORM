require 'spec_helper'

class BasicTestModelSelectable
  include QuickbaseMapper::Record

  field :name, 1 => 2
  field :date, 3
end

describe QuickbaseMapper::Selectable do
    before do
        QuickbaseMapper.stub(:connections) { {"default" => {"username" => "test", "password" => "password"} } } 
    end

    describe :build_query do
        it "should format the string correctly for the QB API" do
            query = BasicTestModelSelectable.where(:name => "test")
            query = query.where(:date => 5)
            query.send(:build_query).should == "{1.EX.'test'}AND{3.EX.'5'}"
        end
    end
end