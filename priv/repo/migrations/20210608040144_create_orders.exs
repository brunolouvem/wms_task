defmodule WmsTask.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :number, :string
      add :order_updated, :naive_datetime
      add :picking_numbers, {:array, :string}
      add :packing_number, :string
      add :pickings, {:array, :jsonb}
      add :packing, :string

      timestamps()
    end
  end
end
