class Critter < Struct.new(:family, :genus, :species)

  # We really don't care what species it is
  def hash
    (family.hash + genus.hash) / 2
  end

  # We really don't care what species it is
  def eql?(other)
    return false unless other.class == self.class
    other.family == family && other.genus == genus
  end

  alias_method :==, :eql?

end
