defmodule Juntos.Accounts.AuthorizationRepoTest do
  use Juntos.DataCase

  alias Juntos.Accounts.{Authorization, AuthorizationRepo}

  @valid_attr %{
    provider: :github,
    uid: "uid-000001",
    email: "some@email.com",
    username: "someusername",
    token: "some token",
    altenative_emails: ["extra@email.com"],
    avatar_url: "http://avatar.url",
    name: "some name",
    expires_at: ~U[2020-01-01 01:01:01.280265Z],
    refresh_token: "some refresh_token"
  }
  def authorization_fixture(attrs \\ %{}) do
    {:ok, authorization} =
      attrs
      |> Enum.into(@valid_attr)
      |> AuthorizationRepo.create()

    authorization
  end

  describe "create/1" do
    test "creates an authorization record" do
      params = %{provider: :github, uid: "123", token: "token"}
      assert {:ok, %Authorization{} = auth} = AuthorizationRepo.create(params)
      assert auth.provider == :github
      assert auth.uid == "123"
      assert auth.token == "token"
    end

    test "attemps to create duplicate records" do
      params = %{provider: :github, uid: "123", token: "token"}
      assert {:ok, %Authorization{} = auth1} = AuthorizationRepo.create(params)
      assert {:error, changeset} = AuthorizationRepo.create(params)
      assert errors_on(changeset) == %{provider_uid: ["has already been taken"]}
    end
  end

  describe "get_by/1" do
    test "gets a token by uid and provider" do
      authorization = authorization_fixture(uid: "1234567", provider: :github)
      assert auth_record = AuthorizationRepo.get_by(uid: "1234567", provider: :github)
      assert auth_record.id == authorization.id
    end

    test "gets a non-existing uid and provider" do
      refute AuthorizationRepo.get_by(uid: "1234567", provider: :github)
    end
  end
end
