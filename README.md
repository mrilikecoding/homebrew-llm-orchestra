# LLM Orchestra Homebrew Tap

This tap provides the LLM Orchestra formula for Homebrew.

## Installation

```bash
brew tap mrilikecoding/llm-orchestra
brew install llm-orchestra
```

## Usage

After installation, you can use the `llm-orc` command:

```bash
llm-orc --help
llm-orc auth setup
llm-orc list-ensembles
```

## Features

LLM Orchestra is a multi-agent LLM communication system with ensemble orchestration that provides:

- **Multi-Agent Ensembles**: Coordinate specialized agents for different aspects of analysis
- **Cost Optimization**: Mix expensive and free models based on what each task needs
- **CLI Interface**: Simple commands with piping support
- **Secure Authentication**: Encrypted API key storage with easy credential management
- **YAML Configuration**: Easy ensemble setup with readable config files
- **Usage Tracking**: Token counting, cost estimation, and timing metrics

## About

- **Homepage**: https://github.com/mrilikecoding/llm-orc
- **Documentation**: https://github.com/mrilikecoding/llm-orc#readme
- **License**: MIT

## Support

For issues and questions, please visit the [GitHub repository](https://github.com/mrilikecoding/llm-orc/issues).