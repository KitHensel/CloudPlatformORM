require 'spec_helper'

class BasicTestModelStorage
  include Quickbase::Record

  field :id, 3
  field :name, 1 => 2
  field :date, 4
end

describe Quickbase::Storable do
  before do
    Quickbase.stub(:connections) { {"default" => {"username" => "test", "password" => "password"} } } 

    @name = "model_name"
    @date = Time.now
    @model = BasicTestModelStorage.new(:name => @name, :date => @date)

    BasicTestModelStorage.connection.client.stubs(:importFromCSV)
  end

  describe "as csv" do
    it "should produce a period separated CSV header" do
      @model.class.send(:build_csv_header, [:name, :date]).should == "1.4"
    end

    it "should produce a csv row from a record" do
      @model.class.send(:build_csv_row, @model, [:name, :date]).should == [@name, @date]
    end
  end

  describe "save_all" do
    it "should raise an exception if database_id is not specified" do
      lambda { BasicTestModel.save_all([]) }.should raise_error
    end
    
    it "should not raise an exception if database_id is specified" do
      BasicTestModelStorage.send(:database, {"1ab" => "1ab"})
      BasicTestModelStorage.connection.client.stub(:importFromCSV) { [0,0,0,[1],0] }

      lambda { BasicTestModelStorage.save_all([@model]) }.should_not raise_error
    end
  end
end