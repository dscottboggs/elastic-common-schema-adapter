require "./parser"

# The command-line entrypoint for the parser which generates the library.
module ECS::CLI
  extend ECS::Parser

  abort "Usage: parser ecs_flat.yml ecs_lib.cr" if ARGV.size != 2

  File.open ARGV[0] do |file|
    File.open ARGV[1], mode: "w" do |shard|
      shard.puts %<require "json">
      shard.puts "include JSON::Serializable"
      ecs = Hash(String, ECS::Parser::Section)
        .from_yaml file
      properties(ecs).each do |type, sections|
        parent_type, sub_type = begin
          split = type.split "::"
          if split.size > 1
            {split[...-1].join("::"), split[-1]}
          else
            {nil, type}
          end
        end
        ECR.embed "src/section.ecr", shard
        shard << '\n'
      end
    end
  end
end
