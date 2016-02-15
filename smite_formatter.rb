require 'smite'

class SmiteFormatter
  class << self
    def format!(smite_obj)
      p smite_obj.class
      case smite_obj.class.to_s
      when 'Smite::God'       then format_god(smite_obj)
      when 'Smite::Ability'   then format_ability(smite_obj)
      when 'Smite::Item'      then format_item(smite_obj)
      when 'Smite::GodStats'  then format_god_stats(smite_obj)
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

    def godflair(god)
      "[](#/flair#{god.name.downcase.gsub(/^w/,'')})"
    end
  end
end