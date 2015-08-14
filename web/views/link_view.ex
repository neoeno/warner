defmodule Warner.LinkView do
  use Warner.Web, :view
  alias Warner.Link

  def warnings_string(%Link{warnings: warnings}) do
    warnings |> Enum.join(", ")
  end
end
