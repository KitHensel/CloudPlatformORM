require 'spec_helper'

describe QuickbaseMapper do
    describe "connections" do
        before do
            QuickbaseMapper.add_connection(:qb_test, :username => "test", :password => "test")
        end

        it "should have a connection named qb_test" do
            connection = QuickbaseMapper.connections['qb_test']
            connection.should_not be_nil
            connection[:username].should == "test"
            connection[:password].should == "test"
        end

        it "should have two connections if a second connection is added" do
            QuickbaseMapper.add_connection(:connection_2, :username => "test")
            QuickbaseMapper.connections.count.should == 2
        end
    end
end