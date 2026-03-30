# frozen_string_literal: true

require 'legion/extensions/xai/version'
require 'legion/extensions/xai/helpers/client'
require 'legion/extensions/xai/runners/chat'
require 'legion/extensions/xai/runners/models'
require 'legion/extensions/xai/runners/embeddings'

module Legion
  module Extensions
    module Xai
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core, false
    end
  end
end
