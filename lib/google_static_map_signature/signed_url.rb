require 'base64'
require 'uri'
require 'openssl'

module GoogleStaticMapSignature
  class SignedURL
    class MissingKey < StandardError; end;
    class InvalidKey < StandardError; end;

    def initialize(url, api_key)
      @url = URI.encode(url)
      validate_required_params!
      check_for_invalid_params!
      @api_key = api_key
    end

    def to_s
      "#{url}&signature=#{signature}"
    end

    private
    attr_reader :url, :parsed_url, :api_key

    def validate_required_params!
      raise(MissingKey, 'The `client` parameter must be included') unless url.match(/(\?|&)client=/i)
    end

    def check_for_invalid_params!
      raise(InvalidKey, 'The `key` parameter may not be present in a signed url') if url.match(/(\?|&)key=/i)
    end

    def signature
      @signature ||=  url_safe_encode digest(raw_key, url_to_sign)
    end

    def url_safe_encode(input)
      Base64.encode64(input).tr('+/','-_')
    end

    def digest(key, data)
      OpenSSL::HMAC.digest('sha1', key, data)
    end

    def raw_key
      Base64.decode64(api_key.tr('-_','+/'))
    end

    def url_to_sign
      "#{parsed_url.path}?#{parsed_url.query}"
    end

    def parsed_url
      @parsed_url ||= URI.parse(url)
    end
  end
end
