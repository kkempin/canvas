# Canvas

![Canvas](https://github.com/kkempin/canvas/blob/main/assets/canvas.png)

## The Canvas project

This is a client-server system to represent an ASCII art drawing canvas. It has two parts:

- API to create a canvas and draw on it
- Read-only web client to present and observe given canvas

## API

API allows to create a canvas and draw on it.

To start the API server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

---

**First step** would be to create a canvas. You can do this by invoking `POST /canvas` method.

For example from the terminal: `curl -X POST http://localhost:4000/canvas`

It will create default 50x50 canvas and will return its ID. The response is formatted as JSON:

```
{"content":["                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  ","                                                  "],"id":1}
```

You can also pass your own `height` and `width` of the canvas: `curl -X POST --header "Content-Type: application/json" -d '{"canvas": {"width": "4", "height": "4"}}' http://localhost:4000/canvas`:

```
{"content":["    ","    ","    ","    "],"id":2}
```

---

Now you can **draw on your canvas**!

It can be done by invoking `POST /draw` endpoint.

That enpoint accepts following parameters:

- `operation` (_required_) - what to draw. Two values are possible: `Rectangle` (draw a rectangle), `Flood fill` (fill empty space starting from a given point)
- `x` and `y` (_required_) - cordinates where to start drawing,
- `canvas_id` (_required_) - `ID` of the canvas created in the previous step,
- `width` and `height` - required for `Rectangle` - how big the rectangle should be,
- `fill_char` - required for `Flood fill` - a single character that will be used to fill the canvas or the rectangle,
- `outline_char` - a single character that will be used to draw an outline of the `Rectangle`. One of the `fill_char` or `outline_char` is required for `Rectangle`.

**Examples:**

1. On canvas with ID=1 draw a rectangle starting from point 5, 5 with width and height equal 5 and outline "," (so without fill).

```
curl -H "Content-Type: application/json" \
  -X POST \
  -d '{"draw": {"operation": "Rectangle", "x": "5", "y": "5", "width": "5", "height": "5", "outline_char": ",", "canvas_id": "1"}}' \
  http://localhost:4000/draw
```

2. Fill canvas with ID=1 with characted "O".

```
curl -H "Content-Type: application/json" \
  -X POST \
  -d '{"draw": {"operation": "Flood fill", "x": "0", "y": "0",  "canvas_id": "1"}}' \
  http://localhost:4000/draw
```

**Errors:**

If your API request is missing something, it will be reported in the response. For example:

```
curl -H "Content-Type: application/json" -X POST -d '{"draw": {"operation": "Flood fill", "x": "0", "y": "0",  "canvas_id": "1"}}' http://localhost:4000/draw
```

will produce:

```
{"errors":{"fill_char":["Fill char has to be provided."]}}
```

---

## Read-only web client to present and observe given canvas

You can also observe how the canvas is created in the browser. All in real-time.

Assuming you have the server running (see above) go to `http://localhost:4000/?id=CANVAS_ID`, wheras `CANVAS_ID` is ID of the canvas created above with API endpoint.

Once API endpoints to draw rectangles or fill shapes are invoked you will observe updated canvas without any need to refresh.

---

## Author

Copyright, Krzysztof Kempiński
