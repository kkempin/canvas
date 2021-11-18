defmodule Canvas.DrawingService do
  @moduledoc """
  This module provides a service for drawing on a canvas.
  """

  alias Canvas.{DrawingOperation, Canvas, Repo}

  @doc """
  Draws given operation on the canvas.
  """
  @spec draw(pos_integer()) ::
          {:ok, Canvas.t()} | {:error, :operation_not_found} | {:error, Ecto.Changeset.t()}
  def draw(drawing_operation_id) do
    with drawing_operation when not is_nil(drawing_operation) <-
           Repo.get(DrawingOperation, drawing_operation_id),
         drawing_operation <- Repo.preload(drawing_operation, :canvas),
         content <- do_draw(drawing_operation) do
      drawing_operation.canvas
      |> Canvas.update_changeset(%{"content" => content})
      |> Repo.update()
    else
      nil -> {:error, :operation_not_found}
    end
  end

  defp do_draw(
         %DrawingOperation{
           operation: "Rectangle",
           width: width,
           height: height,
           fill_char: fill_char,
           outline_char: outline_char,
           x: x,
           y: y
         } = drawing_operation
       ) do
    canvas = drawing_operation.canvas
    outline_char = outline_char || fill_char

    Enum.reduce(Range.new(0, height - 1), canvas.content, fn i, acc ->
      if y + i < canvas.height do
        row =
          acc
          |> Enum.at(y + i)
          |> String.split("", trim: true)

        replaced_row =
          Enum.reduce(Range.new(0, width - 1), row, fn j, acc_row ->
            char =
              if i == 0 or i == height - 1 do
                outline_char
              else
                if j == 0 or j == width - 1,
                  do: outline_char,
                  else: fill_char || Enum.at(acc_row, x + j)
              end

            List.replace_at(acc_row, x + j, char)
          end)

        List.replace_at(acc, y + i, Enum.join(replaced_row, ""))
      else
        acc
      end
    end)
  end

  defp do_draw(%DrawingOperation{operation: "Flood fill"} = drawing_operation) do
  end
end
