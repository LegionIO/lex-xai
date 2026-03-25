# lex-xai

Legion Extension for the xAI Grok API.

## Purpose

Wraps the xAI Grok REST API as named runners consumable by any LegionIO task chain. Provides chat completions, embeddings, and model listing. Use this extension when you need direct access to the xAI API surface within the LEX runner/actor lifecycle. For simple chat/embed workflows, consider `legion-llm` instead.

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

## Related

- `lex-openai` — OpenAI integration (same structural pattern)
- `legion-llm` — High-level LLM interface across providers
- `extensions-ai/CLAUDE.md` — Architecture patterns shared across all AI extensions

## License

MIT
