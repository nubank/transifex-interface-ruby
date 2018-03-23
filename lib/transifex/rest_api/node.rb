# frozen_string_literal: true

module Transifex
  module RestAPI
    module Node
      attr_reader :collection_name, :node_slug
      attr_accessor :parent_node

      module InstanceMethods
        # Following REST convention, if node_id is nil, then a collection is implied for this node,
        # else a specific node.
        def initialize(collection_name, node_slug = nil, parent_node = nil)
          @collection_name = collection_name
          @node_slug = node_slug
          @parent_node = parent_node
        end

        # Creates a REST style url from this node up thru the highest parent
        # Example: given parent-child node sequence node1.node2.node3, where each node has a
        # node_slug property, calling node2.rest_url will return:
        #     /node1.collection_name/node1.node_slug/node2.collection_name/node2.node_slug/
        def rest_url
          # Transifex API doc says always use a trailing slash even if the last element is a slug
          build_nodes_url.to_s + '/'
        end

        # private

        def build_nodes_url(url = nil)
          url = @parent_node.build_nodes_url(url) unless @parent_node.nil?
          url = url.to_s + '/' + @collection_name
          url += '/' + @node_slug unless @node_slug.nil?
          url
        end
      end

      def self.included(receiver)
        receiver.send(:include, InstanceMethods)
      end
    end
  end
end
