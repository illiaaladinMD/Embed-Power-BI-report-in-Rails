import { Controller } from "@hotwired/stimulus"
import * as pbi from 'powerbi-client';

export default class extends Controller {
  static targets = ["container"]
  static values = { url: String }

  connect() {
    const reportContainer = this.containerTarget;
    powerbi.bootstrap(reportContainer, { type: "report" });

    fetch(this.urlValue).then(response => response.json()).then(embedConfig => {
      const reportLoadConfig = {
        type: "report",
        tokenType: pbi.models.TokenType.Embed,
        accessToken: embedConfig.token,
        embedUrl: embedConfig.reports_detail.embed_url,
        settings: {
          // background: pbi.models.BackgroundType
          panes: {
            bookmarks: {
              visible: false
            },
            fields: {
              expanded: false
            },
            filters: {
              expanded: false,
              visible: false
            },
            pageNavigation: {
              visible: false
            },
            selection: {
              visible: true
            },
            syncSlicers: {
              visible: true
            },
            visualizations: {
              expanded: false
            }
          }
        }
      };
      powerbi.embed(reportContainer, reportLoadConfig);
      const iframe = document.getElementsByTagName("iframe")[0];
      iframe.style.borderRadius = "25px"; 
    });
  }
}
