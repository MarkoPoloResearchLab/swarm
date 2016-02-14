require 'spec_helper'

describe Swarm::Chunk do
  let(:invalid_size) { -200 }
  let(:valid_size) { 2000 }

  context '#new' do
    it 'raises an error if no arguments are given' do
      expect { subject }.to raise_error(ArgumentError, 'missing keyword: total_size')
    end

    it 'raises an error if total_size is less than zero' do
      expect { described_class.new(total_size: invalid_size) }.to raise_error(ArgumentError, ':total_size must be greater than 0')
    end

    it 'does not raise an error if a valid argument is given' do
      expect { described_class.new(total_size: valid_size) }.not_to raise_error
    end
  end

  context '#next' do
    let(:valid_instance) { described_class.new(total_size: valid_size) }

    it 'raises an error if no arguments are given' do
      expect { valid_instance.next }.to raise_error(ArgumentError, 'missing keywords: position, buffer_size')
    end
  end

  context '#to_hash' do
    it 'returns a hash'
  end
end
