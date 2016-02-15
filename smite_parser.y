class SmiteParser
  rule
  target:   
    information

  information:
    god_info
    | item_info
    | search_info

  god_info:
    GOD {
      result = Smite::Game.god(val[0])
    }
    | god_ability
    | god_stats
    | god_items

  god_stats:
    GOD STATS level_and_items{
      result   = Smite::Game.god(val[0]).stats
      result   = result.at_level(val[2][:level]) if val[2][:level]
      result   = result.with_items(val[2][:items]) if val[2][:items]

      result
    }

  level_and_items:
    LEVEL NUM WITH item_list{
      result = { level: val[1], items: val[3] }
    }
    | WITH item_list LEVEL NUM{
      result = { level: val[3], items: val[1] }
    }
    | WITH item_list {
      result = { items: val[1] }
    }
    | LEVEL NUM {
      result = { level: val[1]}
    }
    | {
      result = {}
    }
  item_list:
    item_list ',' ITEM {
      result << Smite::Game.item(val[2])
    }
    | ITEM {
      result = [Smite::Game.item(val[0])]
    }

  god_ability:
    GOD nth ABILITY {
      which = (val[1] - 1) % 5
      result = Smite::Game.god(val[0]).abilities[which]
    }
    | GOD ABILITY NUM {
      which = (val[2] - 1) % 5
      result = Smite::Game.god(val[0]).abilities[which]
    }
    | GOD PASSIVE {
      result = Smite::Game.god(val[0]).abilities[4]
    }
  nth:
    FIRST | SECOND | THIRD | FOURTH | FIFTH

  god_items:
    GOD RECOMMENDED {
      recommended_items = Smite::Game.god_recommended_items(val[0])[0].data
      result            = { 
        type: 'god_items',
        data: {
          god:     val[0],
          result:  recommended_items
        }
      }
    }

  item_info:
    ITEM {
      result = Smite::Game.item(val[0])
    }
    | ITEM PASSIVE {
      result = Smite::Game.item(val[0]).passive
    }
    | ITEM EFFECTS {
      result = Smite::Game.item(val[0]).effects
    }

  search_info:
    search_info search_item {
      query         = val[0][:data][:query] + ' ' + val[1][:data][:query]
      search_result = Set.new(val[0][:data][:result]) & Set.new(val[1][:data][:result])
      result = { type: 'search', data: { query: query, result: search_result.to_a } }
    }
    | search_item

  search_item:
    DMG_TYPE { 
      filter = Smite::Game.gods.select do |g|
        val[0] =~ /phys/ ? g.physical? : g.magic?
      end
      result = {
        type: 'search',
        data: { query:  val[0], result: filter }
      }
    }
    | ATK_RANGE { 
      filter = Smite::Game.gods.select do |g|
        val[0] =~ /melee/ ? g.melee? : g.ranged?
      end
      result = {
        type: 'search',
        data: { query:  val[0], result: filter }
      }
    }
    | ROLE { 
      filter = Smite::Game.gods.select do |g|
        val[0].downcase == g.role.downcase
      end
      result = {
        type: 'search',
        data: { query:  val[0], result: filter }
      }
    }
    | PANTHEON { 
      filter = Smite::Game.gods.select do |g|
        val[0].downcase == g.pantheon.downcase
      end
      result = {
        type: 'search',
        data: { query:  val[0], result: filter }
      }
    }

end

# the 'inner' section defines methods
# of SmiteParser, since the above
# definition serves as an override
# for writing the BNF grammar.
---- inner
  
def parse(str)
  @q = []
  until str.empty?
    case str
    when /\A\s+/
    when /\A(#{items})/i
      @q.push [:ITEM, $&.downcase]
    when /\A(#{gods})/i
      @q.push [:GOD, $&.downcase]
    when /\A1st/i
      @q.push [:FIRST, $&.to_i]
    when /\A2nd/i
      @q.push [:SECOND, $&.to_i]
    when /\A3rd/i
      @q.push [:THIRD, $&.to_i]
    when /\A4th/i
      @q.push [:FOURTH, $&.to_i]
    when /\A5th/i
      @q.push [:FIFTH, $&.to_i]
    when /\A\d+/
      @q.push [:NUM, $&.to_i]
    when /\Aability/i
      @q.push [:ABILITY, $&.downcase]
    when /\Aultimate/i
      @q.push [:FOURTH, 4]
      @q.push [:ABILITY, 'ability']
    when /\Apassive/i
      @q.push [:PASSIVE, $&.downcase]
    when /\A(recommended )?items/i
      @q.push [:RECOMMENDED, $&.downcase]
    when /\Aeffects/i
      @q.push [:EFFECTS, $&.downcase]
    when /\Awith/i
      @q.push [:WITH, $&.downcase]
    when /\A(base )?stats/i
      @q.push [:STATS, $&.downcase]
    when /\A(at )?level/i
      @q.push [:LEVEL, $&.downcase]
    when /\A(#{dmg_types})/i
      @q.push [:DMG_TYPE, $&.downcase]
    when /\A(#{atk_ranges})/i
      @q.push [:ATK_RANGE, $&.downcase]
    when /\A(#{roles})/i
      @q.push [:ROLE, $&.downcase]
    when /\A(#{pantheons})/i
      @q.push [:PANTHEON, $&.downcase]
    when /\A./
      @q.push [$&, $&]
    end
    str = $'
  end
  @q.push [false, '$end']
  do_parse
end

def dmg_types
  'physical|magic(al)?'
end

def atk_ranges
  'ranged|melee'
end

def roles
  @roles ||= Smite::Game.roles.join('|')
end

def pantheons
  @pantheons ||= Smite::Game.pantheons.join('|')
end

def gods
  @gods ||= Smite::Game.gods.map { |g| g.name.downcase }.join('|')
end

def items
  @items ||= Smite::Game.devices.map { |d| d.name.downcase }.join('|')
end

def next_token
  @q.shift
end

---- footer
require 'set'
require 'smite'