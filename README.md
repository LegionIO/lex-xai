# lex-xai

LegionIO extension for the [xAI Grok API](https://docs.x.ai).

## Installation

Add to your Gemfile:

```ruby
gem 'lex-xai'
```

## Usage

### Standalone Client

```ruby
require 'legion/extensions/xai/client'

client = Legion::Extensions::Xai::Client.new(api_key: 'your-xai-api-key')

# Chat completions
result = client.create(messages: [{ role: 'user', content: 'Hello!' }])

# List models
result = client.list

# Retrieve a model
result = client.retrieve(model: 'grok-3')

# Create embeddings
result = client.create(input: 'Hello world')
```

### Runner Modules

```ruby
include Legion::Extensions::Xai::Runners::Chat

result = create(api_key: 'your-key', messages: [{ role: 'user', content: 'Hello!' }])
```

## API Coverage

| Runner | Methods |
|--------|---------|
| `Chat` | `create` |
| `Models` | `list`, `retrieve` |
| `Embeddings` | `create` |

## License

MIT
