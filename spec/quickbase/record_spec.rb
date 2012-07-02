require 'spec_helper'

class BasicTestModelRecord
  include Quickbase::Record
end

describe Quickbase::Record do
  before do
    Quickbase.stub(:connections) { {"default" => {"username" => "test", "password" => "password"} } } 
    @model = BasicTestModelRecord.clone.new
  end

  describe "fields for environment" do
    before do
      @model.class.send(:field, :name, {9 => 10})
      @model.class.send(:field, :test, {10 => 11})
    end

    it "should return the correct name -> value map for the environment" do
      @model.send(:fields_for_environment).should == {:name => 9, :test => 10}
    end

    it "should return the correct name -> value map for the production environment" do
      @model.connection.stub(:quickbase_environment) { ActiveSupport::StringInquirer.new("production") }
      @model.send(:fields_for_environment).should == {:name => 10, :test => 11}
    end
  end

  describe "looking up a field name from its id" do
    before do
      @model.class.send(:field, :name, {9 => 10})
      @model.class.send(:field, :test, {10 => 11})
    end

    it "should return 'test' for field id 10 in development" do
      @model.send(:field_name, 10).should == :test
    end

    it "should return 'name' for field id 10 in production" do
      @model.connection.stub(:quickbase_environment) { ActiveSupport::StringInquirer.new("production") }
      @model.send(:field_name, 10).should == :name
    end
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

    describe "table id" do
      describe "in the correct format" do
        before do
          @model.class.send(:database, {"abcd" => "efgh"})
        end

        it "should return abcd for non production" do
          @model.database_id.should == "abcd"
        end

        it "should return efgh for production" do
        end

      end

      it "should raise an error if the table id is not in the dev => prod format" do
        lambda { @model.class.send(:database, "abcd") }.should raise_error
      end
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