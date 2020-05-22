#!/usr/bin/env crun
# ---
# ecs:
#   path: /home/scott/Documents/code/ecs
# ...
require "ecs"

event = ECS::LogEntry.new
  .timestamp(Time.utc)
  .http(&.version("1.1")
    .request(&.method("GET").bytes(1234))
    .response(&.status_code(200)
      .bytes(1234)
      .body(&.content("OK."))))
puts event.to_json
