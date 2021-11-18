defmodule Canvas.Canvas do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @default_width 50
  @default_height 50

  schema "canvas" do
    field :content, {:array, :string}
    field :width, :integer, dafault: @default_width
    field :height, :integer, dafault: @default_height

    has_many :drawing_operations, Canvas.DrawingOperation

    timestamps()
  end

  @doc false
  def new_changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:width, :height])
    |> fill_canvas_with_empty_values()
  end

  def update_changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end

  defp fill_canvas_with_empty_values(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        tabula_rasa =
          " "
          |> String.duplicate(get_field(changeset, :width) || @default_width)
          |> List.duplicate(get_field(changeset, :height) || @default_height)

        put_change(changeset, :content, tabula_rasa)

      _ ->
        changeset
    end
  end
end
