# frozen_string_literal: true

RSpec.describe Legion::Extensions::Xai::Runners::Models do
  let(:test_class) do
    Class.new do
      include Legion::Extensions::Xai::Runners::Models

      def client(**)
        Legion::Extensions::Xai::Helpers::Client.client(**)
      end
    end
  end
  let(:instance) { test_class.new }
  let(:api_key) { 'test-xai-key' }

  let(:faraday_conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(faraday_conn)
  end

  describe '#list' do
    let(:list_response) do
      instance_double(Faraday::Response, body: {
                        'object' => 'list',
                        'data'   => [
                          { 'id' => 'grok-3', 'object' => 'model' },
                          { 'id' => 'grok-2', 'object' => 'model' }
                        ]
                      }, status: 200)
    end

    it 'lists available models' do
      allow(faraday_conn).to receive(:get).with('/v1/models').and_return(list_response)

      result = instance.list(api_key: api_key)

      expect(result).to have_key(:models)
      expect(result[:models]['data'].length).to eq(2)
    end

    it 'returns the response body under :models key' do
      allow(faraday_conn).to receive(:get).with('/v1/models').and_return(list_response)

      result = instance.list(api_key: api_key)

      expect(result[:models]['object']).to eq('list')
    end
  end

  describe '#retrieve' do
    let(:model_response) do
      instance_double(Faraday::Response, body: {
                        'id'      => 'grok-3',
                        'object'  => 'model',
                        'created' => 1_700_000_000
                      }, status: 200)
    end

    it 'retrieves a specific model' do
      allow(faraday_conn).to receive(:get).with('/v1/models/grok-3').and_return(model_response)

      result = instance.retrieve(api_key: api_key, model: 'grok-3')

      expect(result).to have_key(:model)
      expect(result[:model]['id']).to eq('grok-3')
    end

    it 'encodes the model name in the URL path' do
      allow(faraday_conn).to receive(:get).with('/v1/models/grok-2').and_return(model_response)

      instance.retrieve(api_key: api_key, model: 'grok-2')
    end

    it 'returns a hash with a :model key' do
      allow(faraday_conn).to receive(:get).with('/v1/models/grok-3').and_return(model_response)

      result = instance.retrieve(api_key: api_key, model: 'grok-3')
      expect(result).to be_a(Hash)
      expect(result).to have_key(:model)
    end
  end
end
