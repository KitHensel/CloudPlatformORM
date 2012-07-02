require 'spec_helper'

describe Quickbase do
    describe "connections" do
        before do
            Quickbase.add_connection(:qb_test, :username => "test", :password => "test")
        end

        it "should have a connection named qb_test" do
            connection = Quickbase.connections['qb_test']
            connection.should_not be_nil
            connection[:username].should == "test"
            connection[:password].should == "test"
        end

        it "should have two connections if a second connection is added" do
            Quickbase.add_connection(:connection_2, :username => "test")
            Quickbase.connections.count.should == 2
        end
    end
end