#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'
class SmiteParser < Racc::Parser

module_eval(<<'...end smite_parser.y/module_eval...', 'smite_parser.y', 216)
def parse(str)
  @q = SmiteLexer.lex!(str)
  do_parse
end

def next_token
  @q.shift
end

...end smite_parser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     7,    17,    18,    18,    20,    20,    12,    22,    23,    24,
    25,    26,    27,    28,    11,    13,    40,    50,    47,    49,
    14,    38,    39,    41,    42,    43,    40,    32,    33,    34,
    35,    38,    39,    41,    42,    43,    32,    33,    34,    35,
    44,    51,    29,    15,    54,    20,    56,    58,    59,    58 ]

racc_action_check = [
     0,     7,     7,    17,     7,    17,     0,     7,     7,     7,
     7,     7,     7,     7,     0,     0,    36,    21,    18,    20,
     0,    36,    36,    36,    36,    36,    14,    13,    13,    13,
    13,    14,    14,    14,    14,    14,    30,    30,    30,    30,
    15,    22,    11,     1,    39,    47,    48,    49,    56,    59 ]

racc_action_pointer = [
    -2,    43,   nil,   nil,   nil,   nil,   nil,    -2,   nil,   nil,
   nil,    40,   nil,     9,     8,    40,   nil,    -1,    13,   nil,
    11,     8,    36,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
    18,   nil,   nil,   nil,   nil,   nil,    -2,   nil,   nil,    39,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    39,    39,    42,
   nil,   nil,   nil,   nil,   nil,   nil,    40,   nil,   nil,    44,
   nil ]

racc_action_default = [
   -48,   -48,    -1,    -2,    -3,    -4,    -5,    -6,    -7,    -8,
    -9,   -48,   -31,   -48,   -48,   -48,   -10,   -13,   -48,   -16,
   -48,   -48,   -48,   -24,   -25,   -26,   -27,   -28,   -29,   -30,
   -32,   -34,   -35,   -36,   -37,   -38,   -39,   -41,   -42,   -48,
   -44,   -45,   -46,   -47,    61,   -11,   -12,   -15,   -17,   -21,
   -22,   -23,   -33,   -40,   -43,   -14,   -48,   -19,   -20,   -21,
   -18 ]

racc_goto_table = [
    37,    31,    57,    16,     5,     6,     8,     9,    10,     4,
    45,    55,    60,    46,    48,     3,    21,    30,    52,     2,
    36,     1,    53 ]

racc_goto_check = [
    19,    17,    14,    10,     5,     6,     7,     8,     9,     4,
    11,    12,    14,    10,    13,     3,    15,    16,    17,     2,
    18,     1,    19 ]

racc_goto_pointer = [
   nil,    21,    19,    15,     9,     4,     5,     6,     7,     8,
    -4,    -7,   -36,    -6,   -47,     9,     4,   -12,     6,   -14 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,    19,   nil,   nil,   nil,   nil,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 29, :_reduce_none,
  1, 30, :_reduce_none,
  1, 30, :_reduce_none,
  1, 30, :_reduce_none,
  1, 30, :_reduce_none,
  1, 31, :_reduce_6,
  1, 31, :_reduce_none,
  1, 31, :_reduce_none,
  1, 31, :_reduce_none,
  2, 36, :_reduce_10,
  3, 36, :_reduce_11,
  1, 39, :_reduce_none,
  0, 39, :_reduce_13,
  3, 38, :_reduce_14,
  2, 38, :_reduce_15,
  1, 38, :_reduce_none,
  2, 40, :_reduce_17,
  4, 41, :_reduce_18,
  2, 41, :_reduce_19,
  1, 42, :_reduce_none,
  0, 42, :_reduce_21,
  3, 35, :_reduce_22,
  3, 35, :_reduce_23,
  2, 35, :_reduce_24,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  2, 37, :_reduce_30,
  1, 32, :_reduce_31,
  2, 33, :_reduce_32,
  2, 44, :_reduce_33,
  1, 44, :_reduce_none,
  1, 45, :_reduce_35,
  1, 45, :_reduce_36,
  1, 45, :_reduce_37,
  1, 45, :_reduce_38,
  2, 34, :_reduce_39,
  2, 46, :_reduce_40,
  1, 46, :_reduce_none,
  1, 47, :_reduce_42,
  2, 47, :_reduce_43,
  1, 47, :_reduce_44,
  1, 47, :_reduce_45,
  1, 47, :_reduce_46,
  1, 47, :_reduce_47 ]

