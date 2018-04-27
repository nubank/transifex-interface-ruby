require "spec_helper"

class TestNode
  include Transifex::RestAPI::Node
end

describe Transifex::RestAPI::Node do
  describe 'Instantiate a REST node' do
    it 'should create a node for a collection' do
      node = TestNode.new('homogenous_list')
      expect(node.rest_url).to eq '/homogenous_list/'
    end

    it 'should create a node for an element' do
      node = TestNode.new('banana', 'slug')
      expect(node.rest_url).to eq '/banana/slug/'
    end

    it 'should form a heirarchy of nodes' do
      node = TestNode.new('quirks', nil,
                          TestNode.new('inventors', 'Edison',
                                       TestNode.new('people', 'men',
                                                    TestNode.new('beings', 'human'))))
      expect(node.rest_url).to eq '/beings/human/people/men/inventors/Edison/quirks/'
    end
  end
end
