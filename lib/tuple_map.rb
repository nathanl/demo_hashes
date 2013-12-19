class TupleMap

  def initialize
    self.data = []
  end

  def []=(key, value)
    tuple = tuple_with_key(key)
    if tuple
      tuple[1] = value
    else
      self.data << [key, value]
    end
  end

  def [](key)
    (tuple_with_key(key) || [])[1]
  end

  def keys
    data.map { |tuple| tuple[0] }
  end

  def values
    data.map { |tuple| tuple[1] }
  end

  def delete(key)
    index = data.index { |tuple| tuple[0].eql?(key) }
    return data.delete_at(index)[1] if index
  end

  def has_key?(key)
    keys.include?(key)
  end

  protected
  attr_accessor :data

  def tuple_with_key(key)
    data.detect { |tuple| tuple[0].eql?(key) }
  end

end
