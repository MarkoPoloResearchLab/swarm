require 'spec_helper'

require 'core_ext/hash/deep_search'
using CoreExtensions::DeepSearch

describe CoreExtensions::DeepSearch do
  let(:nested_hash) { { c: { d: 1, e: 5 }, f: { d: 1, e: 5 }, g: { h: { d: 1, e: 5 } } } }

  describe '#all' do
    it 'responds to #all method' do
      expect(nested_hash.respond_to?(:all)).to be true
    end

    it 'returns an empty array when a key is not found' do
      expect(nested_hash.all(:q)).to eq([])
    end

    it 'returns an array of found values' do
      expect(nested_hash.merge(h: true).all(:h)).to eq([{ d: 1, e: 5 }, true])
    end

    it 'returns an array of found values when a key is found' do
      expect(nested_hash.all(:d)).to eq([1, 1, 1])
    end

    it 'recognizes keys with question marks' do
      expect(nested_hash.merge(last?: true).all(:last?)).to eq([true])
    end
  end

  describe '#where' do
    it 'responds to #where method' do
      expect(nested_hash.respond_to?(:where)).to be true
    end

    it 'returns an empty array when a hash with a given key/value pair was not found' do
      expect(nested_hash.where(d: 3)).to eq([])
    end

    it 'returns an empty array when a hash with given key/value pairs was not found' do
      expect(nested_hash.where(d: 1, e: 4)).to eq([])
    end

    it 'returns an empty array when one of the key/value pairs does not exist' do
      expect(nested_hash.where(d: 1, e: 5, f: 5)).to eq([])
    end

    it 'finds all nested hashes with a given key/value pair' do
      expect(nested_hash.where(d: 1)).to eq([{ d: 1, e: 5 }, { d: 1, e: 5 }, { d: 1, e: 5 }])
    end

    it 'recognizes keys with question marks' do
      expect(nested_hash.merge(q: { last?: true, b: 1 }).where(last?: true)).to eq([{ last?: true, b: 1 }])
    end
  end
end
