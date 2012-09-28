require 'spec_helper'

class BasicTestModelQueryable
  include QuickbaseMapper::Record

  field :name, 1 => 2
end

describe QuickbaseMapper::Queryable do
  before do
    QuickbaseMapper.stub(:connections) { {"default" => {"username" => "test", "password" => "password"} } } 
  end

  describe :query do
    it "should send a doQuery request to the connection's client" do
        BasicTestModelQueryable.connection.client.should_receive(:doQuery) { [] }
        BasicTestModelQueryable.where(:name => "steve").to_a
    end
  end

  describe :count do
    it "should pass parameters to getNumRecords if provided" do
      BasicTestModelQueryable.connection.should_receive(:getNumRecords).with(BasicTestModelQueryable.database_id)
      BasicTestModelQueryable.count
    end

    it "should not pass parameters to getNumRecords if not provided" do
      BasicTestModelQueryable.connection.should_receive(:doQueryCount).with(BasicTestModelQueryable.database_id, "{1.EX.'a'}")
      BasicTestModelQueryable.where(:name => "a").count
    end
  end
end

