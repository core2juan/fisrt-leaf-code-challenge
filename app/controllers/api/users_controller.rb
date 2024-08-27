module API
  class UsersController < ::APIController
    def index
      users = User.all
      render json: UserSerializer.render(users, root: :users), status: :ok
    end
  end
end
