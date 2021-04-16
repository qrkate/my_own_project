require_relative "bank.rb"
require_relative "validation.rb"

class Players
  include Bank
  include Validation
  
  NAME = /^[A-ZА-Я]{1}[a-zа-я]+$/
  
  attr_accessor :name, :cards, :score
  validate :name, :presence
  validate :name, :format, NAME
  
  def initialize(name = "Dealler")
    @name = name
    validate!
    @cards = []
    @score = 0
    self.bank = 100
  end
  
  def add_card(card)
    @cards.push(card)
  end
  
  def delete_cards
    @cards.clear
    @score = 0
  end
  
  def calculation_score
    @score = 0
    @cards.each do |card|
      case card.values.first
      when Integer
        @score += card.values.first
      when String
        @score += 10
      when Symbol
        if @score > 10
          @score += 1
        else
          @score += 11
        end
      end
    end
  end
  
  def each_cards
    @cards.each { |card| yield card } if block_given?
  end
end
