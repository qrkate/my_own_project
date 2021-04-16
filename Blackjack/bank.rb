module Bank
  attr_accessor :bank
  
  def take_money(sum)
    @bank += sum
  end
  
  def give_money(player, sum)
    @bank -= sum
    player.take_money(sum)
  end
end
