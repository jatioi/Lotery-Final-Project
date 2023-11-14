import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["link"]

    copy() {
        if (navigator.clipboard) {
            console.log('copy email: ' + this.linkTarget.textContent);
            navigator.clipboard.writeText(this.linkTarget.textContent);
            $(".notice:eq(0)").text('copy email: ' + this.linkTarget.textContent);
        } else {
            console.error('Clipboard API not supported');
        }
    }
}