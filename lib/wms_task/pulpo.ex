defmodule WmsTask.Pulpo do
  @moduledoc """
  Pulpo API Wrapper, keeps all interactions with Pulpo API over orders
  """

  require Logger

  alias WmsTask.Pulpo.Adapter

  @doc """
  Get all order in Pulpo from interval.
  """
  def get_orders(interval) do
    auth_headers = Adapter.auth()

    interval
    |> build_interval()
    |> Adapter.get_orders(auth_headers)
    |> Map.get("sales_orders", [])
  end

  @doc """
  Update order list with picking array for each order.
  """
  def update_orders_with_pickings(orders) do
    auth_headers = Adapter.auth()

    Task.async_stream(orders, fn %{"order_num" => order_num} = order ->
      Logger.info("Getting pickings for order #{order_num}")

      pickings = Adapter.get_picking(order_num, auth_headers)
      Map.put(order, "pickings", pickings["picking_orders"])
    end)
    |> Enum.map(fn {:ok, result} -> result end)
  end

  @doc """
  Update order list with packing for each order.
  """
  def update_orders_with_packings(orders) do
    auth_headers = Adapter.auth()

    Task.async_stream(orders, fn %{"order_num" => order_num} = order ->
      Logger.info("Getting packings for order #{order_num}")

      packing =
        Adapter.get_packing(order_num, auth_headers)
        |> Map.get("packing_orders", [])
        |> List.first()

      Map.put(order, "packing", packing)
    end)
    |> Enum.map(fn {:ok, result} -> result end)
  end

  defp build_interval(nil), do: ""

  defp build_interval(interval) do
    to = DateTime.utc_now()
    from = DateTime.add(to, -(interval * 60), :second)
    "?updated_at=between:#{DateTime.to_iso8601(from)},#{DateTime.to_iso8601(to)}"
  end
end
