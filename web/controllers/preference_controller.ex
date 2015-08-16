defmodule Warner.PreferenceController do
  use Warner.Web, :controller

  @permitted_params ["disable_all"]

  def update(conn, %{"preference" => preference_params}) do
    conn = preference_params
    |> permitted_params_only
    |> Enum.reduce conn, fn({key, value}, conn) ->
      put_session(conn, key, value)
    end
    text conn, "Great!"
  end

  defp permitted_params_only(dict) do
    dict
    |> Enum.filter fn({key, _}) -> Enum.member?(@permitted_params, key) end
  end
end
