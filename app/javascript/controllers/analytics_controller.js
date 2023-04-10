import { Controller } from "@hotwired/stimulus"
import * as pbi from "powerbi-client";

export default class extends Controller {
  static targets = ["container"]

  connect() {
    const reportContainer = this.containerTarget;
    powerbi.bootstrap(reportContainer, { type: "report" });

    fetch("/load-embed-config").then(response => response.json()).then(embedConfig => {
      const reportLoadConfig = {
        type: "report",
        tokenType: pbi.models.TokenType.Embed,
        accessToken: embedConfig.token,
        embedUrl: embedConfig.report_details.embed_url,
      };
      powerbi.embed(reportContainer, reportLoadConfig);
      const iframe = document.getElementsByTagName("iframe")[0];
      iframe.style.borderRadius = "25px";
    });
  }
}
