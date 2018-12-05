encountered = {}

frequencies = 
  open("input.txt") do |f|
    f.readlines
  end

found = false
current_freq = 0
while not found do
  frequencies.each do |freq|
    if encountered[current_freq].nil?
      encountered[current_freq] = 1
      current_freq += freq.to_i
    else
      puts "Encountered: " + current_freq.to_s
      found = true
      break
    end
  end
end