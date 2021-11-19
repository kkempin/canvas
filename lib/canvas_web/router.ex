defmodule CanvasWeb.Router do
  use CanvasWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CanvasWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CanvasWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/", CanvasWeb do
    pipe_through :api

    post "/canvas", CanvasController, :create
    post "/draw", DrawingOperationController, :create
  end
end
