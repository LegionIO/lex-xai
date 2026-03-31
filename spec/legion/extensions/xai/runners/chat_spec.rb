# frozen_string_literal: true

RSpec.describe Legion::Extensions::Xai::Runners::Chat do
  let(:test_class) do
    Class.new do
      include Legion::Extensions::Xai::Runners::Chat

      def client(**)
        Legion::Extensions::Xai::Helpers::Client.client(**)
      end
    end
  end
  let(:instance) { test_class.new }
  let(:api_key) { 'test-xai-key' }
  let(:messages) { [{ role: 'user', content: 'Hello' }] }

  let(:success_response) do
    instance_double(Faraday::Response, body: {
                      'id'      => 'chatcmpl-123',
                      'object'  => 'chat.completion',
                      'model'   => 'grok-3',
                      'choices' => [{ 'message' => { 'role' => 'assistant', 'content' => 'Hi!' } }],
                      'usage'   => { 'prompt_tokens' => 10, 'completion_tokens' => 5, 'total_tokens' => 15 }
                    }, status: 200)
  end

  let(:no_usage_response) do
    instance_double(Faraday::Response, body: {
                      'id'      => 'chatcmpl-456',
                      'object'  => 'chat.completion',
                      'model'   => 'grok-3',
                      'choices' => [{ 'message' => { 'role' => 'assistant', 'content' => 'Hi!' } }]
                    }, status: 200)
  end

  let(:faraday_conn) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(faraday_conn)
  end

  describe '#create' do
    it 'sends a chat completion request with default model' do
      allow(faraday_conn).to receive(:post)
        .with('/v1/chat/completions', hash_including(model: 'grok-3', messages: messages))
        .and_return(success_response)

      result = instance.create(api_key: api_key, messages: messages)

      expect(result[:result]['id']).to eq('chatcmpl-123')
      expect(result[:result]['choices'].first['message']['content']).to eq('Hi!')
    end

    it 'sends a chat completion request with a custom model' do
      allow(faraday_conn).to receive(:post)
        .with('/v1/chat/completions', hash_including(model: 'grok-2'))
        .and_return(success_response)

      result = instance.create(api_key: api_key, model: 'grok-2', messages: messages)

      expect(result).to have_key(:result)
    end

    it 'includes optional parameters when provided' do
      allow(faraday_conn).to receive(:post)
        .with('/v1/chat/completions', hash_including(max_tokens: 100, temperature: 0.7))
        .and_return(success_response)

      result = instance.create(api_key: api_key, messages: messages, max_tokens: 100, temperature: 0.7)

      expect(result).to have_key(:result)
    end

    it 'omits nil optional parameters' do
      allow(faraday_conn).to receive(:post) do |_path, body|
        expect(body).not_to have_key(:max_tokens)
        expect(body).not_to have_key(:temperature)
        success_response
      end

      instance.create(api_key: api_key, messages: messages)
    end

    it 'defaults stream to false' do
      allow(faraday_conn).to receive(:post)
        .with('/v1/chat/completions', hash_including(stream: false))
        .and_return(success_response)

      instance.create(api_key: api_key, messages: messages)
    end

    it 'allows stream to be set to true' do
      allow(faraday_conn).to receive(:post)
        .with('/v1/chat/completions', hash_including(stream: true))
        .and_return(success_response)

      result = instance.create(api_key: api_key, messages: messages, stream: true)
      expect(result).to have_key(:result)
    end

    it 'returns a hash with a :result key' do
      allow(faraday_conn).to receive(:post).and_return(success_response)

      result = instance.create(api_key: api_key, messages: messages)
      expect(result).to be_a(Hash)
      expect(result).to have_key(:result)
    end

    it 'returns a hash with a :usage key' do
      allow(faraday_conn).to receive(:post).and_return(success_response)

      result = instance.create(api_key: api_key, messages: messages)
      expect(result).to have_key(:usage)
    end

    it 'maps prompt_tokens to input_tokens' do
      allow(faraday_conn).to receive(:post).and_return(success_response)

      result = instance.create(api_key: api_key, messages: messages)
      expect(result[:usage][:input_tokens]).to eq(10)
    end

    it 'maps completion_tokens to output_tokens' do
      allow(faraday_conn).to receive(:post).and_return(success_response)

      result = instance.create(api_key: api_key, messages: messages)
      expect(result[:usage][:output_tokens]).to eq(5)
    end

    it 'sets cache_read_tokens to 0' do
      allow(faraday_conn).to receive(:post).and_return(success_response)

      result = instance.create(api_key: api_key, messages: messages)
      expect(result[:usage][:cache_read_tokens]).to eq(0)
    end

    it 'sets cache_write_tokens to 0' do
      allow(faraday_conn).to receive(:post).and_return(success_response)

      result = instance.create(api_key: api_key, messages: messages)
      expect(result[:usage][:cache_write_tokens]).to eq(0)
    end

    it 'defaults usage tokens to 0 when usage is absent from the response' do
      allow(faraday_conn).to receive(:post).and_return(no_usage_response)

      result = instance.create(api_key: api_key, messages: messages)
      expect(result[:usage][:input_tokens]).to eq(0)
      expect(result[:usage][:output_tokens]).to eq(0)
    end
  end
end
