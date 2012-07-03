require 'spec_helper'

describe QuickbaseMapper::Connection do
  before do
    @connection_name = 'test_connection'
    @client_params = {"username" => "test", "password" => "password"}
    QuickbaseMapper.stub(:connections) { {"test_connection" => @client_params} }
    @connection = QuickbaseMapper::Connection.new(@connection_name)
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