require 'spec_helper'

describe Swarm::File::Splitter do
  let(:invalid_file) { 'does_not_exist' }
  let(:valid_file) { 'spec/factories/test.csv' }

  context '#new' do
    it 'raises an error if no arguments are given' do
      expect { subject }.to raise_error(ArgumentError, 'missing keyword: file_name')
    end

    it 'raises an error if file does not exists' do
      expect { described_class.new(file_name: invalid_file) }.to raise_error(ArgumentError, "File 'does_not_exist' doesn't exist")
    end

    it 'does not raise an error if a valid argument is given' do
      expect { described_class.new(file_name: valid_file) }.not_to raise_error
    end
  end
end
