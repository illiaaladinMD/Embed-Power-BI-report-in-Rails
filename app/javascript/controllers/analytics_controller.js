import { Controller } from "@hotwired/stimulus"
import * as pbi from 'powerbi-client';

export default class extends Controller {
  static targets = [ "container" ]

  connect() {
    const accessToken = this.data.get("accessToken");
    const embedUrl = this.data.get("embedUrl");
    const reportContainer = this.containerTarget;
    const reportLoadConfig = {
        type: "report",
        tokenType: pbi.models.TokenType.Embed,
        accessToken: accessToken,
        embedUrl: embedUrl,
    };
    powerbi.embed(reportContainer, reportLoadConfig);
  }
}
