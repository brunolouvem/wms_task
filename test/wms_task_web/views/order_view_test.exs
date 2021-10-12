defmodule WmsTaskWeb.OrderViewTest do
  use WmsTaskWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  alias WmsTask.{Expectations, Orders}

  test "renders order_model.json" do
    Expectations.expect_all_sync_calls(:with_pickings)

    WmsTask.Orders.sync_orders(100_000)

    [order | _] = Orders.get_orders()

    expected_order_view = %{
      order_num: order.number,
      order_updated_at: order.order_updated,
      picking_numbers: order.picking_numbers,
      packing_number: order.packing_number,
      packing: order.packing,
      pickings: order.pickings
    }

    assert render(WmsTaskWeb.OrderView, "order_model.json", order: order) == expected_order_view
  end

  test "renders order.json" do
    Expectations.expect_all_sync_calls(:with_pickings)

    order =
      WmsTask.Orders.get_orders_in_interval()
      |> List.first()
      |> Map.put("packing", %{"sequence_number" => "test-packind"})

    expected_order_view = %{
      orders: [
        %{
          order_num: order["order_num"],
          items_count: length(order["items"]),
          status: order["state"],
          warehouse_name: order["warehouse"]["name"],
          shipping_address: order["ship_to"]["name"],
          packing: order["packing"] || "",
          pickings: order["pickings"]
        }
      ]
    }

    assert render(WmsTaskWeb.OrderView, "orders.json", orders: [order]) == expected_order_view
  end
end
