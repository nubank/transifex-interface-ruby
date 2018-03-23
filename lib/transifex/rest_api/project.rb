# frozen_string_literal: true

module Transifex
  module RestAPI
    # Transifex "New API", which adhers to the standard REST patterns
    # As of March 2018, these two endpoints are working and in Beta.
    #   GET api.transifex.com/organizations/:SLUG/projects/
    #   GET api.transifex.com/organizations/:SLUG/projects/:SLUG
    #
    # Note: although in beta and they could yet change, these endpoints and their behavior seem
    # well-formed and of low risk for significant change. They also save us a ton of HTTP requests
    # and sync performance has been an issue.
    #
    class Project
      include Transifex::RestAPI::Node
      include Transifex::RestAPI::CrudRequests::Fetch

      class << self
        def project_collection(parent_node = nil)
          Transifex::RestAPI::Project.new(nil, parent_node)
        end

        def project_node(node_slug, parent_node = nil)
          raise(MissingParametersError, 'Project.new requires a slug parameter') if node_slug.nil?
          Transifex::RestAPI::Project.new(node_slug, parent_node)
        end
      end

      private

      def initialize(slug, parent_node)
        super('projects', slug, parent_node)
      end
    end
  end
end
