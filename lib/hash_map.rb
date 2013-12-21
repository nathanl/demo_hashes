require 'prime'
require_relative 'tuple_map'
class HashMap

  attr_accessor :keys

  def initialize
    self.keys           = []
    self.max_size       = 199
    self.max_collisions = 10
  end

  def []=(key, value)
    self.internal_vals ||= Array.new(max_size)
    # Note: keys is more properly a Set, but it seems to have O(N) insertion time
    self.keys << key unless has_key?(key)

    digest = digest_of(key)
    existing_value = internal_vals[digest]
    # Be ready for hash collisions by always storing values in a TupleMap.
    # If we stored a bare value the first time, then got a collision, we
    # wouldn't know which key we'd collided with, so we'd be unable to build
    # the TupleMap at that point. Therefore, build it up front.
    case existing_value
    when nil
      internal_vals[digest] = TupleMap.new.tap { |h| h[key] = value }
    when TupleMap
      (existing_value[key] = value).tap { |val|
        redistribute if existing_value.length > max_collisions
      }
    end
  end

  def [](key)
    tuple_map = internal_vals[digest_of(key)]
    tuple_map.nil? ? nil : tuple_map[key]
  end

  def values
    keys.map {|k| internal_vals[digest_of(k)][k] }
  end

  def delete(key)
    return nil unless keys.include?(key)
    position = digest_of(key)
    internal_vals[position].delete(key).tap do
      keys.delete(key)
    end
  end

  def has_key?(key)
    value_index = digest_of(key)
    # If we've actually stored a value of nil, it (like any value) will be
    # inside a TupleMap
    return false if internal_vals[value_index].nil?
    internal_vals[value_index].keys.include?(key)
  end

  def length
    keys.length
  end

  protected

  attr_accessor :max_size, :max_collisions, :internal_vals

  private

  def digest_of(key)
    # The magic sauce
    raw_digest = key.hash
    raw_digest % max_size
  end

  # When we get too many collisions, we'll have to grow the hash. Double the
  # size and find the next prime number, to reduce the chances of having the
  # same hash collisions.
  def next_size
    primes.detect { |p| p > (max_size * 2) }
  end

  def primes
    @primes ||= Prime.each
  end

  def redistribute
    new_size       = next_size
    puts "whoops, time to redistribute! Bumping from #{max_size} to #{new_size}"
    other          = self.class.new
    other.max_size = new_size
    keys.each do |key|
      other[key]         = self[key]
    end
    self.internal_vals = other.internal_vals
    self.max_size      = new_size
    self
  end

end
