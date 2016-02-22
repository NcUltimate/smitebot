require 'set'
require 'smite'
require 'levenshtein'

class SmiteLexer
  class << self
    def lex!(str)
      str = str.downcase.gsub(/[^\w,\s]/, '')
      str = str.gsub(/,(.+?)( \d+)?(?=,|\z)/) { |match| match.tr(' ','') }
      str = str.gsub(/(?<=with )(.+?)( \d+)?(?=,|\z)/) { |match| match.tr(' ','') }

      queue = []
      until str.empty?
        case str
        when /\A\s+/ 
        # Items and Gods
        when /\A(#{items})/i        then queue.push [:ITEM, $&]
        when /\A(#{gods})/i         then queue.push [:GOD, $&]

        # Item and God Search
        when /\A(#{effects})/i      then queue.push [:ITEM_EFFECT, $&]
        when /\A(#{dmg_types})/i    then queue.push [:DMG_TYPE, $&]
        when /\A(#{atk_ranges})/i   then queue.push [:ATK_RANGE, $&]
        when /\A(#{roles})/i        then queue.push [:ROLE, $&]
        when /\A(#{pantheons})/i    then queue.push [:PANTHEON, $&]
        when /\Agodsearch\b/i       then queue.push [:GODSEARCH, $&]
        when /\Aitemsearch\b/i      then queue.push [:ITEMSEARCH, $&]
        when /\Atier\b/i            then queue.push [:TIER, $&]
        when /\Astack(ing)?\b/i     then queue.push [:STACKING, $&]
        when /\Astarter\b/i         then queue.push [:STARTER, $&]
        when /\Aaura?\b/i           then queue.push [:AURA, $&]

        # Abilities
        when /\A1st/i               then queue.push [:FIRST, $&.to_i]
        when /\A2nd/i               then queue.push [:SECOND, $&.to_i]
        when /\A3rd/i               then queue.push [:THIRD, $&.to_i]
        when /\A4th/i               then queue.push [:FOURTH, $&.to_i]
        when /\A5th/i               then queue.push [:FIFTH, $&.to_i]
        when /\A\d+/                then queue.push [:NUM, $&.to_i]
        when /\Aability\b/i         then queue.push [:ABILITY, $&]
        when /\Apassive\b/i         then queue.push [:PASSIVE, $&]
        when /\Aultimate\b/i
          queue.push [:FOURTH, 4]
          queue.push [:ABILITY, 'ability']

        # God Stats
        when /\A(base )?stats/i     then queue.push [:STATS, $&]
        when /\A(at )?l(evel|vl)/i  then queue.push [:LEVEL, $&]
        when /\Awith\b/i            then queue.push [:WITH, $&]
        when /\A(,|and)/            then queue.push [:COMMA, $&]

        # Recommended Items
        when /\Aitems for\b/i       then queue.push [:RECOMMENDED, $&]

        # Misspelled god
        when /\A.+?(?= (at|level|lvl|base|stats|with|ability|1st|2nd|3rd|4th|5th|ultimate|passive))/i
          closest = closest_god_to($&)
          queue.push [closest[1], closest[0].name]

        # Misspelled item
        when /\A[^,\d]+/i
          closest = if !queue.empty? && [:WITH, :COMMA].include?(queue[-1][0])
            closest_item_to($&)
          else
            closest_obj_to($&)
          end
          queue.push [closest[1], closest[0].name]
        when /\A.+/ then queue.push [$&, $&]
        end
        str = $'
      end
      queue.push [false, '$end']
      queue
    end

    def closest_god_to(str)
      closest_to(str, Smite::Game.gods)
    end

    def closest_item_to(str)
      closest_to(str, Smite::Game.devices)
    end

    def closest_obj_to(str)
      closest_to(str, Smite::Game.gods + Smite::Game.devices)
    end

    def closest_to(str, objects)
      with_distance = objects.map do |obj|
        dist  = Levenshtein.distance str, obj.name
        token = obj.class == Smite::God ? :GOD : :ITEM
        [obj, token, dist]
      end
      with_distance.min_by { |obj| obj[2] }
    end

    def dmg_types
      'physical|magic(al)?'
    end

    def atk_ranges
      'ranged|melee'
    end

    def gods
      return @gods unless @gods.nil?

      @gods = Smite::Game.gods.map(&:name).sort_by(&:length).reverse
      @gods = @gods.map { |g| g.downcase  + '\b' }.join('|')
    end

    def items
      return @items unless @items.nil?

      @items = Smite::Game.devices.map(&:name).sort_by(&:length).reverse
      @items = @items.map { |d| d.downcase.gsub(/[^\w]/,'') }.join('|')
    end

    def roles
      @roles ||= Smite::Game.roles.map { |r| r.downcase + '\b' }.join('|')
    end

    def pantheons
      @pantheons ||= Smite::Game.pantheons.map { |p| p.downcase + '\b' }.join('|')
    end

    def effects
      return @effects unless @effects.nil?

      @effects ||= Smite::Game.item_effects.map { |e| e.tr('_', ' ') }
      @effects += ['penetration', 'lifesteal', 'defense', 'power', 'crit', 'movement', 'speed', 'cooldown']
      @effects = @effects.sort_by(&:length).reverse.join('\b|')
    end
  end
end