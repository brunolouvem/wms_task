defmodule WmsTask.OrdersTest do
  use WmsTask.DataCase

  alias WmsTask.{Expectations, Orders}

  describe "sync_orders/1" do
    test "successfully sync orders" do
      Expectations.expect_all_sync_calls()

      Orders.sync_orders()

      assert [%Orders.Order{} | _] = Orders.get_orders()
    end

    test "successfully sync orders but empty list returned from pulpo" do
      Expectations.expect_no_orders()
      Expectations.expect_auth(2)

      Orders.sync_orders()

      assert [] = Orders.get_orders()
    end
  end

  describe "get_orders_in_interval/1" do
    test "successfully get orders without interval" do
      Expectations.expect_no_orders()
      Expectations.expect_auth(2)

      assert [] = Orders.get_orders_in_interval()
    end

    test "successfully get orders with interval" do
      Expectations.expect_all_sync_calls()

      assert [%{} | _] = Orders.get_orders_in_interval(100)
    end
  end
end
