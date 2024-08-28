require 'rails_helper'

RSpec.describe 'API::Clients', type: :request do
  subject(:parsed_response) { JSON.parse(response.body) }

  describe 'GET /api/users' do
    context 'when there are records to show' do
      let!(:users) { create_list(:user, 10, :valid) }
      let(:matching_template) do
        # By adding this reverse we also check the ordering by most recent first
        users.reverse.inject([]) do |accum, user|
          accum << hash_including(
            'email' => user.email,
            'phone_number' => user.phone_number,
            'full_name' => user.full_name,
            'key' => user.key,
            'account_key' => user.account_key,
            'metadata' => user.metadata
          )
        end
      end

      before { get api_users_path }

      it 'returns the payload in the expected format' do
        expect(parsed_response['users'].size).to eq(10)
        expect(parsed_response).to match({
          'users' => matching_template
        })
      end
    end
  end

  describe 'POST /api/users' do
    let(:params) do
      {
        email: 'valid@email.com',
        phone_number: '12345678',
        full_name: 'Foo Bar',
        metadata: 'male, 34, systems-engineer',
        password: 'a-password'
      }
    end

    context 'when the payload contains a valid record' do
      subject(:user) { User.first }

      before { post api_users_path, params: params }
      after { User.delete_all }

      it 'creates the user and returns the object in the expected format' do
        expect(response).to have_http_status(:ok)
        expect(parsed_response).to match(hash_including(
          'email' => user.email,
          'phone_number' => user.phone_number,
          'full_name' => user.full_name,
          'key' => user.key,
          'account_key' => user.account_key,
          'metadata' => user.metadata
        ))
      end
    end

    context 'when trying to create a user with missing keys' do
      %i[email password phone_number].each do |field|
        context "when the #{field} is not present" do
          before { post api_users_path, params: params.except(field) }

          it 'returns 422' do
            expect(response).to have_http_status(:unprocessable_entity)
            expect(parsed_response['errors']).to include("#{field.to_s.sub('_', ' ').capitalize} can't be blank")
          end
        end
      end
    end

    context 'when trying to create a user with duplicated fields' do
      let(:user) { create(:user, :valid) }

      %w[email phone_number].each do |field|
        context "when the #{field} is already present" do
          before { post api_users_path, params: params.tap{ |p| p[field] = user[field] } }

          it 'returns 422' do
            expect(response).to have_http_status(:unprocessable_entity)
            expect(parsed_response['errors']).to include("#{field.sub('_', ' ').capitalize} has already been taken")
          end
        end
      end
    end
  end
end
