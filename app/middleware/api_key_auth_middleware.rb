class ApiKeyAuthMiddleware
    def initialize(app)
      @app = app
    end
  
    def call(env)
      request = Rack::Request.new(env)
      expected_key = ENV['API_KEY']
      provided_key = request.get_header('HTTP_X_API_KEY')
  
      if provided_key != expected_key
        return [
          401,
          { 'Content-Type' => 'application/json' },
          [ { error: 'Unauthorized' }.to_json ]
        ]
      end
  
      @app.call(env)
    end
  end
  