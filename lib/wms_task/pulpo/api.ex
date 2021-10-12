defmodule WmsTask.Pulpo.Api do
  @moduledoc false
  require Logger

  #############
  # Behaviour #
  #############

  @behaviour WmsTask.Pulpo.Adapter

  @impl true
  def get_orders(between, headers) do
    "/sales/orders#{between}"
    |> build_url()
    |> HTTPoison.get!(headers)
    |> handle_response()
  end

  @impl true
  def get_packing(order_num, headers) do
    build_url("/packing/orders?__or_search=sales_order_num%7Ccontains%3A#{order_num}&limit=20")
    |> HTTPoison.get!(headers)
    |> handle_response()
  end

  @impl true
  def get_picking(order_num, headers) do
    build_url("/picking/orders?__or_search=sales_order_num%7Ccontains%3A#{order_num}&limit=20")
    |> HTTPoison.get!(headers)
    |> handle_response()
  end

  @impl true
  def auth do
    user = config!(:user)
    auth_url = build_url("/auth")

    body =
      Jason.encode!(%{
        username: user,
        password: user,
        grant_type: "password",
        scope: "profile"
      })

    token =
      HTTPoison.post!(auth_url, body, "Content-Type": "application/json")
      |> handle_response()
      |> Map.fetch!("access_token")

    [Authorization: "Bearer #{token}", "Content-Type": "application/json"]
  end

  defp build_url(path) do
    config!(:base_url)
    |> Kernel.<>(path)
  end

  defp handle_response(%HTTPoison.Response{body: response_body}) do
    Jason.decode!(response_body)
  end

  defp config!(key) do
    :wms_task
    |> Application.get_env(WmsTask.Pulpo)
    |> Keyword.fetch!(key)
  end
end
