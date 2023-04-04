class AnalyticsController < ApplicationController
  def index
    client_id = '278174c7-f71a-4ab2-bc89-cec8f35743fd'
    client_secret = 'FjE8Q~GenjpwRJTmo.IXLChSVC5ySZMfl~OX0cHO'
    workspace_id = '37eb2e81-7154-474e-98b7-663237ebfe67'
    report_id = 'fd8a101c-9fd5-4325-ad2e-4ee3d8ee7d7b'
    tenant_id = '5732da51-12ea-423c-8b24-e8b18a2bf516'

    response = HTTParty.post("https://login.microsoftonline.com/#{tenant_id}/oauth2/v2.0/token",
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
        body: {
          grant_type: 'client_credentials',
          client_id: client_id,
          client_secret: client_secret,
          scope: 'https://analysis.windows.net/powerbi/api/.default'
        }
      )
  
      embed_url_api = "https://api.powerbi.com/v1.0/myorg/groups/#{workspace_id}/reports/#{report_id}"
      access_token = response['access_token']
  
      embed_token_headers = {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{access_token}"
      }
  
      embed_token_response = HTTParty.get(embed_url_api, headers: embed_token_headers)
  
      dataset_id = embed_token_response['datasetId']
  
      form_data = {
        reports: [{ id: report_id }],
        datasets: [{ id: dataset_id }],
        targetWorkspaces: [{ id: workspace_id }]
      }
  
      embed_token_api = 'https://api.powerbi.com/v1.0/myorg/GenerateToken'
  
      result = HTTParty.post(embed_token_api, headers: embed_token_headers, body: form_data.to_json)
  
      @report_embed_config = {
        reports_detail: {
          report_id: embed_token_response['id'],
          report_name: embed_token_response['name'],
          embed_url: embed_token_response['embedUrl']
        },
        token: result['token'],
        expiry: result['expiration']
      }
  end
end