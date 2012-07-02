require 'spec_helper'

class BasicTestModelRecord
  include Quickbase::Record
end

describe Quickbase::Record do
  before do
    @client_params = {"username" => "test", "password" => "password"}
    @config = {:test => {"default" => @client_params}}
    Quickbase::Connection.any_instance.stub(:read_config) { @config }
    @model = BasicTestModelRecord.clone.new
  end

  describe "when included in a model" do
    it "should have a field method for adding attribute metadata" do
      @model.class.methods.should include :field
    end

    it "should have a quickbase connection" do
      @model.connection.should be_kind_of Quickbase::Connection
      @model.connection.connection_name.should == "default"
    end
  end

  describe "supplied metadata" do
    before do
      @model.class.send(:field, :name, 9)
    end

    describe "numeric field id" do
      it "should return the supplied number" do
        @model.field_id(:name).should == 9
      end
    end
    
    describe "hashed field ids" do
      before do
        @model.class.send(:field, :name, 10 => 11)
      end
      
      it "should return the key if the environment is not production" do
        @model.field_id(:name).should == 10
      end
      
      it "should return the value if the environment is production" do
        @model.connection.stub(:quickbase_environment) { ActiveSupport::StringInquirer.new("production") }
        @model.field_id(:name).should == 11
      end
    end

    describe "fields" do
      before do
        @model.class.send(:field, :name, 1 => 2)
        @model.class.send(:field, :id, 3)
      end
      
      describe "development environment" do
        it "should return fields hashed for development" do
          @model.fields.should == {:name => 1, :id => 3}
        end
      end
      
      describe "production environment" do
        it "should return fields hashed for production" do
          @model.connection.stub(:quickbase_environment) { ActiveSupport::StringInquirer.new("production") }
          @model.fields.should == {:name => 2, :id => 3}
        end
      end
    end
  end
end