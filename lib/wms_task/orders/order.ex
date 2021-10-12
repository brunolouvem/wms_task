defmodule WmsTask.Orders.Order do
  @moduledoc """
  Order Schema module
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :number, :string
    field :packing, :string
    field :order_updated, :naive_datetime
    field :packing_number, :string
    field :picking_numbers, {:array, :string}
    field :pickings, {:array, :map}

    timestamps()
  end

  @doc false
  def changeset(orders, attrs) do
    orders
    |> cast(attrs, [
      :number,
      :order_updated,
      :picking_numbers,
      :packing_number,
      :pickings,
      :packing
    ])
    |> validate_required([:number, :order_updated])
  end
end
