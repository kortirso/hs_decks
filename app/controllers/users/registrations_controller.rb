module Users
    class RegistrationsController < Devise::RegistrationsController
        skip_before_action :verify_authenticity_token, only: %i[create destroy]
        skip_before_action :check_access, only: :create
    end
end
