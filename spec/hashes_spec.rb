require_relative 'spec_helper'
require_relative '../lib/tuple_map'

shared_examples_for "basic hash features" do

  let(:hash) { described_class.new }

  describe "usable keys" do

    it "can use a string key" do
      key       = 'zepplin'
      val       = 'grammophone'
      hash[key] = val
      expect(hash[key]).to eq(val)
    end

  end

  describe "overwriting" do

    it "can overwrite a key" do
      key = 'plosion'
      hash[key] = 'explosion'
      hash[key] = 'implosion'
      expect(hash[key]).to eq('implosion')
    end

  end

  describe "deletion" do

    it "can delete keys" do
      key1 = 'leumur'
      key2 = 'mongoose'
      hash[key1]    = 'pete'
      hash[key2] = 'larry'
      deleted_val = hash.delete(key1)
      expect(deleted_val).to eq('pete')
      expect(hash.keys).to eq([key2])
    end

  end

  describe "keys and values" do

    let(:a) { 'a' }
    let(:b) { 'b' }
    let(:c) { 'c' }
    let(:d) { 'd' }

    let(:hash) {
      described_class.new.tap { |h|
        h[a] = 'hi'
        h[b] = 'ho'
        h[c] = nil
      }
    }

    it "can tell whether it has a key" do
      expect(hash.has_key?(a)).to be_true
      expect(hash.has_key?(c)).to be_true
      expect(hash.has_key?(d)).to be_false
    end

    it "can return the keys" do
      expect(hash.keys).to eq([a, b, c])
    end

    it "can return the values" do
      expect(hash.values).to eq(['hi', 'ho', nil])
    end

  end

end

describe Hash do
  it_has "basic hash features"
end

describe TupleMap do
  it_has "basic hash features"
end

