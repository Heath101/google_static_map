require_relative '../../lib/google_static_map_signature/signed_url'

module GoogleStaticMapSignature
  describe SignedURL do
    let(:base_url) { "http://www.example.com/foo" }

    describe :initialize do

      it 'should throw an error when client parameter is not provided' do
        expect{
          SignedURL.new(base_url, double)
        }.to raise_error SignedURL::MissingKey
      end

      it 'should throw an error when parameter includes client word' do
        expect{
          SignedURL.new("#{base_url}?foo=bar&my_client=baz", double)
        }.to raise_error SignedURL::MissingKey, 'The `client` parameter must be included'
      end

      it 'should throw an error when key parameter is included' do
        expect{
          SignedURL.new("#{base_url}?client=boo&key=aeiou", double)
        }.to raise_error SignedURL::InvalidKey, 'The `key` parameter may not be present in a signed url'
      end
    end

    describe :to_s do
      let(:url) { "#{base_url}?bar=|baz|&client=gme-company" }

      it 'should add signature to query string' do
        expect(SignedURL.new(url, "").to_s).to match('&signature=')
      end

      it 'should correctly sign the url' do
        path_and_query = URI.encode('/foo?bar=|baz|&client=gme-company')
        expect(Base64).to receive(:decode64).with("Foo").and_return('raw_api_key')
        expect(OpenSSL::HMAC).to receive(:digest).with('sha1', 'raw_api_key', path_and_query).and_return('digested_value')
        expect(Base64).to receive(:encode64).with('digested_value').and_return('the_answer')
        expect(SignedURL.new(url, "Foo").to_s).to match 'the_answer'
      end
    end
  end
end
