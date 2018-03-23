require "spec_helper"

describe Transifex::RestAPI::Resource do
  describe 'Instantiate a resource collection node' do
    it 'should create a node for a collection' do
      resource = Transifex::RestAPI::Resource.resource_collection
      expect(resource.rest_url).to eq '/resources/'
    end
  end

  describe 'Instantiate a resource node' do
    it 'should create a node for a resource' do
      resource = Transifex::RestAPI::Resource.resource_node('res_slug')
      expect(resource.rest_url).to eq '/resources/res_slug/'
    end

    it 'should raise an error when the slug property is nil' do
      expect { Transifex::RestAPI::Resource.resource_node(nil) }
        .to raise_error(Transifex::MissingParametersError)
    end

    it 'should raise an error when the slug property is not provided' do
      expect { Transifex::RestAPI::Resource.resource_node }
        .to raise_error(ArgumentError)
    end
  end

  describe 'Get remote resources' do
    it 'should fetch a list of resource' do
      VCR.use_cassette('rest_api/resource/get_resource_list') do
        project_node = Transifex::RestAPI::Project.project_node('x93nR3ebyL4')
        resource_node = Transifex::RestAPI::Resource.resource_collection(project_node)
        data = resource_node.fetch
        expect(data.first.keys).to eq(%w[id slug name priority i18n_type stringcount wordcount categories created last_update accept_translations stats])
      end
    end

    it 'should fetch a single resource' do
      VCR.use_cassette('rest_api/resource/get_resource') do
        project_node = Transifex::RestAPI::Project.project_node('x93nR3ebyL4')
        resource_node = Transifex::RestAPI::Resource.resource_node('fiWPsorUor4', project_node)
        data = resource_node.fetch
        expect(data.keys).to start_with(%w[id slug name priority i18n_type stringcount wordcount categories created last_update accept_translations stats])
      end
    end
  end
end
