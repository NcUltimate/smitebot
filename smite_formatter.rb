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
        when 'god_items'  then format_god_items(smite_obj[:data])
        when 'godsearch'  then format_god_search_results(smite_obj[:data])
        when 'itemsearch' then format_item_search_results(smite_obj[:data])
        end
      end
    end

    def format_god(god)
      a     = god.abilities.map(&:summary)
      <<-GOD
### **#{god.name}** *(#{god.pantheon} #{god.role})* -- #{god.title}
---
#{godflair(god.name)} #{god.short_lore.gsub('\n\n', ' ')}

**Pros:** #{god.pros}

| Ability 1 | Ability 2 | Ability 3 | Ultimate | Passive |
| :---: | :---: | :---: | :---: | :---: |
| #{a[0]} | #{a[1]} | #{a[2]} | #{a[3]} | #{a[4]} |

---
[God Icon](#{god.god_icon_url}) -- [Card Art](#{god.god_card_url}) -- [Wiki](#{wiki(god.name)}) -- [Report Bug](#{bug_report})
      GOD
    end

    def format_ability(ability)
      god           = Smite::Game.god(ability.god)
      ability_data  = (ability.menuitems + ability.rankitems).map do |map|
        ["> **#{map['description']}**", map['value']].join(' ')
      end
      ability_data << "> **Cooldown:** #{ability.cooldown}" if ability.number != 5
      <<-ABILITY
### **#{ability.name}** *(#{god.name} #{ability.which})*
---
#{godflair(god.name)} #{ability.description}

#{ability_data.join("\n\n")}

---
[Ability Icon](#{ability.url}) -- [Wiki](#{wiki(god.name)} -- [Report Bug](#{bug_report})
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
[Item Icon](#{item.item_icon_url}) -- [Wiki](#{wiki(item.name)}) -- [Report Bug](#{bug_report})
      ITEM
    end

    def format_god_stats(stats)
      items = items_and_stacks(stats).join(', ')
      items = items == '' ? 'No Items' : items
      <<-STATS
### #{stats.name} God Stats (#{stat_str(stats.level)})
---
#{godflair(stats.name)} **With Items:** *#{items}*

| Attribute | Value | Attribute | Value |
| --- | --- | --- | --- |
| *Health* | **#{stats.health}** | *Mana* | **#{stats.mana}** |
| *Attack Speed* | **#{stats.attack_speed}** | *Movement Speed* | **#{stats.movement_speed}** |
| *HP5* | **#{stats.hp5}** | *MP5* | **#{stats.mp5}**|
| *Physical Power* | **#{stats.physical_power}** | *Magical Power* | **#{stats.magical_power}** |
| *Physical Protection* | **#{stats.physical_protection}** | *Magical Protection* | **#{stats.magic_protection}** |
      
---
[God Wiki](#{wiki(stats.name)}) -- [Report Bug](#{bug_report})
      STATS
    end

    def format_god_items(god_item_data)
      item_data = god_item_data[:result].except('consumable')
      item_data = item_data.slice(*%w[starter core damage defensive relic])
      keys, table = build_item_table(item_data)      
      <<-GODITEMS
### #{godflair(god_item_data[:god])}**Recommended Items** for **#{god_item_data[:god].capitalize}**
---
#{keys}
| :---: | :---: | :---: | :---: | :---: |
#{table.join}

**NB:** These items are pulled directly from Smite's API and may not actually be the best items for this god.

---
[God Wiki](#{wiki(god_item_data[:god])}) -- [Report Bug](#{bug_report})
      GODITEMS
    end

    def format_god_search_results(results)
      display_results = results[:result].map do |g| 
        "#{godflair(g.name)} **#{g.name}** *(#{g.pantheon} #{g.role})*"
      end
      display_results = display_results.empty? ? ['*(No Results)*'] : display_results
      <<-GODSEARCH
### **God Search Results** for **#{results[:query]}**
---
#{display_results.join("\n\n")}

---
[Report Bug](#{bug_report})
      GODSEARCH
    end

    def format_item_search_results(results)
      display_results = results[:result].map do |i| 
        "**#{i.name}** *(#{item_tag(i)})*"
      end
      display_results = display_results.empty? ? ['*(No Results)*'] : display_results
      <<-ITEMSEARCH
### **Item Search Results** for **#{results[:query]}**
---
#{display_results.join("\n\n")}

---
[Report Bug](#{bug_report})
      ITEMSEARCH
    end

    private

    def items_and_stacks(stats)
      stats.items.map do |item|
        name = item.name.downcase
        "#{name}" + (item.stacking? ? " (#{stats.stacks[name]} stacks)" : '')
      end
    end

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

    def stat_str(level)
      level == 0 ? 'Base Stats' : "Level #{level}"
    end

    def godflair(god)
      "[](#/flair#{god.downcase.gsub(/[^\w]/,'')})"
    end

    def wiki(name)
      "http://smite.gamepedia.com/#{name}"
    end

    def bug_report
      'https://www.reddit.com/r/smiteinfobot/submit?selftext=true&title=[Bug%20Report]%3Cyour_bug_report_here%3E'
    end
  end
end