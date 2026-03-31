# frozen_string_literal: true

RSpec.describe Legion::Extensions::Xai::Runners::Embeddings do
  let(:test_class) do
    Class.new do
      include Legion::Extensions::Xai::Runners::Embeddings

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

  describe '#create' do
    let(:embedding_response) do
      instance_double(Faraday::Response, body: {
                        'object' => 'list',
                        'data'   => [
                          { 'object' => 'embedding', 'index' => 0, 'embedding' => [0.1, 0.2, 0.3] }
                        ],
                        'model'  => 'embedding-beta',
                        'usage'  => { 'prompt_tokens' => 3, 'completion_tokens' => 0, 'total_tokens' => 3 }
                      }, status: 200)
    end

    let(:no_usage_response) do
      instance_double(Faraday::Response, body: {
                        'object' => 'list',
                        'data'   => [
                          { 'object' => 'embedding', 'index' => 0, 'embedding' => [0.1, 0.2, 0.3] }
                        ],
                        'model'  => 'embedding-beta'
                      }, status: 200)
    end

    it 'creates embeddings with default model' do
      allow(faraday_conn).to receive(:post)
        .with('/v1/embeddings', hash_including(model: 'embedding-beta', input: 'Hello world'))
        .and_return(embedding_response)

      result = instance.create(api_key: api_key, input: 'Hello world')

      expect(result).to have_key(:result)
      expect(result[:result]['data'].first['embedding']).to eq([0.1, 0.2, 0.3])
    end

    it 'creates embeddings with a custom model' do
      allow(faraday_conn).to receive(:post)
        .with('/v1/embeddings', hash_including(model: 'embedding-v2'))
        .and_return(embedding_response)

      result = instance.create(api_key: api_key, model: 'embedding-v2', input: 'Hello world')

      expect(result).to have_key(:result)
    end

    it 'accepts array input' do
      allow(faraday_conn).to receive(:post)
        .with('/v1/embeddings', hash_including(input: %w[Hello World]))
        .and_return(embedding_response)

      result = instance.create(api_key: api_key, input: %w[Hello World])

      expect(result).to have_key(:result)
    end

    it 'returns a hash with a :usage key' do
      allow(faraday_conn).to receive(:post).and_return(embedding_response)

      result = instance.create(api_key: api_key, input: 'Hello world')
      expect(result).to have_key(:usage)
    end

    it 'maps prompt_tokens to input_tokens' do
      allow(faraday_conn).to receive(:post).and_return(embedding_response)

      result = instance.create(api_key: api_key, input: 'Hello world')
      expect(result[:usage][:input_tokens]).to eq(3)
    end

    it 'maps completion_tokens to output_tokens' do
      allow(faraday_conn).to receive(:post).and_return(embedding_response)

      result = instance.create(api_key: api_key, input: 'Hello world')
      expect(result[:usage][:output_tokens]).to eq(0)
    end

    it 'sets cache_read_tokens to 0' do
      allow(faraday_conn).to receive(:post).and_return(embedding_response)

      result = instance.create(api_key: api_key, input: 'Hello world')
      expect(result[:usage][:cache_read_tokens]).to eq(0)
    end

    it 'sets cache_write_tokens to 0' do
      allow(faraday_conn).to receive(:post).and_return(embedding_response)

      result = instance.create(api_key: api_key, input: 'Hello world')
      expect(result[:usage][:cache_write_tokens]).to eq(0)
    end

    it 'defaults usage tokens to 0 when usage is absent from the response' do
      allow(faraday_conn).to receive(:post).and_return(no_usage_response)

      result = instance.create(api_key: api_key, input: 'Hello world')
      expect(result[:usage][:input_tokens]).to eq(0)
      expect(result[:usage][:output_tokens]).to eq(0)
    end
  end
end
