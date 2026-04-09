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

# Chat completions (default model: grok-3)
result = client.create(
  messages: [{ role: 'user', content: 'Hello!' }]
)
# => { result: { 'choices' => [...], ... } }

# With explicit model
result = client.create(
  model: 'grok-3',
  messages: [{ role: 'user', content: 'What is 2+2?' }]
)

# List models
result = client.list
# => { models: [...] }

# Retrieve a specific model
result = client.retrieve(model: 'grok-3')
# => { model: { ... } }

# Create embeddings (default model: embedding-beta)
result = client.create(
  input: 'Hello world'
)
# => { result: { 'data' => [...], ... } }
```

### Runner Modules

```ruby
result = Legion::Extensions::Xai::Runners::Chat.create(
  api_key: 'your-key',
  messages: [{ role: 'user', content: 'Hello!' }]
)

result = Legion::Extensions::Xai::Runners::Embeddings.create(
  api_key: 'your-key',
  input: 'text to embed'
)

result = Legion::Extensions::Xai::Runners::Models.list(api_key: 'your-key')
result = Legion::Extensions::Xai::Runners::Models.retrieve(api_key: 'your-key', model: 'grok-3')
```

## API Coverage

| Runner | Methods | Default Model |
|--------|---------|---------------|
| `Chat` | `create` | `grok-3` |
| `Embeddings` | `create` | `embedding-beta` |
| `Models` | `list`, `retrieve` | — |

## Dependencies

- `faraday` >= 2.0 - HTTP client
- `multi_json` - JSON parser abstraction

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework (optional for standalone client usage)
- xAI API key

## Related

- `lex-openai` — OpenAI integration (same structural pattern)
- `legion-llm` — High-level LLM interface across providers
- `extensions-ai/CLAUDE.md` — Architecture patterns shared across all AI extensions

## Version

0.1.4

## License

MIT
