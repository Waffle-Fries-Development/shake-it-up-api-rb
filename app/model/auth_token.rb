class AuthToken
  def self.encode(payload, exp=24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV['SESSION_SECRET'])
  end
  def self.decode(token)
    payload = JWT.decode(token, ENV['SESSION_SECRET'])[0]
    DecodedAuthToken.new(payload)
  rescue
    nil # It will raise an error if it is not a token that was generated with our secret key or if the user changes the contents of the payload
  end
end