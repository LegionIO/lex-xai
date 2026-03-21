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
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
