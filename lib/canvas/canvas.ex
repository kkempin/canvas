defmodule Canvas.Canvas do
  use Ecto.Schema
  import Ecto.Changeset

  schema "canvas" do
    field :content, {:array, :string}
    field :width, :integer, dafault: 50
    field :height, :integer, dafault: 50

    has_many :drawing_operations, Canvas.DrawingOperation

    timestamps()
  end

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:content, :width, :height])
    |> validate_required([:content])
  end
end
