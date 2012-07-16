class Fixnum
  def attempts time = 0
    self.times do |x|
      begin
        return yield
      rescue Exception => e
        if (x + 1) == self
          raise e
        end
        sleep(time)
      end
    end
  end
end