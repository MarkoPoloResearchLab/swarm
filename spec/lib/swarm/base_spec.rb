require 'spec_helper'

describe Swarm::Base do
  let(:valid_chunks_mq_name) { 'chunks' }
  let(:valid_results_mq_name) { 'results' }
  context '#new' do
    it 'raises an error if no arguments are given' do
      expect { subject }.to raise_error(ArgumentError, 'missing keywords: chunks_mq_name, results_mq_name')
    end

    it 'does not raise an error if valid arguments are passed' do
      expect { described_class.new(chunks_mq_name: valid_chunks_mq_name, results_mq_name: valid_results_mq_name) }.not_to raise_error
    end
  end
end
