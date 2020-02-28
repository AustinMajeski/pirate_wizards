puts "\n\n\n"
=begin
    

    Wizzard
    magic

    Pirate WizARRRds
     - out to get some booteh
     - sailing on a boat in the Carribean

     # Gameplay 
     - can choose a direction to sail
     - can come across other boats ( maybe say what size if their close enough )
     - can come across little islands
        - can choose to dock at them
        - if docked, have 3 chances to dig for burried treasure
            -  ^ *** 'lucky items' found along the way can increase the chances of finding booty


    #  Your Ship
     - Health
     - Attack
       * can upgrade each

    
    # Final Boss
    -  happen after 'X' amount of turns
     {[ ! @ ! ]}- you see no boat ... but you hear a clock ticking ... ( some turns later, an aligator attacks the ship )



     # Systems
     [( * )]  Encounter system:   -Health  -Attack
      - tag encounters :  (ships will know if we have encountered them before)
      - 'luck items'
      - upgradeable cannons
      - * - Damage 
        > Base :  5-7
            -  add 3 per upgrade (cannon)
        > Luck : per luck item, addtional damage ( 10+ per upgrade cannon )
        


    # Booty
     - coins
     - 'upgrades'  : blueprints (specific)



=end



=begin
/// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 LINE              =   "_____________________________________________________"
 SPACE             =   "    "
 ESC               =   String.fromCharCode(033)
 BLUE_BACKGROUND   =   ""//ESC+"[48;5;217m"
 WHITE_BACKGROUND  =   ESC+"[48;5;15m"
 WHITE_TEXT        =   ""//ESC+"[38;5;15m"
 FORMAT_RESET      =   ESC+"[0m"

function log() { 
    console.log(`#{BLUE_BACKGROUND} #{WHITE_BACKGROUND}#{LINE}#{FORMAT_RESET}#{BLUE_BACKGROUND}\n\n#{SPACE}#{arguments[0]}\n #{LINE}\n\n`)
    let Args = Array.from( arguments ).splice(1)
    Args.forEach( out => {
        if ( Array.isArray( out ) ){
            let outputArrayText = SPACE + "[ "
            out.forEach( (v,i) => {
                if ( i < out.length-1 )  { outputArrayText += `#{v}, ` }
                else  { outputArrayText += v }  
            } )
            console.log( outputArrayText += " ]" )
        }
        else{ console.log( SPACE + out ) }
    } )
    console.log(`\n #{LINE}\n #{LINE}\n\n\n`)
}
console.log("\n" + BLUE_BACKGROUND + WHITE_TEXT + "\n\n\n\n")
/// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
=end






# #/// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  LINE              =   "_____________________________________________________"
#  SPACE             =   "    "
#  ESC               =   27.chr
#  BLUE_BACKGROUND   =   ""#ESC+"[48;5;217m"
#  WHITE_BACKGROUND  =   ESC+"[48;5;15m"
#  WHITE_TEXT        =   ""#ESC+"[38;5;15m"
#  FORMAT_RESET      =   ESC+"[0m"

# def log ( title, logs )  
#     puts '#{BLUE_BACKGROUND} #{WHITE_BACKGROUND}#{LINE}#{FORMAT_RESET}#{BLUE_BACKGROUND}\n\n#{SPACE}#{arguments[0]}\n #{LINE}\n\n'
#     let Args = Array.from( arguments ).splice(1)
#     Args.forEach( out => {
#         if ( Array.isArray( out ) ){
#             let outputArrayText = SPACE + "[ "
#             out.forEach( (v,i) => {
#                 if  i < out.length-1   
#                      outputArrayText += '#{v}, ' 
#                 else
#                      outputArrayText += v 
#                 end  
#             } )
#             puts  outputArrayText += " ]" 
#         }
#         else
#              puts SPACE + out 
#         end
#     } )
#     puts '\n #{LINE}\n #{LINE}\n\n\n'
# end
# puts "\n" + BLUE_BACKGROUND + WHITE_TEXT + "\n\n\n\n"
# #/// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -











# =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*= =*=



class Player

    @@posX = 0
    @@posY = 0
    @@coins = 0
    @@attack = 5
    @@health = 100


    #  -  -  -  -  -  -  -  -  -  -  -  -  -
    def self.get_x
        @@posX 
    end

    def self.get_y
        @@posY
    end

    def self.get_health
        @@health
    end

    def self.get_attack
        @@attack
    end

    def self.get_coins
        @@coins
    end



    #  -  -  -  -  -  -  -  -  -  -  -  -  -

    def self.move

        print "\nDirection?  "
        direction = gets.chomp
        puts "\n\n"

        valid_direction = false
        while valid_direction == false
            case direction
                when /North|Up/i # North
                    # puts "North"
                    @@posY += 1
                    valid_direction = true
                when /South|Down/i  # South
                    # puts "South"
                    @@posY -= 1
                    valid_direction = true
                when /East|Right/i  # East
                    # puts "East"
                    @@posX += 1
                    valid_direction = true
                when /West|Left/i  #
                    # puts "West"
                    @@posX -= 1
                    valid_direction = true
                else
                    print "\nPlease choose a valid direction:  "
                    direction = gets.chomp
            end
        end
    end


    def self.receive_coins num
        @@coins += num
    end



    #  -  -  -  -  -  -  -  -  -  -  -  -  -
    def self.print_me
        print " #@@posX  ,  #@@posY  "
    end

