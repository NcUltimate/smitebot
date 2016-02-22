class SmiteParser
  rule
  target:   
    information

  information:
    god_info
    | item_info
    | god_search
    | item_search

  god_info:
    GOD {
      result = Smite::Game.god(val[0])
    }
    | god_ability
    | god_stats
    | god_items

  god_stats:
    GOD with_items {
      result   = Smite::Game.god(val[0]).stats
      result   = result.with_items(val[1][:items], val[1][:stacks])
      result
    }
    | GOD STATS op_level_and_items{
      result   = Smite::Game.god(val[0]).stats
      result   = result.at_level(val[2][:level])                    if val[2][:level]
      result   = result.with_items(val[2][:items], val[2][:stacks]) if val[2][:items]

      result
    }
  op_level_and_items:
    LEVEL NUM with_items{
      result = { level: val[1] }.merge(val[2])
    }
    | LEVEL NUM {
      result = { level: val[1] }
    }
    | with_items
    | {
      result = {}
    }
  with_items:
    WITH item_list {
      stacks = val[1].each_with_object({}) do |(item, num_stacks), hash|
        hash[item.name.downcase] = num_stacks
      end
      items = val[1].map { |pair| pair[0] }

      result = { items: items , stacks: stacks }
    }
  item_list:
    item_list COMMA ITEM op_stacks {
      result << [Smite::Game.item(val[2]), val[3]]
    }
    | ITEM op_stacks {
      result = [[Smite::Game.item(val[0]), val[1]]]
    }
  op_stacks:
    NUM
    | { 
      result = nil
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
    RECOMMENDED GOD {
      recommended_items = Smite::Game.god_recommended_items(val[1])[0].data
      result            = { 
        type: 'god_items',
        data: {
          god:     val[1],
          result:  recommended_items
        }
      }
    }

  item_info:
    ITEM {
      result = Smite::Game.item(val[0])
    }

  god_search:
    GODSEARCH god_search_info { result = val[1] }
  god_search_info:
    god_search_info search_god {
      query         = val[0][:data][:query] + ' ' + val[1][:data][:query]
      search_result = Set.new(val[0][:data][:result]) & Set.new(val[1][:data][:result])
      result = { type: 'godsearch', data: { query: query, result: search_result.to_a } }
    }
    | search_god
  search_god:
    DMG_TYPE { 
      filter = Smite::Game.gods.select do |g|
        val[0] =~ /phys/ ? g.physical? : g.magic?
      end
      result = {
        type: 'godsearch',
        data: { query:  val[0], result: filter }
      }
    }
    | ATK_RANGE { 
      filter = Smite::Game.gods.select do |g|
        val[0] =~ /melee/ ? g.melee? : g.ranged?
      end
      result = {
        type: 'godsearch',
        data: { query:  val[0], result: filter }
      }
    }
    | ROLE { 
      filter = Smite::Game.gods.select do |g|
        val[0].downcase == g.role.downcase
      end
      result = {
        type: 'godsearch',
        data: { query:  val[0], result: filter }
      }
    }
    | PANTHEON { 
      filter = Smite::Game.gods.select do |g|
        val[0].downcase == g.pantheon.downcase
      end
      result = {
        type: 'godsearch',
        data: { query:  val[0], result: filter }
      }
    }


  item_search:
    ITEMSEARCH item_search_info { result = val[1] }
  item_search_info:
    item_search_info search_item {
      query         = val[0][:data][:query] + ' ' + val[1][:data][:query]
      search_result = Set.new(val[0][:data][:result]) & Set.new(val[1][:data][:result])
      result = { type: 'itemsearch', data: { query: query, result: search_result.to_a } }
    }
    | search_item
  search_item:
    ITEM_EFFECT {
      filter = Smite::Game.devices.select do |i|
        i.effects.map(&:attribute).any? do |eff|
          eff.tr('_', ' ') =~ /#{val[0]}/
        end
      end
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    }
    | TIER NUM {
      filter = Smite::Game.devices.select { |i| i.tier == val[1] }
      result = {
        type: 'itemsearch',
        data: { query:  val.join(' '), result: filter }
      }
    }
    | DMG_TYPE { 
      filter = Smite::Game.devices.select do |i|
        val[0] =~ /magic/ ? i.magic? : i.physical?
      end
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    }
    | AURA {
      filter = Smite::Game.devices.select(&:aura?)
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    }
    | STARTER {
      filter = Smite::Game.devices.select(&:starter?)
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    }
    | STACKING {
      filter = Smite::Game.devices.select(&:stacking?)
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    }
end

# the 'inner' section defines the methods
# of class SmiteParser, since the above
# definition serves as an override
# for writing the BNF grammar.
---- inner
def parse(str)
  @q = SmiteLexer.lex!(str)
  do_parse
end

def next_token
  @q.shift
end

---- footer
require 'set'
require 'smite'
require_relative './smite_lexer.rb'
