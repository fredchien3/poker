require_relative 'hand.rb'

class Player
    attr_reader :name, :wallet, :hand
    attr_writer :hand
    

    def initialize(name, game)
        @name = name
        @wallet = 100
        @game = game
        @hand = Hand.new
    end

    def place_bet(amount)
        raise "Not enough money to place bet" if amount > @wallet
        @wallet -= amount
        @game.pot += amount
    end

    def discard? # 
    end

    def hand_array
        @hand.hand_array
    end

    def show_hand
        print @name
        print ": "
        @hand.hand_array.each do |card|
            card.render
            print " "
        end
        puts
    end

end