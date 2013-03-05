require 'rack/utils'

# This middleware allows flash applications to
# pass the session id as a parameter in the request
class FlashSessionCookieMiddleware
  def initialize(app, session_key = '_session_id')
    @app = app
    @session_key = '_session_id'
  end

  def call(env)


    req = Rack::Request.new(env)
 #REALP
      #Rails.logger.info("MID PARAMS: #{req.params.inspect}")
      #Rails.logger.info("MID cookies: #{req.cookies.inspect}")
      #Rails.logger.info("MID env: #{env.inspect}")
      #Rails.logger.info("MID param session_key: #{req.params[@session_key]} - #{@session_key}")

    unless req.params[@session_key].nil?
      env['HTTP_COOKIE'] = [ @session_key, req.params[@session_key] ].join('=').freeze unless req.params[@session_key].nil?

      env['HTTP_ACCEPT'] = "#{req.params['_http_accept']}".freeze unless req.params['_http_accept'].nil?
      #Rails.logger.info("MID REQ env HTTP_COOKIE: #{env['HTTP_COOKIE']}")
    end

    @app.call(env)
  end
end

