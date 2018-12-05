open("input.txt") do |f|
  puts f.readlines.inject(0) { |sum, n| sum + n.to_i }
end