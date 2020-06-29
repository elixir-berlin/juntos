defmodule Juntos.Accounts.AuthorizationProviderEnum do
  use EctoEnum.Postgres,
    type: :authorization_provider,
    enums: [
      :github,
      :twitter,
      :google,
      :facebook,
      :apple
    ]
end
