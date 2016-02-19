require 'set'
require 'smite'

class SmiteLexer
  class << self
    def lex!(str)
      queue = []
      until str.empty?
        case str
        when /\A\s+/

        # Items and Gods
        when /\A(#{items})/i        then queue.push [:ITEM, $&.downcase]
        when /\A(#{gods})/i         then queue.push [:GOD, $&.downcase]

        # Item and God Search
        when /\A(#{effects})/i      then queue.push [:ITEM_EFFECT, $&.downcase]
        when /\A(#{dmg_types})/i    then queue.push [:DMG_TYPE, $&.downcase]
        when /\A(#{atk_ranges})/i   then queue.push [:ATK_RANGE, $&.downcase]
        when /\A(#{roles})/i        then queue.push [:ROLE, $&.downcase]
        when /\A(#{pantheons})/i    then queue.push [:PANTHEON, $&.downcase]
        when /\Agodsearch\b/i       then queue.push [:GODSEARCH, $&.downcase]
        when /\Aitemsearch\b/i      then queue.push [:ITEMSEARCH, $&.downcase]
        when /\Atier\b/i            then queue.push [:TIER, $&.downcase]
        when /\Astack(ing)?\b/i     then queue.push [:STACKING, $&.downcase]
        when /\Astarter\b/i         then queue.push [:STARTER, $&.downcase]
        when /\Aaura?\b/i           then queue.push [:AURA, $&.downcase]

        # Abilities
        when /\A1st/i               then queue.push [:FIRST, $&.to_i]
        when /\A2nd/i               then queue.push [:SECOND, $&.to_i]
        when /\A3rd/i               then queue.push [:THIRD, $&.to_i]
        when /\A4th/i               then queue.push [:FOURTH, $&.to_i]
        when /\A5th/i               then queue.push [:FIFTH, $&.to_i]
        when /\A\d+/                then queue.push [:NUM, $&.to_i]
        when /\Aability\b/i         then queue.push [:ABILITY, $&.downcase]
        when /\Apassive\b/i         then queue.push [:PASSIVE, $&.downcase]
        when /\Aultimate\b/i
          queue.push [:FOURTH, 4]
          queue.push [:ABILITY, 'ability']

        # God Stats
        when /\A(base )?stats/i     then queue.push [:STATS, $&.downcase]
        when /\A(at )?level/i       then queue.push [:LEVEL, $&.downcase]
        when /\Awith\b/i            then queue.push [:WITH, $&.downcase]

        # Recommended Items
        when /\Aitems for\b/i       then queue.push [:RECOMMENDED, $&.downcase]

        # Anything Else
        when /\A./                  then queue.push [$&, $&]
        end
        str = $'
      end
      queue.push [false, '$end']
      queue
    end

    def dmg_types
      'physical|magic(al)?'
    end

    def atk_ranges
      'ranged|melee'
    end

    def roles
      @roles ||= Smite::Game.roles.map { |r| r.downcase + '\b' }.join('|')
    end

    def pantheons
      @pantheons ||= Smite::Game.pantheons.map { |p| p.downcase + '\b' }.join('|')
    end

    def gods
      return @gods unless @gods.nil?

      @gods = Smite::Game.gods.map(&:name).sort_by(&:length).reverse
      @gods = @gods.map { |g| g.downcase + '\b' }.join('|')
    end

    def items
      return @items unless @items.nil?

      @items = Smite::Game.devices.map(&:name).sort_by(&:length).reverse
      @items = @items.map { |d| d.downcase + '\b' }.join('|')
    end

    def effects
      return @effects unless @effects.nil?

      @effects ||= Smite::Game.item_effects.map { |e| e.tr('_', ' ') }
      @effects += ['penetration', 'lifesteal', 'defense', 'power', 'crit', 'movement', 'speed']
      @effects = @effects.sort_by(&:length).reverse.join('\b|')
    end
  end
end