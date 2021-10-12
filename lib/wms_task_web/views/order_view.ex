defmodule WmsTaskWeb.OrderView do
  @moduledoc false

  use WmsTaskWeb, :view

  def render("orders_model.json", %{orders: orders}) do
    %{
      orders: render_many(orders, __MODULE__, "order_model.json", as: :order)
    }
  end

  def render("order_model.json", %{order: order}) do
    %{
      order_num: order.number,
      order_updated_at: order.order_updated,
      picking_numbers: order.picking_numbers,
      packing_number: order.packing_number,
      packing: order.packing,
      pickings: order.pickings
    }
  end

  def render("orders.json", %{orders: orders}) do
    %{
      orders: render_many(orders, __MODULE__, "order.json", as: :order)
    }
  end

  def render("order.json", %{order: order}) do
    %{
      order_num: order["order_num"],
      items_count: length(order["items"]),
      status: order["state"],
      warehouse_name: order["warehouse"]["name"],
      shipping_address: order["ship_to"]["name"],
      packing: order["packing"] || "",
      pickings: order["pickings"]
    }
  end
end
