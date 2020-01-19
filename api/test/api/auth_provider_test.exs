defmodule Api.AuthProviderTest do
  use ExUnit.Case

  describe "list/1" do
    test "fetch github" do
      config = [providers: [github: {Ueberauth.Strategy.Github, []}]]
      providers = [%{auth_type: :github, client_id: "1", scope: "", auth_url: "https://github.com/login/oauth/authorize"}]
      assert Api.AuthProvider.list(config) == providers
    end
  end
end
