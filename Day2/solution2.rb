def main
  lines = File.open("input.txt").readlines
  threads = []
  lines.each_with_index do |line, i|
    threads << Thread.new { search_for_match(line, lines, i) }
  end
  threads.each { |t| t.join }
end


def search_for_match(str, strs, ind)
  str = str.chomp
  strs.each_with_index do |ostr, i|
    next if str == ostr
    diff =
      if i < ind 
        differing_chars(str, ostr.chomp)
      else
        differing_chars(ostr.chomp, str)
      end
    if diff.count == 1
      puts "Found it! Near identical: #{str} - #{ostr} - #{diff[0]} - #{str.delete!(diff[0])}"
    end
  end
end


def differing_chars(str1, str2)
  diff = []
  str1.chars.each_with_index do |c,i|
    diff << c if c != str2[i]
  end
  diff
end

main