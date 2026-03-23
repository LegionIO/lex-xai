# lex-xai: xAI Grok API Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-ai/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to the xAI Grok API. Provides runners for chat completions, embeddings, and model listing.

**GitHub**: https://github.com/LegionIO/lex-xai
**License**: MIT
**Version**: 0.1.0
**Specs**: 23 examples

## Architecture

```
Legion::Extensions::Xai
├── Runners/
│   ├── Chat           # create(api_key:, messages:, model: 'grok-3', ...)
│   ├── Embeddings     # create(api_key:, input:, model:, ...)
│   └── Models         # list(api_key:, ...), retrieve(api_key:, model:, ...)
├── Helpers/
│   └── Client         # Faraday-based xAI API client (module, factory method)
└── Client             # Standalone client class (includes all runners, holds @config)
```

`Helpers::Client` is a **module** with a `client(api_key:, base_url: DEFAULT_BASE_URL, ...)` factory method. `DEFAULT_BASE_URL` is `'https://api.x.ai'`. Authentication uses `Authorization: Bearer #{api_key}` header. Runner modules `extend` it to gain `client(...)` as a module-level method.

`Client` (class) provides a standalone instantiable wrapper that holds `@config` and delegates through `Helpers::Client`.

## Key Design Decisions

- Structurally identical to lex-openai and lex-claude (module-based `Helpers::Client`, `extend` in runners), but with no multipart dependency and no `multi_json` list in the gemspec for lex-openai parity — `multi_json` is listed as a dependency.
- Default model for `Chat#create` is `'grok-3'`.
- `Chat#create` supports `stream: false` kwarg (passed through to API body) but does not handle streaming responses internally.
- API paths use `/v1/` prefix: `/v1/chat/completions`, `/v1/models`, `/v1/models/:model`, `/v1/embeddings`.
- `Models#retrieve` uses the method name `retrieve` (not `get`) for consistency with lex-claude and lex-openai.
- `include Legion::Extensions::Helpers::Lex` is guarded with `const_defined?` pattern.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` >= 2.0 | HTTP client for xAI API |
| `multi_json` | JSON parser abstraction |

## Testing

```bash
bundle install
bundle exec rspec        # 23 examples
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
