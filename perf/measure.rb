require 'time'
require 'benchmark'
require_relative '../lib/tuple_map'
require_relative '../lib/hash_map'

rounds = 5 # To get averages for each size
stats = {
  TupleMap => {ops_count: 150, operations: {}},
  HashMap  => {ops_count: 100_000, operations: {}},
  Hash     => {ops_count: 100_000, operations: {}},
}
test_klasses = stats.keys

# Run a bunch of benchmarks and build up data for averaging. This code is
# ugly! :( Some esplainin':
# - 'ops_count' is how many operations to do when benchmarking. Eg, if we do 10
# writes each time, our hash size during the benchmarking will be 10, 20, 30...
# Thus we see how the class performs at different sizes: does it take longer
# and longer to do 10 writes (or reads)? This number is much smaller for
# TupleMap precisely because it scales poorly.
# - 'iterations' is how many different sizes we measure. Eg, if 'ops_count' is
# 10 and 'iterations' is 5, we'll measure at 10, 20, 30, 40, and 50.
# - 'rounds' is how many times to run through all those sizes. Eg, if we
# do 5 rounds, we'll have 5 measurements at size 10, 5 at size 20...
# This lets us compute an average for each size

test_klasses.each do |map_klass|
  GC.start unless map_klass == test_klasses.first # Clean up from the last time
  rounds.times do |round|
    hash    = map_klass.new
    count = 0
    ops_count = stats.fetch(map_klass).fetch(:ops_count)
    iterations = 100
    iterations.times do |iteration|
      puts "round #{round + 1} of #{rounds}; iteration #{iteration + 1} of #{iterations}"
      results = Benchmark.bm do |benchmark|
        # Manually gather up times (for Rbx compatibility)
        [].tap { |benchmarks|
          # Ensure GC doesn't run during benchmarking
          GC.disable
          benchmarks << benchmark.report("writes") do
            ops_count.times { |i| hash[count] = count; count += 1; }
          end
          GC.enable
          GC.disable
          read_keys = ops_count.times.map { rand(0...count) }
          benchmarks << benchmark.report("reads") do
            read_keys.each { |key| hash[key] }
          end
          GC.enable
        }
      end

      results.each do |result|
        stats[map_klass][:operations][result.label] ||= Hash.new { |h, k| h[k] = [] }
        stats[map_klass][:operations][result.label][count] << result.total
      end

    end

  end
end

# Get averages
stats.each do |klass, klass_data|
  puts klass_data.inspect
  klass_data[:operations].each do |op_name, op_data| #eg, 'reads'
    op_data.each do |iterations, times|
      op_data[iterations] = ((times.reduce(0) { |total, time| total + time }) / times.count)
    end
  end
end
 
puts "Writing performance data into 'perf/data'..."
Dir.chdir('perf') do
  Dir.mkdir('data') unless Dir.exist?('data')
  Dir.chdir('data') do
    dirname = Time.now.strftime("%Y-%m-%d_%H-%M-%S-#{RUBY_ENGINE}-#{RUBY_VERSION}")
    Dir.mkdir(dirname)
    Dir.chdir(dirname) do
      stats.each do |klass, klass_data|
        File.open("#{klass.name}.txt", 'w') do |f|
          f.write(klass_data)
        end
      end
    end
  end
end
