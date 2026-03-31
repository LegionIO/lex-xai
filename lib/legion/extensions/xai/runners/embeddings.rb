# frozen_string_literal: true

require 'legion/extensions/xai/helpers/client'

module Legion
  module Extensions
    module Xai
      module Runners
        module Embeddings
          extend Legion::Extensions::Xai::Helpers::Client

          def create(api_key:, input:, model: 'embedding-beta', **)
            body = { model: model, input: input }

            response = client(api_key: api_key, **).post('/v1/embeddings', body)
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
