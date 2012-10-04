require 'spec_helper'

describe QuickbaseMapper::Value do
  before do
      QuickbaseMapper.stub(:connections) { {"default" => {"username" => "test", "password" => "password"} } } 
  end

  describe :blank? do
    it "should return true if the underlying value is blank" do
      QuickbaseMapper::Value.new("").blank?.should be_true
      QuickbaseMapper::Value.new(nil).blank?.should be_true
    end

    it "should return false if the underlying value is not blank" do
      QuickbaseMapper::Value.new("value").blank?.should be_false
    end
  end

  describe :equality do
    it "should be equal to the same type of object if the internal values match" do
      v1 = QuickbaseMapper::Value.new("string")
      v2 = QuickbaseMapper::Value.new("string")
      v1.should == v2
    end

    it "should by not be equal to the same type of object if the internal values do not match" do
      v1 = QuickbaseMapper::Value.new("string")
      v2 = QuickbaseMapper::Value.new("string2")
      v1.should_not == v2
    end

    it "should be equal to other types of objects if the internal value is equal to the other object" do
      v1 = QuickbaseMapper::Value.new("string")
      v1.should == "string"
      v1.should_not == 5
    end

    it "should handle group bys properly" do
      Struct.new("ValueTest", :value)
      a = [
        Struct::ValueTest.new(QuickbaseMapper::Value.new("a")),
        Struct::ValueTest.new(QuickbaseMapper::Value.new("a"))
      ]

      a.group_by(&:value).keys.count.should == 1
    end
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

    it "should turn string floats into floats" do
      formatted = QuickbaseMapper::Value.new("1.000").send :format_value
      formatted.should be_kind_of Float
    end

    it "should not alter String objects" do
      s = "abc"
      formatted = QuickbaseMapper::Value.new(s).send :format_value
      formatted.should == s
    end

    it "should ensure equality when converting back and forth to integers" do
      s = "0000"
      formatted = QuickbaseMapper::Value.new(s).send :format_value
      formatted.should == s

      s = "0"
      formatted = QuickbaseMapper::Value.new(s).send :format_value
      formatted.should == 0
    end

  end

end