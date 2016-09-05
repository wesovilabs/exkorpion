use Mix.Config

config :logger,
  level: :warn,
  truncate: 4096

import_config "#{Mix.env}.exs"