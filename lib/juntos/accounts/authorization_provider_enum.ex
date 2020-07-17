defmodule Juntos.Accounts.AuthorizationProviderEnum do
  @moduledoc false
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
