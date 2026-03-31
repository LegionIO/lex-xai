# frozen_string_literal: true

require 'legion/extensions/xai/helpers/client'

module Legion
  module Extensions
    module Xai
      module Runners
        module Chat
          extend Legion::Extensions::Xai::Helpers::Client

          def create(api_key:, messages:, model: 'grok-3', max_tokens: nil, temperature: nil,
                     stream: false, **)
            body = { model: model, messages: messages, stream: stream }
            body[:max_tokens] = max_tokens if max_tokens
            body[:temperature] = temperature if temperature

            response = client(api_key: api_key, **).post('/v1/chat/completions', body)
            body = response.body
            {
              result: body,
              usage:  {
                input_tokens:       body.dig('usage', 'prompt_tokens') || 0,
                output_tokens:      body.dig('usage', 'completion_tokens') || 0,
                cache_read_tokens:  0,
                cache_write_tokens: 0
              }
            }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
