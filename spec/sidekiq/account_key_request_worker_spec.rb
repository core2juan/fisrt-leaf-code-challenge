require 'rails_helper'
RSpec.describe AccountKeyRequestWorker, type: :job do
  describe '#perform' do
    let(:user) { create(:user, :valid) }

    subject { described_class.new.perform(user.id) }

    before { allow(AccountKeyGeneratorService).to receive(:call).and_return(true) }

    it 'calls the service class' do
      subject
      expect(AccountKeyGeneratorService).to have_received(:call).with(user: user)
    end
  end
end
