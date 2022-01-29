require_relative 'card.rb'

class Deck
    SUITS = %i(spade heart club diamond)

    attr_accessor :deck_array

    def initialize
        @deck_array = Array.new
        (1..13).each do |importance|
            SUITS.each do |suit|
                @deck_array << Card.new(importance, suit)
            end
        end
        @deck_array.shuffle!
    end

    def display
        @deck_array.each do |card|
            card.render
            puts " "
        end
        true
    end

    def deal_to(player)
        player.hand_array << @deck_array.pop
    end

    def count
        @deck_array.length
    end

    def shuffle!
        @deck_array.shuffle!
    end

end