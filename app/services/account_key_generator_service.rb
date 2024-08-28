class AccountKeyGeneratorService
  ACCOUNT_KEY_SERVICE_URL = 'https://w7nbdj3b3nsy3uycjqd7bmuplq0yejgw.lambda-url.us-east-2.on.aws/v1/accountss'.freeze
  HEADERS = { 'Content-Type'=> 'application/json' }.freeze

  class ServiceError < StandardError; end

  def initialize(user:)
    @user = user
  end

  def self.call(user:)
    self.new(user: user).call
  end

  def call
    response =  HTTParty.post(
      ACCOUNT_KEY_SERVICE_URL,
      headers: HEADERS,
      body: {
        email: @user.email,
        key:   @user.key
      }.to_json
    )

    if response.success?
      @user.update(account_key: response['account_key'])
    else
      raise ServiceError.new(response.message)
    end
  end
end
