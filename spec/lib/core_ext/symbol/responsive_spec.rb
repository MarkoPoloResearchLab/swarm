require 'spec_helper'

require 'core_ext/symbol/responsive'
using CoreExtensions::Responsive

describe CoreExtensions::Responsive do
  let(:hash) { { d: 1, e: 5 } }

  describe '#~' do
    it 'returns true if a method is present' do
      expect(~:fetch === hash).to be_truthy
    end
  end
end
