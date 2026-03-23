# Changelog

## [0.1.2] - 2026-03-22

### Changed
- Added runtime dependencies on all 7 legion sub-gems (legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, legion-transport) with minimum version constraints
- Updated spec_helper to require sub-gem helpers and define real Helpers::Lex stub with all 7 includes

## [0.1.0] - 2026-03-21

### Added
- Initial release
- `Runners::Chat` with `create` method for chat completions via xAI Grok API
- `Runners::Models` with `list` and `retrieve` methods
- `Runners::Embeddings` with `create` method
- `Helpers::Client` Faraday connection builder with Bearer token auth
- Standalone `Client` class including all runner modules
