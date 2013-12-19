require_relative 'spec_helper'
require_relative '../lib/tuple_map'
require_relative '../lib/hash_map'

shared_examples_for "basic hash features" do

  let(:hash) { described_class.new }

  describe "usable keys" do

    it "can use a string key" do
      key       = 'zepplin'
      val       = 'grammophone'
      hash[key] = val
      expect(hash[key]).to eq(val)
    end

    it "treats equivilent strings as the same key" do
      hash['woo'] = 'ha'
      expect(hash['woo']).to eq('ha')
    end

    it "can use a symbol key" do
      key       = :snakebeard
      hash[key] = 'radical'
      expect(hash[key]).to eq('radical')
    end

    it "differentiates string and symbol keys" do
      string = 'scuffle'
      symbol = :scuffle
      hash[string]  = 'gumption'
      hash[symbol]  = 'hollar'
      expect(hash[string]).to  eq('gumption')
      expect(hash[symbol]).to  eq('hollar')
    end

    describe "array keys" do

      it "can use an array key" do
        arrrrr         = [1, 2]
        hash[arrrrr] = "matey"
        expect(hash[arrrrr]).to eq("matey")
      end

      it "treats equivilent arrays as the same key" do
        arr1 = [1, 2]
        arr2 = [1, 2]
        hash[[arr1]] = 'uno, dos'
        expect(hash[[arr2]]).to eq('uno, dos')
      end

    end

    describe "generic object keys" do

      it "can use an Object key" do
        obj = Object.new
        hash[obj] = 'hoser'
        expect(hash[obj]).to eq('hoser')
      end

      it "distinguishes between Object keys" do
        obj  = Object.new
        obj2 = Object.new
        hash[obj]  = 'hoser'
        hash[obj2] = 'eh?'
        expect(hash[obj]).to eq('hoser')
        expect(hash[obj2]).to eq('eh?')
      end

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

describe HashMap do
  it_has "basic hash features"
end
