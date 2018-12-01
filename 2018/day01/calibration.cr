# Starting with a frequency of zero, what is the resulting frequency after all
# of the changes in frequency have been applied?
current_frequency = 0
File.read_lines("./data/input.txt").each do |frequency_data|
  current_frequency += frequency_data.to_i
end

puts current_frequency
