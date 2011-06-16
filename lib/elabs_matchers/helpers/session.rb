module ElabsMatchers
  module Session
    ##
    #
    # Logs the user into the system. Requires that you login with an email and password
    # and that your fields are named a certain way
    # as well as there being a new_user_session path available.
    #
    # @param [Object] record      The user record
    #
    # Example:
    # login_as(user)

    attr_reader :current_user

    def login_as(user)
      visit(new_user_session_path)
      fill_in('Email', :with => user.email)
      fill_in('Password', :with => user.password)
      click_button('Sign in')
      @current_user = user
    end
  end
end