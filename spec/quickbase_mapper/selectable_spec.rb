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

  describe :select do
    it "should convert the field names into ids and pass them to build_query" do
      query = BasicTestModelSelectable.select(:name)
      BasicTestModelSelectable.should_receive(:query).with('', [1])
      query.to_a
    end
  end

  describe :build_query do
    it "should format the string correctly for the QB API" do
      query = BasicTestModelSelectable.where(:name => "test")
      query = query.where(:date => 5)
      query.send(:build_query).should == "{1.EX.'test'}AND{3.EX.'5'}"
    end

    it "should turn date values into milliseconds since epoch" do
      time = Time.now
      qb_time = (time.to_f*1000).to_i
      query = BasicTestModelSelectable.where(:date => Time.now)
      query.send(:build_query).should == "{3.EX.'#{qb_time}'}"
    end
  end

  describe :count do
    it "should pass the query parameters to the model count function" do
      BasicTestModelSelectable.should_receive(:count).with("{1.EX.'1'}")
      BasicTestModelSelectable.where(:name => 1).count
    end
  end
end
