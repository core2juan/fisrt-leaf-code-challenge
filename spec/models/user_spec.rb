require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations,' do
    context 'Presence:' do
      let(:user) { build(:user) }

      %w[email password phone_number].each do |field|
        context "when the #{field} is not present" do
          it 'the record is not valid' do
            expect(user).to_not be_valid
            expect(user.errors.to_a).to include("#{field.sub('_', ' ').capitalize} can't be blank")
          end
        end
      end
    end

    context 'Uniqueness' do
      let(:user) { create(:user, :valid, account_key: '1ef52abe876cbb0cb47fca3192d655b0b52141e2362a2c160ddc513324e8f8a1') }
      let(:duplicated_user) { build(:user, :valid) }

      %w[account_key email phone_number].each do |field|
        context "when the #{field} is already present" do
          before { duplicated_user.assign_attributes({"#{field}": user[field]}) }

          it 'the record is not valid' do
            expect(duplicated_user).to_not be_valid
            expect(duplicated_user.errors.to_a).to include("#{field.sub('_', ' ').capitalize} has already been taken")
          end
        end
      end
    end
  end

  describe 'callbacks' do
    describe '#generate_key' do
      let(:user) { create(:user, :valid, key: nil) }

      it 'creates a random key for the user' do
        expect(user.key).to_not be_nil
      end
    end

    describe '#request_account_key' do
      let(:user) { create(:user, :valid, key: nil) }

      before { allow(AccountKeyRequestWorker).to receive(:perform_async).and_call_original }

      it 'queues the AccountKeyRequestWorker upon create only' do
        # Hitting save again to check the worker was queued once only
        user.save
        expect(AccountKeyRequestWorker).to have_received(:perform_async).with(user.id).once
      end
    end
  end
end
