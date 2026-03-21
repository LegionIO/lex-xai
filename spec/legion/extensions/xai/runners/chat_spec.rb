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
  end
end