racc_reduce_n = 48

racc_shift_n = 61

racc_token_table = {
  false => 0,
  :error => 1,
  :GOD => 2,
  :STATS => 3,
  :LEVEL => 4,
  :NUM => 5,
  :WITH => 6,
  :COMMA => 7,
  :ITEM => 8,
  :ABILITY => 9,
  :PASSIVE => 10,
  :FIRST => 11,
  :SECOND => 12,
  :THIRD => 13,
  :FOURTH => 14,
  :FIFTH => 15,
  :RECOMMENDED => 16,
  :GODSEARCH => 17,
  :DMG_TYPE => 18,
  :ATK_RANGE => 19,
  :ROLE => 20,
  :PANTHEON => 21,
  :ITEMSEARCH => 22,
  :ITEM_EFFECT => 23,
  :TIER => 24,
  :AURA => 25,
  :STARTER => 26,
  :STACKING => 27 }

racc_nt_base = 28

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "GOD",
  "STATS",
  "LEVEL",
  "NUM",
  "WITH",
  "COMMA",
  "ITEM",
  "ABILITY",
  "PASSIVE",
  "FIRST",
  "SECOND",
  "THIRD",
  "FOURTH",
  "FIFTH",
  "RECOMMENDED",
  "GODSEARCH",
  "DMG_TYPE",
  "ATK_RANGE",
  "ROLE",
  "PANTHEON",
  "ITEMSEARCH",
  "ITEM_EFFECT",
  "TIER",
  "AURA",
  "STARTER",
  "STACKING",
  "$start",
  "target",
  "information",
  "god_info",
  "item_info",
  "god_search",
  "item_search",
  "god_ability",
  "god_stats",
  "god_items",
  "level_and_items",
  "op_level_and_items",
  "with_items",
  "item_list",
  "op_stacks",
  "nth",
  "god_search_info",
  "search_god",
  "item_search_info",
  "search_item" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

# reduce 2 omitted

# reduce 3 omitted

# reduce 4 omitted

# reduce 5 omitted

module_eval(<<'.,.,', 'smite_parser.y', 13)
  def _reduce_6(val, _values, result)
          result = Smite::Game.god(val[0])
    
    result
  end
.,.,

# reduce 7 omitted

# reduce 8 omitted

# reduce 9 omitted

module_eval(<<'.,.,', 'smite_parser.y', 21)
  def _reduce_10(val, _values, result)
          result   = Smite::Game.god(val[0]).stats
      result   = result.at_level(val[1][:level])                    if val[1][:level]
      result   = result.with_items(val[1][:items], val[1][:stacks]) if val[1][:items]

      result
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 28)
  def _reduce_11(val, _values, result)
          result   = Smite::Game.god(val[0]).stats
      result   = result.at_level(val[2][:level])                    if val[2][:level]
      result   = result.with_items(val[2][:items], val[2][:stacks]) if val[2][:items]

      result
    
    result
  end
.,.,

# reduce 12 omitted

module_eval(<<'.,.,', 'smite_parser.y', 37)
  def _reduce_13(val, _values, result)
          result = {}
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 41)
  def _reduce_14(val, _values, result)
          result = { level: val[1] }.merge(val[2])
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 44)
  def _reduce_15(val, _values, result)
          result = { level: val[1] }
    
    result
  end
.,.,

# reduce 16 omitted

module_eval(<<'.,.,', 'smite_parser.y', 50)
  def _reduce_17(val, _values, result)
          stacks = val[1].each_with_object({}) do |(item, num_stacks), hash|
        hash[item.name.downcase] = num_stacks
      end
      items = val[1].map { |pair| pair[0] }

      result = { items: items , stacks: stacks }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 59)
  def _reduce_18(val, _values, result)
          result << [Smite::Game.item(val[2]), val[3]]
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 62)
  def _reduce_19(val, _values, result)
          result = [[Smite::Game.item(val[0]), val[1]]]
    
    result
  end
.,.,

# reduce 20 omitted

