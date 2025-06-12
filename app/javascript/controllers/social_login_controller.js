import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from '@rails/request.js'

export default class extends Controller {
    connect() {
        this.setupEventHandlers()
    }

    disconnect() {
        this.teardownEventHandlers()
    }

    setupEventHandlers() {
        window.addEventListener("socialid:login_success", this.handleLoginSuccess.bind(this))
    }

    teardownEventHandlers() {
        window.removeEventListener("socialid:login_success", this.handleLoginSuccess.bind(this))
    }

    async handleLoginSuccess({ detail: { token } }) {
        this.showLoadingState()

        try {
            const request = new FetchRequest(
                'post', 
                '/social_login_authentication', 
                { 
                    body: { token },
                    responseKind: "turbo-stream" 
                }
            )

            const response = await request.perform()

            if (!response.ok) {
                this.hideLoadingState()
            }
        } catch(_) {
            this.hideLoadingState()
        }
    }

    showLoadingState() {
        document.body.classList.add("loading")
    }

    hideLoadingState() {
        document.body.classList.remove("loading")
    }
}
