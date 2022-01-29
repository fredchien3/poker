require_relative 'player.rb'

class Game
    attr_accessor :pot, :discard_pile, :last_bet

    def initialize
        @players = Array.new
        @players << Player.new("ford", self)
        @players << Player.new("alio", self)
        @players << Player.new("jorsten", self)
        @players << Player.new("dorwen", self)
        @pot = 0
        @ante = 10 # the default minimum bet
        @last_bet = @ante
        @deck = Deck.new
        @discard_pile = Array.new
    end

    def play
        while @players.length > 1
            self.play_round
            @players.reject!(&:bankrupt?)
            self.reset!
        end
        puts "Game over! The winner is #{@players.first.name}!"
    end

    def reset!
        @players.each do |player|
            @discard_pile += player.hand.hand_array
            player.hand.hand_array.clear
        end

        @deck.deck_array += @discard_pile
        @discard_pile.clear
        @deck.shuffle!
        @pot = 0
        @last_bet = @ante
    end

    def play_round
        still_standing = @players.dup
        still_standing.each { |player| player.place_bet(@ante) } # each player puts ante into pot
        # above line is loud.
        
        puts "Dealing 5 cards to all."
        self.deal_to_all 5
        puts "Beginning the rounds soon."
        puts
        sleep 2

        puts "First betting round:"
        still_standing.reject! { |player| player.prompt_decision == :fold } # betting round

        puts "Discard round:"
        puts
        sleep 2
        still_standing.each(&:prompt_discard)
        
        puts "Second betting round:"
        puts
        sleep 2
        still_standing.reject! { |player| player.prompt_decision == :fold } # second betting round

        still_standing.length == 1 ? self.pot_goes_to(still_standing.first) : self.showdown!(still_standing)
    end

    def deal_to(player)
        @deck.deal_to(player)
    end
    
    def deal_to_all(n) # deals n cards to all players' hands
        raise "Rot enough cards in the deck!" if self.count_deck < (4*n)
        n.times do
            @players.each { |player| @deck.deal_to(player) }
        end
        true
    end

    def pot_goes_to(player)
        puts "#{player.name} wins the round! The $#{pot} pot goes to them."
        player.wallet += @pot
        @pot = 0
        puts "#{player.name} now has $#{player.wallet}."
        puts "Continue to next round?"
        gets
    end
    
    def showdown!(array) # array of players who didn't fold
        ranks = array.map(&:rank)
        if ranks == ranks.uniq # there are no ties 
            winner = array.max_by(&:rank)
            self.pot_goes_to(winner)
        else
            # implement tie breaking
            winner = array.max_by(&:rank)
            # implement tie breaking
        end
    end

    def show_pot_and_last_bet
        puts "Pot: $#{@pot}. Last bet: $#{@last_bet}."
        puts
    end

    # for debug 
    def show_all_hands
        @players.each { |player| player.show_hand }
        true
    end

    def show_deck 
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

Game.new.play