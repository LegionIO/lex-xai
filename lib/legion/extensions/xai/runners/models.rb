# frozen_string_literal: true

require 'legion/extensions/xai/helpers/client'

module Legion
  module Extensions
    module Xai
      module Runners
        module Models
          extend Legion::Extensions::Xai::Helpers::Client

          def list(api_key:, **)
            response = client(api_key: api_key, **).get('/v1/models')
            { models: response.body }
          end

          def retrieve(api_key:, model:, **)
            response = client(api_key: api_key, **).get("/v1/models/#{model}")
            { model: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
