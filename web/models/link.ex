defmodule Warner.Link do
  use Warner.Web, :model

  schema "links" do
    field :hash, :string
    field :url, :string
    field :warnings, {:array, :string}

    timestamps
  end

  @required_fields ~w(hash url warnings)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @doc """
  Creates a hash for a given `url`.

  Might not necessarily use the url, but also might.
  """
  def generate_hash(_) do
    SecureRandom.urlsafe_base64(6)
  end
end
