defmodule Warner.Repo.Migrations.AddWarningsToLink do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add :warnings, {:array, :string}
    end
  end
end
