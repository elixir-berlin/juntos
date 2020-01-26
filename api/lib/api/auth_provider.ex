defmodule Api.AuthProvider do
  def list(providers: providers) do
    Enum.map(providers, &fetch_provider/1)
  end

  defp fetch_provider({provider, details}) do
    %{
      auth_type: provider,
      auth_url: Ueberauth.Strategy.Github.OAuth.client().authorize_url,
      client_id: Ueberauth.Strategy.Github.OAuth.client().client_id,
      scope: fetch_scope(details)
    }
  end

  defp fetch_scope({_provider_module, [default_scope: scope]}) do
    scope
  end

  defp fetch_scope(_) do
    ""
  end
end
