class Deck
  attr_reader :card
    
  SUIT = ["\u2665".encode('utf-8'), "\u2663".encode('utf-8'), "\u2666".encode('utf-8'), "\u2660".encode('utf-8')]
  RANK = [:Ace, "King", "Queen", "Jack", 10, 9, 8, 7, 6, 5, 4, 3, 2]

  def create_card
    @card = {SUIT.sample => RANK.sample}
  end
end


