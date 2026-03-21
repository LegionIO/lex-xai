# frozen_string_literal: true

require 'legion/extensions/xai/client'

RSpec.describe Legion::Extensions::Xai::Client do
  let(:api_key) { 'test-xai-key' }
  let(:client) { described_class.new(api_key: api_key) }
  let(:faraday_conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(faraday_conn)
  end

  it 'stores config on initialization' do
    expect(client.config[:api_key]).to eq(api_key)
    expect(client.config[:base_url]).to eq(Legion::Extensions::Xai::Helpers::Client::DEFAULT_BASE_URL)
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
end
