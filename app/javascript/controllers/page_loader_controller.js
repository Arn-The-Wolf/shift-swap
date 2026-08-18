import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bar"]

  connect() {
    document.addEventListener("turbo:visit", this.show)
    document.addEventListener("turbo:before-fetch-request", this.show)
    document.addEventListener("turbo:before-fetch-response", this.hide)
    document.addEventListener("turbo:load", this.hide)
    document.addEventListener("turbo:submit-start", this.show)
    document.addEventListener("turbo:submit-end", this.hide)
  }

  disconnect() {
    document.removeEventListener("turbo:visit", this.show)
    document.removeEventListener("turbo:before-fetch-request", this.show)
    document.removeEventListener("turbo:before-fetch-response", this.hide)
    document.removeEventListener("turbo:load", this.hide)
    document.removeEventListener("turbo:submit-start", this.show)
    document.removeEventListener("turbo:submit-end", this.hide)
  }

  show = () => {
    this.barTarget.classList.add("is-active")
  }

  hide = () => {
    this.barTarget.classList.remove("is-active")
  }
}
