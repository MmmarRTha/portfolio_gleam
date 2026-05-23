import lustre
import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

pub fn main() {
  let app = lustre.simple(init, update, view)
  let _ = lustre.start(app, "#app", Nil)

  Nil
}

type Model {
  Model(name: String, greeting: String)
}

fn init(_flags) {
  Model(name: "", greeting: "")
}

type Msg {
  UserUpdatedName(String)
  UserClickedGreet
}

fn update(model: Model, msg: Msg) {
  case msg {
    UserUpdatedName(name) -> Model(..model, name: name)
    UserClickedGreet -> Model(..model, greeting: "Hello " <> model.name <> "!")
  }
}

fn view(model: Model) {
  html.div([attribute.class("flex flex-col gap-4 p-8 max-w-md mx-auto mt-10")], [
    html.input([
      attribute.class(
        "border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-pink-500",
      ),
      event.on_input(UserUpdatedName),
    ]),
    html.button(
      [
        attribute.class(
          "bg-pink-500 hover:bg-pink-700 text-white font-bold py-2 px-4 rounded-lg transition",
        ),
        event.on_click(UserClickedGreet),
      ],
      [element.text("Greet")],
    ),
    html.p([attribute.class("text-gray-700 text-lg")], [
      element.text(model.greeting),
    ]),
  ])
}
