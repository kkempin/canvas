defmodule Canvas.Repo.Migrations.AddDrawnAtToDrawingOperation do
  use Ecto.Migration

  def change do
    alter table(:drawing_operations) do
      add(:drawn_at, :utc_datetime)
    end
  end
end
