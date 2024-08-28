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
      let(:user) { create(:user, :valid) }
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
end
