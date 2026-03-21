# frozen_string_literal: true

require 'legion/extensions/xai/helpers/client'
require 'legion/extensions/xai/runners/chat'
require 'legion/extensions/xai/runners/models'
require 'legion/extensions/xai/runners/embeddings'

module Legion
  module Extensions
    module Xai
      class Client
        include Legion::Extensions::Xai::Runners::Chat
        include Legion::Extensions::Xai::Runners::Models
        include Legion::Extensions::Xai::Runners::Embeddings

        attr_reader :config

        def initialize(api_key:, base_url: Helpers::Client::DEFAULT_BASE_URL, **opts)
          @config = { api_key: api_key, base_url: base_url, **opts }
        end

        private

        def client(**override_opts)
          merged = config.merge(override_opts)
          Legion::Extensions::Xai::Helpers::Client.client(**merged)
        end
      end
    end
  end
end
