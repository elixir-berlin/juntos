defmodule Api.AuthProvider do
  def list(providers: providers) do
    Enum.map(providers, &fetch_provider/1)
  end

  defp fetch_provider({provider, details}) do
    %{
      auth_type: provider,
      auth_url: Ueberauth.Strategy.Github.OAuth.client().authorize_url,
      client_id: Ueberauth.Strategy.Github.OAuth.client().client_id,
      scope: ""
    }
  end
end