end



#  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-



class Ship

    def initialize
        @posX = Player.get_x
        @posY = Player.get_y

        @level  = rand(6)       # 0 - 5     # [!]  Size of '0' is 'wreckage'
        @health = 100 * @level
        @damage = 10 * @level
    end

    #  -  -  -  -  -  -  -  -  -  -  -  -  -
    def get_x
        @posX
    end

    def get_y
        @posY
    end

    def get_health
        @health
    end

    def get_damage
        @damage
    end


    #  -  -  -  -  -  -  -  -  -  -  -  -  -


    def take_damage num
        @health -= num
        if @health < 0
            @health = 0
        end
    end


end



#  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-



class Island
    
    @@names = ["Hilbert", "Guatamulharita", "Billy Perb"]
    @@name_endings = ["Cove", "Beach", "Stone Beach"]


    def initialize
        @posX = Player.get_x
        @posY = Player.get_y

        @size = rand(3) + 1
        @name = generate_name
    end


    #  -  -  -  -  -  -  -  -  -  -  -  -  -

    def get_size
        @size
    end

    def generate_name
        "#{@@names[rand(@@names.length)]} #{@@name_endings[rand(@@name_endings.length)]}"
    end

    #  -  -  -  -  -  -  -  -  -  -  -  -  -


    # Private
    def can_dig?
        if @size > 0
            return true
        else
            return false
        end
    end


    # Player attempt
    def try_for_treasure
        if can_dig?
            @size -= 1
            if rand() < 0.5          # PLUS  LUCK
                coins = (rand(11)+60) 
                Player.receive_coins( coins )
                return "Booty!  You found #{coins} coins.\n You now have #{Player.get_coins} coins!"
            else
                return "just dirt"    # TODO :  return some booty item
            end
        else
            return "no other places to dig"
        end
    end
end



#  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-


class Sea
end


#  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-



class Log_Visits

    @@tiles_visited = {}

    #  -  -  -  -  -  -  -  -  -  -  -  -  -

    def self.log  ( obj )        # change to hash stuff

        if Log_Visits.populated?

            return @@tiles_visited[ Player.get_x ][ Player.get_y ]
            
        else

            if @@tiles_visited.key?(Player.get_x)
                @@tiles_visited[ Player.get_x ].merge!( { Player.get_y => obj } )
            else
                @@tiles_visited.merge!( { Player.get_x => { Player.get_y => obj } } )
            end

            return obj
        end

        return obj

    end



    def self.populated?
        if @@tiles_visited.key?(Player.get_x)
            if @@tiles_visited[Player.get_x].key?(Player.get_y)
                return true
            end
        end
        return false
    end


    #  -  -  -  -  -  -  -  -  -  -  -  -  -


    def self.get_visited
        @@tiles_visited
    end


end



#  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-  -*-



class Gameplay

    def self.start
        puts "You are a pirate on a boat in the ocean.  go."
        

        turn_limit = 6  # 6
        turn_limit.times do
            Log_Visits.log( Sea.new )


            Player.move
            Log_Visits.log( Gameplay.sea_event )

            case Log_Visits.get_visited[ Player.get_x ][ Player.get_y ]
                when Ship
                    puts "It be ship\n\n"
                    Gameplay.ship_encounter
                when Island
                    puts "It be islands\n\n"
                    Gameplay.island_encounter
                when Sea
                    puts "It be the sea\n\n"
                else
            end

        end

        puts  "\n\n\n\n You won #{Player.get_coins} Coins!!!!\n\n\n"
    end



    #  -  -  -  -  -  -  -  -  -  -  -  -  -



    def self.sea_event
        r = rand(8)
        case r.to_s
            when /0|1/  # islands  
                return Island.new
            when /4/ # ship encounter
                return Ship.new
            else    # "Sea"
                Player.receive_coins( rand(5)+6 )   # sea 6 - 10 coins
                return Sea.new
        end
    end



    def self.ship_encounter

        while Log_Visits.get_visited[ Player.get_x ][ Player.get_y ].get_health > 0
            puts "What?  You egg?"
            gets
            puts "\n\nATTACK!\n\n"
            
            Log_Visits.get_visited[ Player.get_x ][ Player.get_y ].take_damage(  Player.get_attack*10 )
            puts "Enemy Health now: #{Log_Visits.get_visited[ Player.get_x ][ Player.get_y ].get_health}"
        end
        if Log_Visits.get_visited[ Player.get_x ][ Player.get_y ].get_health == 0
            puts "*he dies*"
            Log_Visits.get_visited[ Player.get_x ][ Player.get_y ] = Sea.new
        end

    end



    def self.island_encounter

        while Log_Visits.get_visited[ Player.get_x ][ Player.get_y ].can_dig?
            print "dig?  "
            response = gets   # TODO
            puts "\n\n"
            puts "found: #{Log_Visits.get_visited[ Player.get_x ][ Player.get_y ].try_for_treasure}\n\n"
        end
        puts "nowhere else to dig.\n\n"

    end


end







#  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /

#                             G a m e   S t a r t

#  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /  / /

continue = "Yes"

while /Yes/i.match( continue )
    Gameplay.start
    print "\n\nDo you want to restart?   "
    continue = gets.chomp
    puts "\n\n\n"
end
puts "\n\nbye bye\n\n"









puts "\n\n\n"
# EOF