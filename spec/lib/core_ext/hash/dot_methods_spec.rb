require 'spec_helper'

require 'core_ext/hash/dot_methods'

describe CoreExtensions::DotMethods do
  let(:nested_hash) { { c: { d: 1, e: 5 }, f: { d: 1, e: 5 }, g: { h: { d: 1, e: 5 } } } }

  describe '#.' do
    it 'responds to the keys in the first layer' do
      expect(nested_hash.respond_to?(:c)).to be true
    end

    it 'returns the value of a key in the first layer' do
      expect(nested_hash.c).to eq({ d: 1, e: 5 })
    end

    it 'responds to nested layer of keys' do
      expect(nested_hash.c.respond_to?(:d)).to be true
    end

    it 'returns the value of a nested key' do
      expect(nested_hash.c.d).to eq(1)
    end
  end
end
