
twos = 0
threes = 0
File.open("input.txt").readlines.each do |word|
  grps = word.chars.group_by { |i| i }
  two = 0
  three = 0
  grps.values.each do |grp|
    two += 1 if two == 0 and grp.count == 2
    threes += 1 if three == 0 and grp.count == 3
  end
  twos += two
  threes += three
end
print twos * threes