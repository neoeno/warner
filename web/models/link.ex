defmodule Warner.Link do
  use Warner.Web, :model

  schema "links" do
    field :hash, :string
    field :url, :string
    field :warnings, {:array, :string}

    timestamps
  end

  @required_fields ~w(url)
  @optional_fields ~w(warnings)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    changeset = cast(model, params, @required_fields, @optional_fields)
    changeset = case get_field(changeset, :warnings_string) do
      nil -> change(changeset, %{warnings: []})
      warnings_string -> change(changeset, %{warnings: split_warnings_string(warnings_string)})
    end
    delete_change(changeset, :warnings_string)
    changeset = case get_field(changeset, :url) do
      nil -> changeset
      url -> change(changeset, %{hash: generate_hash(url)})
    end
  end

  @doc """
  Creates a hash for a given `url`.

  Might not necessarily use the url, but also might.
  """
  defp generate_hash(_) do
    SecureRandom.urlsafe_base64(6)
  end

  defp split_warnings_string(warnings_string) do
    String.split(warnings_string, ",", trim: true)
  end
end
