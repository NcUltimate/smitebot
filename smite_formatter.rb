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
      <<-EOF
**#{god.name}** *(#{god.pantheon} #{god.role})* -- #{god.title}
---
---
[](#/flair#{god.name.downcase.gsub(/^w/,'')}) #{god.short_lore}


| Passive | 1st ability | 2nd ability | 3rd ability | Ultimate |
| :---: | :---: | :---: | :---: | :---: |
| #{a[0]} | #{a[1]} | #{a[2]} | #{a[3]} | #{a[4]} |

> **Pros:** High Single Target Damage, High Sustain

##[God Icon](#{god.god_icon_url}) -- [Card Art](#{god.god_card_url}) -- [Wiki](#{wiki})

---
To learn about any of #{god.name}'s abilities, reply with 
`{{ #{god.name} <column_name> }}` replacing `<column_name>` with a header in #{god.name}'s ability table.
      EOF
    end

    def format_ability(ability)

    end

    def format_item(item)

    end

    def format_god_stats(stats)

    end
  end
end