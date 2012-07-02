require 'spec_helper'

describe Quickbase::Connection do
  before do
    @connection_name = 'test_connection'
    @client_params = {"client" => {"username" => "test", "password" => "password"}}
    @config = {:test => {@connection_name => @client_params}}
    Quickbase::Connection.any_instance.stub(:read_config) { @config }
    @connection = Quickbase::Connection.new(@connection_name)
    @connection.connect
  end
  
  it "should load configuration for the specific connection name" do
    @connection.config.should == @client_params
  end

  it "should pass missing methods on to the client" do
    @connection.client.should_receive(:test_method)
    @connection.test_method
  end
end