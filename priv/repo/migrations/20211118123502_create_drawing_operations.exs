defmodule Canvas.Repo.Migrations.CreateDrawingOperations do
  use Ecto.Migration

  def change do
    create table(:drawing_operations) do
      add :operation, :string
      add :x, :integer
      add :y, :integer
      add :width, :integer
      add :height, :integer
      add :fill_char, :string
      add :outline_char, :string
      add :canvas_id, references(:canvas, on_delete: :delete_all)

      timestamps()
    end

    create index(:drawing_operations, [:canvas_id])
  end
end
