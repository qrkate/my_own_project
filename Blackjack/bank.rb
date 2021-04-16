module Bank
  attr_accessor :bank
  
  def take_money(sum)
    @bank += sum
  end
  
  def give_money(obj, sum)
    @bank -= sum
    obj.take_money(sum)
  end
end
