#  i. Starting with a frequency of zero, what is the resulting frequency after
#     all of the changes in frequency have been applied?
# ii. What is the first frequency your device reaches twice?
current_frequency = 0

first_iteration_sum = 0 # Part II Answer

frequency_instance_counter = {} of Int32 => Int32
first_frequency_double = nil

i = 0

while first_frequency_double == nil
  frequency_instance_counter[0] = 1

  File.read_lines("./data/input.txt").each do |frequency_data|
    current_frequency += frequency_data.to_i

    if frequency_instance_counter[current_frequency]?
      frequency_instance_counter[current_frequency] += 1
      unless first_frequency_double != nil
        first_frequency_double = current_frequency.to_i
      end
    else
      frequency_instance_counter[current_frequency] = 1
    end
  end

  if i == 0
    first_iteration_sum = current_frequency
  end

  i += 1
end

puts "Final frequency (first iteration):  #{first_iteration_sum}."
puts "Final frequency (final iteration):  #{current_frequency}."
puts "First double frequency encountered: #{first_frequency_double}."
puts "Completed in: #{i} iterations 🏁"
