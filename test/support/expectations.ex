defmodule WmsTask.Expectations do
  @moduledoc """
  Module that call MOX functions for mocks
  """

  import Mox

  alias WmsTask.PulpoMock

  @doc """
  Expectation function to expect one or more auth calls
  """
  def expect_auth(times \\ 1) do
    access_token =
      "test/support/fixtures/auth.json"
      |> build_map_from_file()
      |> Map.fetch!("access_token")

    response = [Authorization: "Bearer #{access_token}", "Content-Type": "application/json"]

    expect(PulpoMock, :auth, times, fn ->
      response
    end)

    response
  end

  @doc """
  Expect one get_order call
  """
  def expect_orders do
    expect_auth()

    response = build_map_from_file("test/support/fixtures/orders.json")

    expect(PulpoMock, :get_orders, fn _, _ ->
      response
    end)

    response
  end

  @doc """
  Expect one get_order call with empty response
  """
  def expect_no_orders do
    expect_auth()

    response = %{"sales_orders" => []}

    expect(PulpoMock, :get_orders, fn _, _ ->
      response
    end)

    response
  end

  @doc """
  Expect one get_packing call
  """
  def expect_packings do
    response = build_map_from_file("test/support/fixtures/no_packings.json")

    expect(PulpoMock, :get_packing, fn _, _ ->
      response
    end)

    response
  end

  @doc """
  Expect one get_picking call with many pickings for order
  """
  def expect_pickings(:more) do
    "test/support/fixtures/more_pickings.json"
    |> do_expect_pickings()
  end

  def expect_pickings(:empty) do
    "test/support/fixtures/no_pickings.json"
    |> do_expect_pickings()
  end

  def expect_pickings(:one) do
    "test/support/fixtures/one_picking.json"
    |> do_expect_pickings()
  end

  defp do_expect_pickings(fixture_path) do
    response = build_map_from_file(fixture_path)

    expect(PulpoMock, :get_picking, fn _, _ ->
      response
    end)

    response
  end

  @doc """
  Expect all calls from sync
  """
  def expect_all_sync_calls do
    expect_orders()
    |> Map.fetch!("sales_orders")
    |> Enum.each(fn _ ->
      expect_auth(2)
      expect_pickings(:empty)
      expect_packings()
    end)
  end

  defp build_map_from_file(file_path) do
    file_path
    |> File.read!()
    |> Jason.decode!()
  end
end
