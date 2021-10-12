defmodule WmsTask.Pulpo.Adapter do
  @moduledoc """
  Modules responsible for Pulpo wrapper function definitions
  """

  @callback auth() :: keyword()
  @callback get_orders(binary(), keyword()) :: map()
  @callback get_packing(binary(), keyword()) :: map()
  @callback get_picking(binary(), keyword()) :: map()

  @spec adapter :: module()
  defp adapter do
    Application.get_env(:wms_task, WmsTask.Pulpo)
    |> Keyword.get(:adapter)
  end

  @spec auth :: keyword()
  def auth do
    adapter().auth()
  end

  @spec get_orders(binary(), keyword()) :: map()
  def get_orders(between, headers) do
    adapter().get_orders(between, headers)
  end

  @spec get_packing(binary(), keyword()) :: map()
  def get_packing(order_num, headers) do
    adapter().get_packing(order_num, headers)
  end

  @spec get_picking(binary(), keyword()) :: map()
  def get_picking(order_num, headers) do
    adapter().get_picking(order_num, headers)
  end
end
