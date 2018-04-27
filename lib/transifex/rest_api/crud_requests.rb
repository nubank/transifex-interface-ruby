# frozen_string_literal: true

module Transifex
  module RestAPI
    # CRUD requests using Transifex 'new API' endpoints. This overrides the exisnting
    # Transifex::CrudRequests.generate_url to work with nodes and create URLs in the standard
    # REST pattern. For example
    #      collection: /organizations/:SLUG/projects/:SLUG/resources/
    #            node: /organizations/:SLUG/projects/:SLUG/resources/:SLUG/
    #   parameterized: /organizations/:SLUG/projects/:SLUG/resources/?language_code=tlh
    module CrudRequests
      include Transifex::CrudRequests::Fetch

      class << self
        # create URL in RESTful format, sans root (api.transifex.com/organizations/:SLUG)
        def generate_url(node, params = {})
          raise(MissingParametersError, 'node') if node.nil?
          append_url_options(node.rest_url, params)
        end

        def append_url_options(url, options = {})
          return url if options.empty?
          uri = URI(url)
          decoded_uri = URI.decode_www_form(uri.query || '')
          options.each { |param|
            decoded_uri << [param[0], param[1]]
          }
          uri.query = URI.encode_www_form(decoded_uri)
          uri.to_s
        end
      end

      module Fetch
        module InstanceMethods
          def fetch(options = {})
            url = CrudRequests.generate_url(self, options)
            Transifex.query_api(:get, url, {}, true)
          end
        end
        def self.included(receiver)
          receiver.send(:include, InstanceMethods)
        end
      end
    end
  end
end
