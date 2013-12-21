require 'gruff'
require_relative 'number_humanizer'

unless Dir.exist?('perf/data')
  puts "No data - run measure.rb first"
  exit
end

Dir.foreach('perf/data') do |data_directory|
  next if data_directory == '.' or data_directory == '..'

  Dir.chdir("perf/data/#{data_directory}") do
    Dir.glob("*.txt") do |data_file|

      klass_name = data_file.split('.')[0]
      # puts "would write #{klass_name}.png in #{data_directory}"

      g = Gruff::Line.new
      g.title = "Ops for #{klass_name}"

      # Oh noes, eval! :)
      stats = eval(File.read(data_file))
      sizes = stats[:operations]['reads'].keys
      g.labels = sizes.each_with_index.reduce({}) { |hash, tuple|
        ordinal = sizes.count / 6 # number of desired labels on x axis
        count, index = tuple; hash.tap { |h| h[index] = NumberHumanizer.humanize(count) if index % ordinal == 0 }
      }
      humanized_number = NumberHumanizer.humanize(stats.fetch(:ops_count))
      g.data :"#{humanized_number} Reads",  stats[:operations]['reads'].values
      g.data :"#{humanized_number} Writes", stats[:operations]['writes'].values

      # Give charts a sane range
      g.maximum_value = 1.5 if klass_name == 'HashMap'
      g.minimum_value = 0

      filename = "#{klass_name}.png"
      g.write(filename)
      puts "made #{filename} in perf/data/#{data_directory}"
    end

  end
end
