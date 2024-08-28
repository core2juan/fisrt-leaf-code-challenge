module API
  class UsersController < ::APIController
    def index
      users = User.all
      render json: UserSerializer.render(users, root: :users), status: :ok
    end

    def create
      user = User.new(user_params)
      if user.save
        render json: UserSerializer.render(user), status: :ok
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
