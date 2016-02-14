require 'spec_helper'

describe Swarm::Dispatcher do
  let(:valid_chunks_mq_name) { 'chunks' }
  let(:valid_results_mq_name) { 'results' }
  let(:valid_splitter) { instance_double('Splitter', each: { unique_key: :file_name, file_name: 'qqq' }) }
  let(:invalid_splitter) { instance_double('Splitter') }

  context '#new' do
    it 'raises an error if no arguments are given' do
      expect { subject }.to raise_error(ArgumentError, ':splitter is a required argument')
    end

    it 'raises an error if splitter does not respond to :each' do
      expect { described_class.new(splitter: invalid_splitter, chunks_mq_name: valid_chunks_mq_name, results_mq_name: valid_results_mq_name) }.to raise_error(ArgumentError, 'Splitter must respond to :each')
    end

    it 'does not raise an error if valid arguments are passed' do
      expect { described_class.new(splitter: valid_splitter, chunks_mq_name: valid_chunks_mq_name, results_mq_name: valid_results_mq_name) }.not_to raise_error
    end
  end
end