module_eval(<<'.,.,', 'smite_parser.y', 67)
  def _reduce_21(val, _values, result)
          result = nil
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 72)
  def _reduce_22(val, _values, result)
          which = (val[1] - 1) % 5
      result = Smite::Game.god(val[0]).abilities[which]
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 76)
  def _reduce_23(val, _values, result)
          which = (val[2] - 1) % 5
      result = Smite::Game.god(val[0]).abilities[which]
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 80)
  def _reduce_24(val, _values, result)
          result = Smite::Game.god(val[0]).abilities[4]
    
    result
  end
.,.,

# reduce 25 omitted

# reduce 26 omitted

# reduce 27 omitted

# reduce 28 omitted

# reduce 29 omitted

module_eval(<<'.,.,', 'smite_parser.y', 87)
  def _reduce_30(val, _values, result)
          recommended_items = Smite::Game.god_recommended_items(val[1])[0].data
      result            = { 
        type: 'god_items',
        data: {
          god:     val[1],
          result:  recommended_items
        }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 99)
  def _reduce_31(val, _values, result)
          result = Smite::Game.item(val[0])
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 103)
  def _reduce_32(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 106)
  def _reduce_33(val, _values, result)
          query         = val[0][:data][:query] + ' ' + val[1][:data][:query]
      search_result = Set.new(val[0][:data][:result]) & Set.new(val[1][:data][:result])
      result = { type: 'godsearch', data: { query: query, result: search_result.to_a } }
    
    result
  end
.,.,

# reduce 34 omitted

module_eval(<<'.,.,', 'smite_parser.y', 113)
  def _reduce_35(val, _values, result)
          filter = Smite::Game.gods.select do |g|
        val[0] =~ /phys/ ? g.physical? : g.magic?
      end
      result = {
        type: 'godsearch',
        data: { query:  val[0], result: filter }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 122)
  def _reduce_36(val, _values, result)
          filter = Smite::Game.gods.select do |g|
        val[0] =~ /melee/ ? g.melee? : g.ranged?
      end
      result = {
        type: 'godsearch',
        data: { query:  val[0], result: filter }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 131)
  def _reduce_37(val, _values, result)
          filter = Smite::Game.gods.select do |g|
        val[0].downcase == g.role.downcase
      end
      result = {
        type: 'godsearch',
        data: { query:  val[0], result: filter }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 140)
  def _reduce_38(val, _values, result)
          filter = Smite::Game.gods.select do |g|
        val[0].downcase == g.pantheon.downcase
      end
      result = {
        type: 'godsearch',
        data: { query:  val[0], result: filter }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 151)
  def _reduce_39(val, _values, result)
     result = val[1] 
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 154)
  def _reduce_40(val, _values, result)
          query         = val[0][:data][:query] + ' ' + val[1][:data][:query]
      search_result = Set.new(val[0][:data][:result]) & Set.new(val[1][:data][:result])
      result = { type: 'itemsearch', data: { query: query, result: search_result.to_a } }
    
    result
  end
.,.,

# reduce 41 omitted

module_eval(<<'.,.,', 'smite_parser.y', 161)
  def _reduce_42(val, _values, result)
          filter = Smite::Game.devices.select do |i|
        i.effects.map(&:attribute).any? do |eff|
          eff.tr('_', ' ') =~ /#{val[0]}/
        end
      end
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 172)
  def _reduce_43(val, _values, result)
          filter = Smite::Game.devices.select { |i| i.tier == val[1] }
      result = {
        type: 'itemsearch',
        data: { query:  val.join(' '), result: filter }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 179)
  def _reduce_44(val, _values, result)
          filter = Smite::Game.devices.select do |i|
        val[0] =~ /magic/ ? i.magic? : i.physical?
      end
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 188)
  def _reduce_45(val, _values, result)
          filter = Smite::Game.devices.select(&:aura?)
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 195)
  def _reduce_46(val, _values, result)
          filter = Smite::Game.devices.select(&:starter?)
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    
    result
  end
.,.,

module_eval(<<'.,.,', 'smite_parser.y', 202)
  def _reduce_47(val, _values, result)
          filter = Smite::Game.devices.select(&:stacking?)
      result = {
        type: 'itemsearch',
        data: { query:  val[0], result: filter }
      }
    
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class SmiteParser

require 'set'
require 'smite'
require_relative './smite_lexer.rb'
