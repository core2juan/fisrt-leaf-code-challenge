require 'rails_helper'
RSpec.describe AccountKeyGeneratorService, type: :service do
  describe '.call' do
    let(:user) { create(:user, :valid) }
    let(:response_mock) do
      instance_double('HTTPartyResponsemock', success?: success, message: message).tap do |mock|
        allow(mock).to receive(:[]).with('account_key').and_return(account_key)
      end
    end

    subject { described_class.call(user: user) }

    before { allow(HTTParty).to receive(:post).and_return(response_mock) }

    context 'when the response is success' do
      let(:success) { true }
      let(:message) { 'ok' }
      let(:account_key) { '1ef52abe876cbb0cb47fca3192d655b0b52141e2362a2c160ddc513324e8f8a1' }

      it 'updates the user account_key' do
        expect { subject }.to change(user, :account_key)
        expect(user.reload.account_key).to eq(account_key)
      end
    end

    context 'when the response fails' do
      let(:success) { false }
      let(:message) { 'Unprocessable Entity' }
      let(:account_key) { '' }

      it 'does not update the user account_key' do
        expect { subject }.to raise_error(AccountKeyGeneratorService::ServiceError)
        expect(user.reload.account_key).to be_nil
      end
    end

  end
end
