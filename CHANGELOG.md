# Changelog

## [Unreleased]

### Added
- Credential-only identity module for Phase 8 Broker integration (`Identity` module with `provide_token`)

## [0.1.4] - 2026-03-31

### Added
- Standardized `usage:` key in `Runners::Chat#create` and `Runners::Embeddings#create` return hashes with `input_tokens`, `output_tokens`, `cache_read_tokens`, and `cache_write_tokens` fields for consumption by legion-llm's CostEstimator and metering

## [0.1.3] - 2026-03-30

### Changed
- update to rubocop-legion 0.1.7, resolve all offenses

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
