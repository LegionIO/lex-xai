# frozen_string_literal: true

require 'faraday'
require 'multi_json'

module Legion
  module Extensions
    module Xai
      module Helpers
        module Client
          DEFAULT_BASE_URL = 'https://api.x.ai'

          module_function

          def client(api_key:, base_url: DEFAULT_BASE_URL, **)
            Faraday.new(url: base_url) do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['Authorization'] = "Bearer #{api_key}"
              conn.headers['Content-Type'] = 'application/json'
            end
          end
        end
      end
    end
  end
end
