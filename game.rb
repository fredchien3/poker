require_relative 'player.rb'

class Game
    def initialize
        @players = Array.new
        @players << Player.new("ford", self)
        @players << Player.new("alio", self)
        @players << Player.new("jorsten", self)
        @players << Player.new("dorwen", self)
        @current_player = @players.first
        @pot = 0
        @ante = 10 # the default minimum bet
        @deck = Deck.new
    end

    def play

    end

    def round
        @players.each { |player| player.place_bet(@ante) } # mandatory bet
        self.deal 5
    end

    def deal(n) # deals n cards to all players' hands
        raise "not enough cards!" if self.count_deck < (4*n)
        n.times do
            @players.each { |player| @deck.deal_to(player) }
        end
        # self.show_all_hands
        true
    end

    def show_all_hands
        @players.each { |player| player.show_hand }
        true
    end

    def show_deck # for debug
        @deck.deck_array.each do |card|
            card.render
            print " "
        end
        true
    end

    def count_deck
        @deck.count
    end


end