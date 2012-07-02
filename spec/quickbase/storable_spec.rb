require 'spec_helper'

class BasicTestModelStorage
  include Quickbase::Record

  field :name, 1 => 2
  field :date, 3
end

describe Quickbase::Storable do
  before do
    @client_params = {"username" => "test", "password" => "password"}
    @config = {:test => {"default" => @client_params}}
    Quickbase::Connection.any_instance.stub(:read_config) { @config }

    @name = "model_name"
    @date = Time.now
    @model = BasicTestModelStorage.new(:name => @name, :date => @date)

    BasicTestModelStorage.connection.client.stubs(:importFromCSV)
  end

  describe "as csv" do
    it "should produce a period separated CSV header" do
      @model.class.send(:build_csv_header, [:name, :date]).should == "1.3"
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
      lambda { BasicTestModelStorage.save_all([@model]) }.should_not raise_error
    end
  end
end