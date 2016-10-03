require_relative '../../lib/google_static_map/middleware'

module GoogleStaticMap
  describe Middleware do
    it 'conforms to the rack middleware api' do
      expect{Middleware.new(double)}.not_to raise_error
    end

    describe :call do
      context 'for non static map requests' do
        it 'calls the next middleware' do
          app = double('app')

          expect(app).to receive(:call).with({})
          Middleware.new(app).call({})
        end
      end

      context 'with static map requests' do
        let(:app)    { double('app') }
        let(:env)    { {"REQUEST_PATH" => '/google-static-map'} }
        let(:result) { Middleware.new(app).call(env) }
        let(:status_code) { result[0] }
        let(:header)      { result[1] }
        let(:body)        { result[2] }

        before do
          allow(SignedURL).to receive(:new).and_return('a url')
        end

        it 'should not call next middleware app' do
          expect(app).not_to receive(:call)
          result
        end

        it 'should return a 301 status code' do
          expect(status_code).to eq 301
        end

        it 'should return correct location in header' do
          expect(header['Location']).not_to eq nil
          expect(header['Location']).to eq 'a url'
        end

        it 'should return correct content type in header' do
          expect(header['Content-Type']).to eq 'text/html'
        end

        it 'should return correct content type in header' do
          expect(header['Content-Length']).to eq '0'
        end

        it 'should return nothing for the body' do
          expect(body).to be_empty
        end
      end
    end
  end
end
