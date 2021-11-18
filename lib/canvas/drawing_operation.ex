defmodule Canvas.DrawingOperation do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "drawing_operations" do
    field :fill_char, :string
    field :height, :integer
    field :operation, :string
    field :outline_char, :string
    field :width, :integer
    field :x, :integer
    field :y, :integer

    belongs_to :canvas, Canvas.Canvas

    timestamps()
  end

  @doc false
  def changeset(drawing_operation, attrs) do
    drawing_operation
    |> cast(attrs, [:operation, :x, :y, :width, :height, :fill_char, :outline_char, :canvas_id])
    |> validate_required([:operation, :x, :y])
    |> validate_inclusion(:operation, ["Rectangle", "Flood fill"])
    |> validate_number(:x, greater_than_or_equal_to: 0)
    |> validate_number(:y, greater_than_or_equal_to: 0)
    |> validate_number(:width, greater_than: 0)
    |> validate_number(:height, greater_than: 0)
    |> validate_length(:fill_char, max: 1)
    |> validate_length(:outline_char, max: 1)
    |> validate_fill_and_outline()
    |> validate_width_and_height()
  end

  defp validate_fill_and_outline(changeset) do
    fill_char = get_field(changeset, :fill_char)
    outline_char = get_field(changeset, :outline_char)

    case get_field(changeset, :operation) do
      "Rectangle" ->
        if is_empty_or_missing?(fill_char) and is_empty_or_missing?(outline_char) do
          add_error(changeset, :fill_char, "Fill or outline char has to be provided.")
        else
          changeset
        end

      "Flood fill" ->
        if is_empty_or_missing?(fill_char) do
          add_error(changeset, :fill_char, "Fill char has to be provided.")
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp validate_width_and_height(changeset) do
    if get_field(changeset, :operation) == "Rectangle" do
      validate_required(changeset, [:width, :height])
    else
      changeset
    end
  end

  defp is_empty_or_missing?(subject) do
    case subject do
      nil -> true
      "" -> true
      _ -> false
    end
  end
end
