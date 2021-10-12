defmodule WmsTask.Orders do
  @moduledoc """
  Orders context module, responsible for orders functions.
  """

  require Logger

  alias Ecto.Multi
  alias WmsTask.{Helpers, Orders.Order, Pulpo, Repo}

  @doc """
    Return a list of orders saved in database
  """
  @spec get_orders :: list()
  def get_orders, do: Repo.all(Order)

  @doc """
  Return a list of orders from Pulpo API
  """
  @spec get_orders_in_interval(nil | number()) :: list()
  def get_orders_in_interval(interval \\ nil) do
    interval
    |> Pulpo.get_orders()
    |> Pulpo.update_orders_with_pickings()
    |> Pulpo.update_orders_with_packings()
  end

  defp insert_batch_orders(orders) do
    orders
    |> Enum.with_index()
    |> Enum.reduce(Multi.new(), fn {order, idx}, multi ->
      changeset = Order.changeset(%Order{}, order)

      Multi.insert(multi, {:inser_order, idx}, changeset)
    end)
    |> Repo.transaction()
    |> case do
      {:error, reason} = error ->
        Logger.error("Error in orders batch: #{inspect(reason, pretty: true)}")

        error

      success_tuple ->
        Logger.info("Successfull orders batch insert")

        success_tuple
    end
  end

  @doc """
  Get all orders from Pulpo API and insert in database
  """
  @spec sync_orders(1 | number()) :: tuple()
  def sync_orders(interval \\ 1) do
    orders =
      interval
      |> get_orders_in_interval()
      |> Helpers.map_to_order_model()

    Logger.info("Start writing #{inspect(length(orders))} orders to the DB")

    insert_batch_orders(orders)
  end
end
