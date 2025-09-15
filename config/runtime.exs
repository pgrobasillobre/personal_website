import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/personal_website start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :personal_website, PersonalWebsiteWeb.Endpoint, server: true
end


if config_env() == :prod do
  config :personal_website, :ga_id, System.get_env("GA_MEASUREMENT_ID")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "environment variable SECRET_KEY_BASE is missing."

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :personal_website, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :personal_website, PersonalWebsiteWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: {0,0,0,0,0,0,0,0}, port: port],
    secret_key_base: secret_key_base
end
