defmodule Juntos.AccountsTest do
  use Juntos.DataCase

  describe "create_authorization/1" do
    test "creates a authorization" do
      github_auth = ueberauth_fixture(:github)
      assert {:ok, authorization} = Juntos.Accounts.create_authorization(github_auth)

      assert authorization.email == "myusername@gmail.com"
      assert length(authorization.altenative_emails) == 3
      assert authorization.token == "----token----"
      assert authorization.avatar_url == "https://avatars0.githubusercontent.com/u/1000?v=4"
      assert authorization.name == "Foo Bar"
      assert authorization.provider == :github
      refute authorization.expires_at
      refute authorization.refresh_token
    end
  end

  def ueberauth_fixture(:github) do
    %Ueberauth.Auth{
      credentials: %Ueberauth.Auth.Credentials{
        expires: false,
        expires_at: nil,
        other: %{},
        refresh_token: nil,
        scopes: ["user:email"],
        secret: nil,
        token: "----token----",
        token_type: "Bearer"
      },
      extra: %Ueberauth.Auth.Extra{
        raw_info: %{
          token: %OAuth2.AccessToken{
            access_token: "----token----",
            expires_at: nil,
            other_params: %{"scope" => "user:email"},
            refresh_token: nil,
            token_type: "Bearer"
          },
          user: %{
            "twitter_username" => nil,
            "company" => "@mycompany",
            "bio" => nil,
            "following" => 28,
            "followers_url" => "https://api.github.com/users/myusername/followers",
            "public_gists" => 9,
            "id" => 1000,
            "avatar_url" => "https://avatars0.githubusercontent.com/u/1000?v=4",
            "events_url" => "https://api.github.com/users/myusername/events{/privacy}",
            "starred_url" => "https://api.github.com/users/myusername/starred{/owner}{/repo}",
            "emails" => [
              %{
                "email" => "myusername@gmail.com",
                "primary" => false,
                "verified" => true,
                "visibility" => nil
              },
              %{
                "email" => "myusername2@gmail.com",
                "primary" => false,
                "verified" => true,
                "visibility" => nil
              },
              %{
                "email" => "myusername@users.noreply.github.com",
                "primary" => false,
                "verified" => true,
                "visibility" => nil
              }
            ],
            "blog" => "myusername.org",
            "subscriptions_url" => "https://api.github.com/users/myusername/subscriptions",
            "type" => "User",
            "site_admin" => false,
            "public_repos" => 57,
            "location" => "",
            "hireable" => nil,
            "created_at" => "2020-01-27T02:23:14Z",
            "name" => "Foo Bar",
            "organizations_url" => "https://api.github.com/users/myusername/orgs",
            "gists_url" => "https://api.github.com/users/myusername/gists{/gist_id}",
            "following_url" => "https://api.github.com/users/myusername/following{/other_user}",
            "url" => "https://api.github.com/users/myusername",
            "email" => nil,
            "login" => "myusername",
            "html_url" => "https://github.com/myusername",
            "gravatar_id" => "",
            "received_events_url" => "https://api.github.com/users/myusername/received_events",
            "repos_url" => "https://api.github.com/users/myusername/repos",
            "node_id" => "MDQ6VXNlcjU4NTc2NA==",
            "followers" => 122,
            "updated_at" => "2020-06-28T04:45:22Z"
          }
        }
      },
      info: %Ueberauth.Auth.Info{
        birthday: nil,
        description: nil,
        email: "myusername@gmail.com",
        first_name: nil,
        image: "https://avatars0.githubusercontent.com/u/1000?v=4",
        last_name: nil,
        location: "",
        name: "Foo Bar",
        nickname: "myusername",
        phone: nil,
        urls: %{
          api_url: "https://api.github.com/users/myusername",
          avatar_url: "https://avatars0.githubusercontent.com/u/1000?v=4",
          blog: "myusername.org",
          events_url: "https://api.github.com/users/myusername/events{/privacy}",
          followers_url: "https://api.github.com/users/myusername/followers",
          following_url: "https://api.github.com/users/myusername/following{/other_user}",
          gists_url: "https://api.github.com/users/myusername/gists{/gist_id}",
          html_url: "https://github.com/myusername",
          organizations_url: "https://api.github.com/users/myusername/orgs",
          received_events_url: "https://api.github.com/users/myusername/received_events",
          repos_url: "https://api.github.com/users/myusername/repos",
          starred_url: "https://api.github.com/users/myusername/starred{/owner}{/repo}",
          subscriptions_url: "https://api.github.com/users/myusername/subscriptions"
        }
      },
      provider: :github,
      strategy: Ueberauth.Strategy.Github,
      uid: 1000
    }
  end

  describe "users" do
    alias Juntos.Accounts.User
    alias Juntos.Accounts

    @valid_attrs %{
      avatar_url: "some avatar_url",
      email: "some@email",
      name: "some name",
      username: "some username"
    }
    @invalid_attrs %{avatar_url: nil, email: nil, name: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.avatar_url == "some avatar_url"
      assert user.email == "some@email"
      assert user.name == "some name"
      assert user.username == "some username"
    end

    test "create_user/1 with valid data creates a user with same username" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:error, changeset} = Accounts.create_user(Map.put(@valid_attrs, :email, "foo@bar"))
      assert errors_on(changeset) == %{username: ["has already been taken"]}
    end

    test "create_user/1 with valid data creates a user with same email" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert {:error, changeset} =
               Accounts.create_user(Map.put(@valid_attrs, :username, "foobar"))

      assert errors_on(changeset) == %{email: ["has already been taken"]}
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
