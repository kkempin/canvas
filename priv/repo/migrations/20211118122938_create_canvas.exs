defmodule Canvas.Repo.Migrations.CreateCanvas do
  use Ecto.Migration

  def change do
    create table(:canvas) do
      add :content, {:array, :string}
      add :width, :integer, default: 50
      add :height, :integer, default: 50

      timestamps()
    end
  end
end
