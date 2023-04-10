module Analytics
  module OAuth
    class GetEmbedConfig
      SCOPE_BASE = ENV['SCOPE_BASE']
      CLIENT_ID = ENV['CLIENT_ID']
      CLIENT_SECRET = ENV['CLIENT_SECRET']
      WORKSPACE_ID = ENV['WORKSPACE_ID']
      REPORT_ID = ENV['REPORT_ID']
      TENANT_ID = ENV['TENANT_ID']

      def call
        access_token = get_access_token
        api_request_headers = get_api_request_headers(access_token)
        report_details = get_report_details(api_request_headers)
        embed_token = get_embed_token(api_request_headers, report_details['datasetId'])
        report_embed_config(report_details, embed_token)
      end

      private

      def get_access_token
        HTTParty.post("https://login.microsoftonline.com/#{TENANT_ID}/oauth2/v2.0/token",
          headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
          body: {
            grant_type: 'client_credentials',
            client_id: CLIENT_ID,
            client_secret: CLIENT_SECRET,
            scope: SCOPE_BASE
          }
        )['access_token']
      end

      def get_api_request_headers(access_token)
        {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{access_token}"
        }
      end

      def get_report_details(headers)
        api_url = "https://api.powerbi.com/v1.0/myorg/groups/#{WORKSPACE_ID}/reports/#{REPORT_ID}"
        HTTParty.get(api_url, headers: headers)
      end

      def get_embed_token(headers, dataset_id)
        embed_token_api_url = 'https://api.powerbi.com/v1.0/myorg/GenerateToken'
        request_payload = {
          reports: [{ id: REPORT_ID }],
          datasets: [{ id: dataset_id }],
          targetWorkspaces: [{ id: WORKSPACE_ID }]
        }
        HTTParty.post(embed_token_api_url, headers: headers, body: request_payload.to_json)['token']
      end

      def report_embed_config(report_details, embed_token)
        {
          report_details: {
            report_id: report_details['id'],
            report_name: report_details['name'],
            embed_url: report_details['embedUrl']
          },
          token: embed_token,
        }
      end
    end
  end
end
