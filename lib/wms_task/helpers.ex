defmodule WmsTask.Helpers do
  @moduledoc """
  Helpers keep helper functions to support context
  """

  require Logger

  @spec map_to_order_model(nil | maybe_improper_list | map) :: list | map()
  def map_to_order_model(orders) when is_list(orders) do
    Enum.map(orders, &map_to_order_model(&1))
  end

  def map_to_order_model(order) do
    %{
      number: order["order_num"],
      order_updated: order["updated_at"],
      picking_numbers: Enum.map(order["pickings"], &get_number(&1)),
      packing_number: get_number(order["packing"]),
      pickings: order["pickings"],
      packing: get_packing(order["packing"])
    }
  end

  defp get_packing(map) when is_map(map), do: map
  defp get_packing(_), do: nil

  defp get_number(%{"sequence_number" => sequence_number}), do: sequence_number
  defp get_number(_), do: ""
end
