// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "@rails/request.js"

Turbo.StreamActions.redirect_to = function () {
  Turbo.visit(this.target)
};
