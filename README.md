# easy-cli

Current version: **0.9**

Easy CLI is a small shard that provides a structure for your CLI utilities.  
Features:
- Define commands and infinite levels of subcommands.
- Define options and arguments.
- Define channels for your output with set verbosity level and if it should write to a file.

**This is a project under development.**

## Contact

For issues/bugs you can:
- submit an issue on GitHub: https://github.com/TheMasterCado/easy-cli/issues/new

For feature requests you can:
- submit an issue on GitHub: https://github.com/TheMasterCado/easy-cli/issues/new
- tweet me: https://twitter.com/themastercado

For anything else:
- tweet me: https://twitter.com/themastercado

## Documentation

[Simple use case](https://github.com/TheMasterCado/easy-cli#usage)

The full documentation isn't available yet.

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  easy-cli:
    github: themastercado/easy-cli
```
2. Run `shards install`

## Usage

#### Require the gem

```crystal
require "easy-cli"

...
```

#### Create a CLI

Create a CLI named `mycli`:
```crystal
...

class MyCLI < Easy_CLI::CLI
  def initialize
    name "mycli"
  end
end

...
```

#### Create a Command

Create a command named `com` with an argument `name` and an option `night`:
```crystal
...

class Com < Easy_CLI::Command
  def initialize
    name "com"
    desc "My first command with Easy CLI"

    argument "name"
    option "night", :boolean, nil, "--night", "Say good night instead of good morning"
  end

  def call(data)
    if data["night"]
      puts "Good night #{data["name"]}"
    else
      puts "Good morning #{data["name"]}"
    end
  end
end

...
```

#### Register a Command

Register an instance of the `Com` class to an instance of the `MyCLI` class:
```crystal
...

cli = MyCLI.new
cli.register Com.new

...
```

#### Call a CLI

Call the `run` method with the passed arguments on the `MyCLI` instance:
```crystal
...

cli.run(ARGV)
```

**Examples**

```shell
$ mycli com alexis
Good morning alexis
```

```shell
$ mycli com alexis --night
Good night alexis
```

```shell
$ mycli com
ERROR: Invalid number of arguments for 'mycli com' (given 0, expected 1).
Usage: mycli com NAME [options]

Description:
    My first command with Easy CLI

Options:
    --night                          Say good night instead of good morning
    -h, --help                       Show this help
```

```shell
$ mycli
Usage: mycli COMMAND

Commands:
    com                              My first command with Easy CLI
```

\**If you haven't compiled your program yet, use* `crystal run <path to your main .cr> -- <arguments>`

## Contributing

1. Fork it (<https://github.com/themastercado/easy-cli/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [TheMasterCado](https://github.com/TheMasterCado) - creator and maintainer
