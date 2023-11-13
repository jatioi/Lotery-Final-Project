// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

import LocationController from "./location_controller"
application.register("location", LocationController)

import Select2Controller from "./select2_controller"
application.register("select2", Select2Controller)

import jQuery from "jquery"
 window.jQuery = jQuery
 window.$ = jQuery