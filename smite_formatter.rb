require 'smite'

class SmiteFormatter
  class << self
    def format!(smite_obj)
      case smite_obj.class.to_s
      when 'Smite::God'       then format_god(smite_obj)
      when 'Smite::Ability'   then format_ability(smite_obj)
      when 'Smite::Item'      then format_item(smite_obj)
      when 'Smite::GodStats'  then format_god_stats(smite_obj)
      when 'Hash'
        case smite_obj[:type]
        when 'god_items' then format_god_items(smite_obj[:data])
        when 'search'    then format_search_results(smite_obj[:data])
        end
      end
    end

    def format_god(god)
      a     = god.abilities.map(&:summary)
      wiki  = "http://smite.gamepedia.com/#{god.name.downcase}"
      <<-GOD
### **#{god.name}** *(#{god.pantheon} #{god.role})* -- #{god.title}
---
#{godflair(god)} #{god.short_lore}

**Pros:** #{god.pros}

| Passive | Ability 1 | Ability 2 | Ability 3 | Ultimate |
| :---: | :---: | :---: | :---: | :---: |
| #{a[0]} | #{a[1]} | #{a[2]} | #{a[3]} | #{a[4]} |

---
[God Icon](#{god.god_icon_url}) -- [Card Art](#{god.god_card_url}) -- [Wiki](#{wiki})
---
      GOD
    end

    def format_ability(ability)
      god           = Smite::Game.god(ability.god)
      ability_data  = (ability.menuitems + ability.rankitems).map do |map|
        ["> **#{map['description']}**", map['value']].join(' ')
      end
      ability_data << "> **Cooldown:** #{ability.cooldown}"
      <<-ABILITY
### **#{ability.name}** *(#{god.name}'s #{ability.which})*
---
#{godflair(god)} #{ability.description}

#{ability_data.join("\n\n")}

---
[Ability Icon](#{ability.url}) -- [Wiki](http://www.http://smite.gamepedia.com/#{god.name})
---
      ABILITY
    end

    def format_item(item)
      effects = item.effects.map do |effect|
        "**+#{effect.amount}#{effect.percentage}** *#{effect.attribute.tr('_', ' ')}*"
      end
      effects = effects.join(', ')
      <<-ITEM
### **#{item.name}** (#{item_tag(item)})
---
#{item.description}

#{effects}

> #{item.passive}

---
[Item Icon](#{item.item_icon_url}) -- [Wiki](http://smite.gamepedia.com/#{item.name})
---
      ITEM
    end

    def format_god_stats(stats)
      <<-STATS

      STATS
    end

    def format_god_items(god_item_data)
      item_data = god_item_data[:result].except('consumable')
      item_data = item_data.slice(*%w[starter core damage defensive relic])
      keys, table = build_item_table(item_data)      
      <<-GODITEMS
### **Recommended Items** for **#{god_item_data[:god].capitalize}**
---
#{keys}
| :---: | :---: | :---: | :---: | :---: |
#{table.join}
---
**NB:** These items are pulled directly from Smite's API and may not actually be the best items for this god.
      GODITEMS
    end

    def format_search_results(results)
      display_results = results[:result].map do |g| 
        "#{godflair(g)} **#{g.name}** *(#{g.pantheon} #{g.role})*"
      end
      display_results = display_results.empty? ? ['*(No Results)*'] : display_results
      <<-SEARCH
### **Search Results** for **#{results[:query]}**
---
#{display_results.join("\n\n")}
      SEARCH
    end

    private

    def item_tag(item)
      if item.cost == 0
        'Relic'
      elsif item.starter?
        "#{item.price}g, Starter"
      elsif item.consumable?
        "#{item.price}g, Consumable"
      else
        "#{item.cost}g, Tier #{item.item_tier}"
      end
    end

    def build_item_table(item_data)
      keys       = '|' + item_data.keys.map(&:capitalize).join('|') + "|"
      item_data  = item_data.values.map { |tab| tab.map(&:name) }
      item_data  = item_data.map { |val| val.count == 3 ? val + [''] : val }.transpose
      item_data  = item_data.map { |tab| '|' + tab.join('|') + "|\n" }

      [keys, item_data]
    end

    def godflair(god)
      "[](#/flair#{god.name.downcase.gsub(/[^\w]/,'')})"
    end
  end
end