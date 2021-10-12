defmodule WmsTask.HelpersTest do
  use WmsTask.DataCase

  alias WmsTask.Helpers

  test "map_to_order_model/1" do
    order_model =
      get_order_test()
      |> Helpers.map_to_order_model()

    assert [
             %{
               number: "felipe_picking_sales_order_num_3",
               order_updated: nil,
               packing: %{"attributes" => %{}, "sequence_number" => "PA-0000001"},
               packing_number: "PA-0000001",
               picking_numbers: ["PI-0000003"],
               pickings: [%{"attributes" => %{}, "sequence_number" => "PI-0000003"}]
             }
           ] = order_model
  end

  defp get_order_test do
    "test/support/fixtures/fake_order_live.json"
    |> File.read!()
    |> Jason.decode!()
    |> List.wrap()
  end
end
