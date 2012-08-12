require 'spec_helper'

describe QuickbaseMapper::Value do
  before do
      QuickbaseMapper.stub(:connections) { {"default" => {"username" => "test", "password" => "password"} } } 
  end

  describe :format_value do
    it "should turn Date objects into milliseconds since epoch" do
      date = Date.today
      qb_date = (date.to_time.to_f * 1000).to_i.to_s
      formatted = QuickbaseMapper::Value.new(date).send :format_value
      formatted.should == qb_date
    end

    it "should turn Time objects into milliseconds since epoch" do
      time = Time.now
      qb_time = (time.to_f * 1000).to_i.to_s
      formatted = QuickbaseMapper::Value.new(time).send :format_value
      formatted.should == qb_time
    end

    it "should not alter String objects" do
      s = "abc"
      formatted = QuickbaseMapper::Value.new(s).send :format_value
      formatted.should == s
    end
  end

end