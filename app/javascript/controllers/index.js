import { Application } from "stimulus"
import HelloController from "./hello_controller"

const application = Application.start()
application.register("hello", HelloController)
