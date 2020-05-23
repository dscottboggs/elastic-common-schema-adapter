# Elastic Common Schema Adapter

Automatically generated Crystal types matching the Elastic Common Schema. This
library is intended to support a formatter for logging in Crystal, but because
it is automatically generated from the ecs definition document, it doesn't do
anything except store those generated types.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     ecs:
       github: dscottboggs/ecs
   ```

2. Run `shards install`

## Usage

```crystal
require "ecs"

event = ECS::LogEntry.new
  .timestamp(Time.utc)
  .http(&.version("1.1")
    .request(&.method("GET").bytes(1234))
    .response(&.status_code(200)
      .bytes(1234)
      .body(&.content("OK."))))

puts event.to_json
```
The above snippet prints out
```json
{"@timestamp":"2020-05-23T11:55:28Z","http":{"version":"1.1","request":{"bytes":1234,"method":"GET"},"response":{"bytes":1234,"status_code":200,"body":{"content":"OK."}}}}
```

## Development
**DO NOT** make changes to `ecs.cr`. It is automatically generated from `section.ecr`. See the `Makefile` for more details. If you have a recommendation, please make changes to `parser.cr` or `section.ecr` and run `make` before committing to regenerate `ecs.cr`.

## Contributing

1. Fork it (<https://github.com/dscottboggs/ecs/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [D. Scott Boggs](https://github.com/dscottboggs) - creator and maintainer
