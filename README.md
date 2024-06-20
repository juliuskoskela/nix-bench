# Nix-bench

`nix-bench` is a benchmarking tool for Nix, written in Nix itself. It provides a flexible and extensible framework for creating and running benchmarks on various systems.

## Features

- Define benchmarks as Nix expressions
- Parameterize benchmarks with environment variables
- Parse and log benchmark output
- Create suites of benchmarks to run in sequence
- Run benchmarks on different systems (Linux, macOS, etc.)

## Getting Started

### Prerequisites

- Nix package manager installed
- Flakes enabled (`nix.settings.experimental-features = ["nix-command" "flakes"]` in your `nix.conf`)

### Usage

To run a specific benchmark suite:

```
nix run .#foo
```

To enter a development shell with the benchmarks available:

```
nix develop
```

Then, you can run the `foo` benchmark suite:

```
foo-suite
```
