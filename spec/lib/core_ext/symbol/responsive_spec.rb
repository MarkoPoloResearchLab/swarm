require 'spec_helper'

require 'core_ext/symbol/responsive'
using CoreExtensions::Responsive

describe CoreExtensions::Responsive do
  let(:nested_hash) { { c: { d: 1, e: 5 }, f: { d: 1, e: 5 }, g: { h: { d: 1, e: 5 } } } }

  describe '#~' do
    it 'tests ~ method'
  end
end
