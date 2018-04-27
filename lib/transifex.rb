# frozen_string_literal: true

require 'net/http'
require 'multi_json'
require 'yaml'
require 'uri'
require 'digest/md5'

require 'transifex/version'
require 'transifex/resource_components/translation_components/utilities'
require 'transifex/crud_requests'
require 'transifex/errors'
require 'transifex/formats'
require 'transifex/project'
require 'transifex/projects'
require 'transifex/json'
require 'transifex/languages'
require 'transifex/language'
require 'transifex/project_components/language'
require 'transifex/project_components/language_components/coordinators'
require 'transifex/project_components/language_components/reviewers'
require 'transifex/project_components/language_components/translators'
require 'transifex/project_components/languages'
require 'transifex/resource'
require 'transifex/resource_components/content'
require 'transifex/resource_components/source'
require 'transifex/resource_components/stats'
require 'transifex/resource_components/translation'
require 'transifex/resource_components/translation_components/string'
require 'transifex/resource_components/translation_components/strings'
require 'transifex/resources'

require 'transifex/rest_api/crud_requests'
require 'transifex/rest_api/node'
require 'transifex/rest_api/resource'
require 'transifex/rest_api/project'

module Transifex
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield configuration
    end

    def build_request_url(rest_api, url = '')
      if rest_api
        URI(self.configuration.root_rest_url + url)
      else
        URI(self.configuration.root_url + url)
      end
    end

    def query_api(method, url, params = {}, rest_api = false)
      uri = build_request_url(rest_api, url)

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP.const_get(method.capitalize).new(uri.request_uri, request_headers)
        req.basic_auth self.configuration.client_login, self.configuration.client_secret
        req.body = Transifex::JSON.dump(params)
        http.request req
      end

      begin
        data = Transifex::JSON.load(res.body.nil? ? '' : res.body)
      rescue
        data = res.body
      end

      unless (res.is_a? Net::HTTPOK) || (res.is_a? Net::HTTPCreated) || (res.is_a? Net::HTTPNoContent)
        error = TransifexError.new(uri, res.code, data)
        raise error
      end

      data
    end

    def request_headers
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'User-Agent' => "Transifex-interface-ruby/#{Transifex::VERSION}"
      }
    end
  end

  class Configuration
    attr_accessor :client_login, :client_secret, :root_url, :root_rest_url, :organization

    def root_url
      @root_url ||= 'https://www.transifex.com/api/2'
    end

    def root_rest_url
      @root_rest_url ||= "https://api.transifex.com/organizations/#{self.organization}"
    end
  end
end
