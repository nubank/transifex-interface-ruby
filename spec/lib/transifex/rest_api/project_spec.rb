require "spec_helper"

describe Transifex::RestAPI::Project do
  describe 'Instantiate a project collection node' do
    it 'should create a node for a collection' do
      project = Transifex::RestAPI::Project.project_collection
      expect(project.rest_url).to eq '/projects/'
    end
  end

  describe 'Instantiate a project node' do
    it 'should create a node for a project' do
      project = Transifex::RestAPI::Project.project_node('proj_slug')
      expect(project.rest_url).to eq '/projects/proj_slug/'
    end

    it 'should raise an error when the slug property is nil' do
      expect { Transifex::RestAPI::Project.project_node(nil) }
        .to raise_error(Transifex::MissingParametersError)
    end

    it 'should raise an error when the slug property is not provided' do
      expect { Transifex::RestAPI::Project.project_node }
        .to raise_error(ArgumentError)
    end
  end

  describe 'Get remote projects' do
    it 'should fetch a list of projects' do
      VCR.use_cassette('rest_api/project/get_project_list') do
        data = Transifex::RestAPI::Project.project_collection.fetch
        expect(data.first.keys).to start_with(%w[id name languages slug tags total_resources source_language type logo_url])
      end
    end

    it 'should fetch a single project' do
      VCR.use_cassette('rest_api/project/get_project') do
        data = Transifex::RestAPI::Project.project_node('x93nR3ebyL4').fetch
        expect(data.keys).to start_with(%w[id name slug tags languages total_resources source_language type logo_url])
      end
    end
  end
end
