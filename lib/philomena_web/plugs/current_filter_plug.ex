defmodule PhilomenaWeb.CurrentFilterPlug do
  import Plug.Conn

  alias Philomena.{Filters, Filters.Filter}
  alias Philomena.Repo
  alias Pow.Plug
  # No options
  def init([]), do: false

  # Assign current filter
  def call(conn, _opts) do
    conn = conn |> fetch_session()
    user = conn |> Plug.current_user()

    filter =
      if user do
        user = user |> Repo.preload(:current_filter)
        user.current_filter
      else
        filter_id = conn |> get_session(:filter_id)

        filter = if filter_id, do: Repo.get(Filter, filter_id) 

        filter || Filters.default_filter()
      end

    conn
    |> assign(:current_filter, filter)
  end
end