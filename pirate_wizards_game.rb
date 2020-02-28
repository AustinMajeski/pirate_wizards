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


require 'json'

#/// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 LENGTH            =  55
 LINE              =   "_" * LENGTH
 BLOCK             =   Integer("0x2588").chr("UTF-8")
 BLOCK_LINE        =   BLOCK * LENGTH
 SPACE             =   "    "
 ESC               =   27.chr
 BLUE_BACKGROUND   =   ""#ESC+"[48;5;217m"
 WHITE_BACKGROUND  =   ESC+"[48;5;15m"
 WHITE_TEXT        =   ""#ESC+"[38;5;15m"
 FORMAT_RESET      =   ESC+"[0m"

def log ( title, logs=[] )  
    puts "#{BLUE_BACKGROUND} #{WHITE_BACKGROUND}#{BLOCK_LINE}#{FORMAT_RESET}#{BLUE_BACKGROUND}\n\n#{SPACE}#{title}\n #{LINE}\n\n\n"

    logs.each { |w| 
      if w.kind_of?(Array)
        output = SPACE + "[ "
        index = 0
        w.each { |v|
           if  index < w.length - 1 
                output += "#{v}, "
                index += 1
           else
                output += v.to_s 
           end  
        }
        puts output + " ]"
      elsif w.kind_of?(Hash)
        keys = collect_recursive_keys( w )
        values = []
        pretty_hash = JSON.pretty_generate(w).gsub(":", " =>").gsub("\n","\n#{SPACE}").gsub("},", "},\n")
        keys.each { |k| pretty_hash.gsub!( "\"#{k}\" =>",":#{k} =>") }
        puts "#{SPACE}#{pretty_hash}"
      else
        puts SPACE + w.to_s 
      end
      
    }
    puts "\n #{LINE}\n #{LINE}\n\n\n"
end



def collect_recursive_keys ( hash_in, keys=[] )
  keys.concat( hash_in.keys ).uniq!
  hash_in.each { |v| 
    if v[1].kind_of?(Hash)
      keys.concat( collect_recursive_keys( v[1], keys ) ).uniq!
    end
  }
  return keys
end


def collect_recursive_classes ( hash_in, values=[] )

  values.concat( hash_in.values ).uniq!
  hash_in.each { |v| 
    if v[1].kind_of?(Hash)
      values.concat( collect_recursive_classes( v[1], values ) ).uniq!
    end
  }

  classes = []
  values.each { |c|
    puts "\n - #{c.to_s}"
    if c.kind_of?(Class)
      classess << "<#{c.to_s}>"
    end
  }

  return classes
end



puts "\n" + BLUE_BACKGROUND + WHITE_TEXT + "\n\n\n\n"
#/// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# =begin
##       log function testing

my_hash = {:hello => "goodbye", :goob => 77, :keyhole => true}
my_internal_hash = {:hello => "goodbye", :goob => 77, :H => { :L => "poop", :D => 8 }, :keyhole => true}
dimentional_hash = {:one => {:two => {:pp => 3, :three => {:four => {:five => "end", :f => "five"}}}}}

log(  "Hippo", 
[
      "Value",
      "Goob",
      [1,23,45,6],
      my_hash,
      true,
      my_internal_hash,
      "I herby delare!...",
      "",
      dimentional_hash,
      ""
])
# =end


#puts collect_recursive_classes( my_internal_hash )


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
                    @@posY += 1
                    valid_direction = true
                when /South|Down/i  # South
                    @@posY -= 1
                    valid_direction = true
                when /East|Right/i  # East
                    @@posX += 1
                    valid_direction = true
                when /West|Left/i  # West
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

    def self.clear
      @@tiles_visited = {}
    end


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

continue = "no" # Yes

while /Yes/i.match( continue )
    Log_Visits.clear
    Gameplay.start
    print "\n\nDo you want to restart?   "
    continue = gets.chomp
    puts "\n\n\n"
end


puts "\n\n\n"
puts Ship.kind_of?(Class)
puts Ship.to_s
puts "\n\n"

butt = Ship.new
hasery = {}
print "HASH:  "
puts hasery.kind_of?(Object)
puts hasery.class
puts hasery.instance_of? hasery.class
print "Class? "
puts hasery.kind_of?(Class)

puts "\n\nShip"
puts butt.kind_of?(Class)
puts butt.instance_of? butt.class
puts butt.class
print "Defined?  "
puts defined?(butt)
#print "classs?  "
#puts #class?(butt)
puts "\n\n\n"


Player.move
Log_Visits.log( Gameplay.sea_event )
Player.move
Log_Visits.log( Gameplay.sea_event )


puts collect_recursive_classes( Log_Visits.get_visited )


log(  "Tiles Visited",
  [
      Log_Visits.get_visited,
      "", "",
      collect_recursive_classes( Log_Visits.get_visited )
  ])

puts "\n\nbye bye\n\n"










puts "\n\n\n"
# EOF