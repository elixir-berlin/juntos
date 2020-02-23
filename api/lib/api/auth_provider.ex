defmodule Api.AuthProvider do
  def list(providers: providers) do
    Enum.map(providers, &fetch_provider/1)
  end

  defp fetch_provider({provider, {provider_module, details}}) do
    %{
      auth_type: provider,
      auth_url: auth_url(provider_module),
      client_id: Module.concat(provider_module, OAuth).client().client_id,
      scope: fetch_scope(details)
    }
  end

  defp fetch_scope(default_scope: scope) do
    scope
  end

  defp fetch_scope(_) do
    ""
  end

  defp auth_url(Ueberauth.Strategy.Twitter = provider_module) do
    client = Module.concat(provider_module, OAuth).client()
    client.site() <> client.authorize_url()
  end

  defp auth_url(provider_module) do
    Module.concat(provider_module, OAuth).client().authorize_url()
  end
end
