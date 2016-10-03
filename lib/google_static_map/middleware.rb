require_relative './signed_url'

module GoogleStaticMap
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env
      if google_static_map_request?
        signed_url = SignedURL.new(url_with_client_param, api_key)
        [301, {'Location' => signed_url.to_s, 'Content-Type' => 'text/html', 'Content-Length' => '0'}, []]
      else
        @app.call(env)
      end
    end

    private

    attr_reader :env

    def google_static_map_request?
      env["REQUEST_PATH"] == '/google-static-map'
    end

    def url_with_client_param
      "#{map_host}?#{env['QUERY_STRING']}&client=#{client}"
    end

    def map_host
      "https://maps.googleapis.com/maps/api/staticmap"
    end

    def client
      ENV['GOOGLE_MAPS_CLIENT']
    end

    def api_key
      ENV['GOOGLE_MAPS_API_KEY']
    end
  end
end
