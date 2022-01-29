require_relative 'hand.rb'

class Player
    attr_reader :name
    attr_accessor :wallet, :hand
    

    def initialize(name, game)
        @name = name
        @wallet = 100
        @game = game
        @hand = Hand.new
    end

    def place_bet(amount)
        puts "Not enough money to place bet!" if amount > @wallet # will notify, but not prevent going into the negative.
        raise "Cannot bet less than the previous bet!" if amount < @game.last_bet
        @wallet -= amount
        @game.last_bet = amount
        @game.pot += amount
        puts "#{@name} put $#{amount} into the pot."
        puts "Pot: $#{@game.pot}. #{@name} has $#{@wallet} remaining."
        puts
        sleep 1
    end

    # def prompt_bet # for the first better
    #     system('clear')
    #     puts "Input bet amount - input 0 to check: "

    # end

    def prompt_decision
        system('clear')
        puts "Call, raise, or fold?" # call is also known as see
        @game.show_pot_and_last_bet
        puts "Wallet: $#{@wallet}"
        puts
        self.sort_and_show
        puts

        begin
            input = gets.chomp.downcase
            raise "Please input a valid command" unless input == "call" || input == "raise" || input == "fold"
        rescue => e
            puts e
            retry
        end

        case input
        when "call"
            self.call!
        when "raise"
            self.raise!
        when "fold"
            self.fold!
        end
    end

    def call!
        if @game.last_bet > @wallet
            puts "I can't afford this!"
            self.fold!
            return
        end

        puts
        puts "Call!"
        self.place_bet(@game.last_bet)
        puts "Continue?"
        gets.chomp
    end

    def raise!
        if @game.last_bet > @wallet
            puts "I can't afford this!"
            self.fold!
            return
        end

        puts "Raise how much?"
        begin
            amount = gets.chomp.to_i
            raise "You can't afford this!" if @wallet < amount + @game.last_bet
        rescue => e
            puts e
            retry
        end
        puts
        puts "I raise you #{amount}!" 
        total = @game.last_bet + amount
        self.place_bet(total)
        puts "Continue?"
        gets.chomp
    end

    def fold!
        puts
        puts "Fold!"
        @game.discard_pile += @hand.hand_array
        @hand.hand_array.clear
        sleep 1
        return :fold
    end

    def prompt_discard
        system('clear')
        puts "Please input (up to 3) cards to discard. Begin from 1 and separate with space."
        self.sort_and_show

        begin
            input = gets.chomp.split(" ").map(&:to_i).sort.map {|n| n-1} # processed
            raise "Please input valid cards: 1 to 5" if !input.all? {|n| n.between?(0, 4)}
            n = input.length # number of cards to discard, and therefore replenish
            raise "Can only discard up to 3 cards!" if n > 3
        rescue => e
            puts e
            retry
        end

        if input.length == 0
            puts "Keeping all cards."
            sleep 1
            puts "Ready to proceed?"
            gets
            return true
        end

        puts "Discarding cards."
        input.reverse_each { |i| @game.discard_pile << hand_array.slice!(i) } # moves the chosen cards into to_discard pile
        sleep 1

        puts "Dealing new cards."
        n.times { @game.deal_to self }
        sleep 1

        puts "Your new hand: "
        self.sort_and_show
        puts "Ready to proceed?"
        gets

        true
    end

    def sort_and_show
        self.hand.sort!
        self.show_hand
        self.show_hand_rank
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

    def show_hand_rank
        puts "#{hand.type} (worth #{@hand.rank})"
    end

    def rank
        @hand.rank
    end

    def bankrupt?
        @wallet <= 0
    end
    
end