def main
  open("input.txt") do |f|
    polymer = f.readline

    threads = []
    reaction_re = polymer_pair_regex
    ('a'..'z').each do |l|
      threads << Thread.new { remove_base_react(l, polymer.clone) }
    end
    threads.each { |t| t.join }
  end
end

def polymer_pair_regex
  str = ""
  ('a'..'z').each do |l|
    str += "|#{l}#{l.upcase}|#{l.upcase}#{l}"
  end
  Regexp.new(str.slice(1..str.length))
end

def react(polymer)
  reacted = ""
  reg = polymer_pair_regex
  polymer.each_char do |c|
    reacted += c
    len = reacted.length
    if len >= 2
      checked = reacted[len - 2] + reacted[len - 1]
      
      if checked.slice!(reg)
        reacted = "" if len == 2
        reacted = reacted.slice!(0..len-3) if len > 2
      end
    end
  end
  reacted
end

def remove_base_react(base, polymer)
  polymer.delete!(base)
  polymer.delete!(base.upcase)
  reacted = react(polymer)

  puts "Removed base #{base} and ended with polymer of length #{reacted.length}"
end

main
