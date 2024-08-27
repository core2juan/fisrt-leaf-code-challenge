require 'rails_helper'

RSpec.describe 'API::Clients', type: :request do
  describe 'GET /api/users' do
    subject(:parsed_response) { JSON.parse(response.body) }

    context 'when there are records to show' do
      let!(:users) { create_list(:user, 10, :valid) }
      let(:matching_template) do
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
end
