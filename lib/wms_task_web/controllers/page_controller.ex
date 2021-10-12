defmodule WmsTaskWeb.PageController do
  use WmsTaskWeb, :controller

  require Logger

  alias WmsTask.Orders

  def get_orders_live(conn, _params) do
    orders = Orders.get_orders_in_interval()
    render(conn, "orders.json", orders: orders)
  end

  def get_orders(conn, _params) do
    orders = Orders.get_orders()
    render(conn, "orders_model.json", orders: orders)
  end
end
