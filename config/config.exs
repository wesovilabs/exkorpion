use Mix.Config

config :logger,
  level: :debug,
  truncate: 4096

import_config "#{Mix.env}.exs"