
all:	clean	shard	ecs
release:	shard/relase	ecs

clean:
	-rm bin/parser
	-rm src/ecs.cr

ecs:
	bin/parser ecs_flat.yml src/ecs.cr

shard:
	shards build

shard/release:
	shards build --release