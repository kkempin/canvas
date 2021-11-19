defmodule Canvas.CanvasService do
  @moduledoc """
  This module provides a service for canvas.
  """

  alias Canvas.{Canvas, Repo}

  @doc """
  Renders canvas
  """
  @spec render(pos_integer(), String.t()) :: String.t()
  def render(canvas_id, join_with \\ "\n\r") do
    canvas = Repo.get(Canvas, canvas_id)
    Enum.join(canvas.content, join_with)
  end

  @doc """
  Creates a new canvas
  """
  @spec create_canvas(map()) :: {:ok, Canvas.t()} | {:error, Ecto.Changeset.t()}
  def create_canvas(params) do
    %Canvas{}
    |> Canvas.new_changeset(params)
    |> Repo.insert()
  end

  @doc """
  Updates a canvas
  """
  @spec update_canvas(Canvas.t(), map()) :: {:ok, Canvas.t()} | {:error, Ecto.Changeset.t()}
  def update_canvas(canvas, attrs) do
    canvas
    |> Canvas.update_changeset(attrs)
    |> Repo.update()
  end
end
