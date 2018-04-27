# frozen_string_literal: true

module Transifex
  module RestAPI
    # Transifex "New API", which adhers to the standard REST patterns
    # As of March 2018, these endpoints are documented
    #   GET api.transifex.com/organizations/
    #   GET api.transifex.com/organizations/:SLUG/projects/:SLUG/resources/
    #   GET api.transifex.com/organizations/:SLUG/projects/:SLUG/resources/?language_code=tlh
    #   GET api.transifex.com/organizations/:SLUG/projects/:SLUG/resources/?limit=20&offset=20
    #   GET api.transifex.com/organizations/:SLUG/projects/:SLUG/resources/:SLUG
    class Resource
      include Transifex::RestAPI::Node
      include Transifex::RestAPI::CrudRequests::Fetch

      class << self
        def resource_collection(parent_node = nil)
          Transifex::RestAPI::Resource.new(nil, parent_node)
        end

        def resource_node(node_slug, parent_node = nil)
          raise(MissingParametersError, 'Resource.new requires a slug parameter') if node_slug.nil?
          Transifex::RestAPI::Resource.new(node_slug, parent_node)
        end
      end

      private

      def initialize(slug, parent_node)
        super('resources', slug, parent_node)
      end
    end
  end
end
