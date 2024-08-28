module API
  class UsersController < ::APIController
    PERMITTED_QUERY_FIELDS = [
      'email',
      'full_name',
      'metadata'
    ].freeze

    def index
      if (query_params.keys - PERMITTED_QUERY_FIELDS).any?
        render json: { errors: ['Not valid query parameters'] }, status: :unprocessable_entity
      else
        users = User.all
        users = users.where(email: params[:email])         if params[:email].present?
        users = users.where(full_name: params[:full_name]) if params[:full_name].present?
        users = users.by_metadata(params[:metadata])       if params[:metadata].present?

        render json: UserSerializer.render(users, root: :users), status: :ok
      end
    end

    def create
      user = User.new(user_params)
      if user.save
        render json: UserSerializer.render(user), status: :created
      else
        render json: { errors: user.errors.to_a }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      # Expected payload was not described in the README.md.
      # Assumed a plain json containing and permitting only
      # the expected keys.
      params.permit(:email, :phone_number, :full_name, :metadata, :password)
    end
  end
end
