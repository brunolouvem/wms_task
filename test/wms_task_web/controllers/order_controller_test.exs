defmodule WmsTaskWeb.OrderControllerTest do
  use WmsTaskWeb.ConnCase

  alias WmsTask.Expectations

  setup do
    Expectations.expect_all_sync_calls()
  end

  test "GET /orders/live", %{conn: conn} do
    response =
      get(conn, "/orders/live")
      |> json_response(200)

    refute is_nil(response["orders"])
    assert length(response["orders"]) == 10
  end

  test "sync", %{conn: conn} do
    WmsTask.Orders.sync_orders(100_000)

    response =
      get(conn, "/orders")
      |> json_response(200)

    refute is_nil(response["orders"])
    assert length(response["orders"]) == 10
  end
end
