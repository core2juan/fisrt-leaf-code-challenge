class AccountKeyRequestWorker
  include Sidekiq::Job
  sidekiq_options retry: 5

  sidekiq_retry_in do |count|
    10 * (count + 1)
  end

  def perform(user_id)
    AccountKeyGeneratorService.call(user: User.find(user_id))
  end
end
