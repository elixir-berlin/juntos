defmodule Api.AuthProviderTest do
  use ExUnit.Case

  describe "list/1" do
    test "fetch github" do
      config = [providers: [github: {Ueberauth.Strategy.Github, []}]]

      providers = [
        %{
          auth_type: :github,
          client_id: "1",
          scope: "",
          auth_url: "https://github.com/login/oauth/authorize"
        }
      ]

      assert Api.AuthProvider.list(config) == providers
    end

    test "fetch github with default scope" do
      config = [providers: [github: {Ueberauth.Strategy.Github, [default_scope: "user"]}]]

      providers = [
        %{
          auth_type: :github,
          client_id: "1",
          scope: "user",
          auth_url: "https://github.com/login/oauth/authorize"
        }
      ]

      assert Api.AuthProvider.list(config) == providers
    end

    test "fetch twitter" do
      config = [providers: [twitter: {Ueberauth.Strategy.Twitter, []}]]

      providers = [
        %{
          auth_type: :twitter,
          client_id: "2",
          scope: "",
          auth_url: "https://api.twitter.com/oauth/authorize"
        }
      ]

      assert Api.AuthProvider.list(config) == providers
    end
  end
end
