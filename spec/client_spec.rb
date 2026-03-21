# frozen_string_literal: true

require 'legion/extensions/xai/client'

RSpec.describe Legion::Extensions::Xai::Client do
  let(:api_key)      { 'test-xai-key' }
  let(:client)       { described_class.new(api_key: api_key) }
  let(:faraday_conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(faraday_conn)
  end

  it 'stores config on initialization' do
    expect(client.config[:api_key]).to eq(api_key)
    expect(client.config[:base_url]).to eq(Legion::Extensions::Xai::Helpers::Client::DEFAULT_BASE_URL)
  end

  it 'accepts a custom base_url' do
    c = described_class.new(api_key: api_key, base_url: 'https://custom.x.ai')
    expect(c.config[:base_url]).to eq('https://custom.x.ai')
  end

  it 'passes extra opts through to config' do
    c = described_class.new(api_key: api_key, timeout: 30)
    expect(c.config[:timeout]).to eq(30)
  end

  it 'responds to chat runner methods' do
    expect(client).to respond_to(:create)
  end

  it 'responds to model runner methods' do
    expect(client).to respond_to(:list)
    expect(client).to respond_to(:retrieve)
  end

  it 'responds to embeddings runner methods' do
    expect(client).to respond_to(:create)
  end

  describe '#list (models delegation)' do
    let(:response_body) { { 'data' => [{ 'id' => 'grok-3' }] } }
    let(:response)      { instance_double(Faraday::Response, body: response_body) }

    it 'delegates list to the Models runner' do
      allow(faraday_conn).to receive(:get).with('/v1/models').and_return(response)

      result = client.list(api_key: api_key)
      expect(result[:models]).to eq(response_body)
    end
  end

  describe '#retrieve (models delegation)' do
    let(:response_body) { { 'id' => 'grok-3', 'object' => 'model' } }
    let(:response)      { instance_double(Faraday::Response, body: response_body) }

    it 'delegates retrieve to the Models runner' do
      allow(faraday_conn).to receive(:get).with('/v1/models/grok-3').and_return(response)

      result = client.retrieve(api_key: api_key, model: 'grok-3')
      expect(result[:model]).to eq(response_body)
    end
  end
end
