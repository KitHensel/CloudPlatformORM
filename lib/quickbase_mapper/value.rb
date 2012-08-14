module QuickbaseMapper
  class Value

    def initialize(value)
      @original_value = value
    end

    def ==(other)
      if (other.kind_of?(Value))
        value == other.value
      else
        value == other
      end
    end

    def <=>(other)
      value <=> other.value
    end

    def value
      @value ||= format_value
    end

    def to_s
      value.to_s
    end

    private

    def format_value
      if (@original_value.kind_of? String)
        if @original_value.methods.include?(:to_i) && (@original_value.to_i.to_s == @original_value)
          @original_value.to_i 
        else
          @original_value
        end
      elsif ([Date,Time].include? @original_value.class)
        (@original_value.to_time.to_f * 1000).to_i.to_s
      else
        @original_value
      end

    end
  end
end
