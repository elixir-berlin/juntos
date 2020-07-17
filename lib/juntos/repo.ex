defmodule Juntos.Repo do
  use Ecto.Repo,
    otp_app: :juntos,
    adapter: Ecto.Adapters.Postgres

  @doc "reload the record based"
  def reload!(%struct_name{id: id}) do
    get!(struct_name, id)
  end
end
