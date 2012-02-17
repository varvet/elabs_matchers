module ElabsMatchers
  module Helpers
    module Session
      ##
      # Can be used to keep track of the current signed in user.
      # If you use signed_in_as(user) this will be done automaticly.

      attr_reader :current_user

      ##
      # @deprecated Please use sign_in instead
      # Logs the user into the system. Requires that you login with an email and password
      # and that your fields are named a certain way
      # as well as there being a new_user_session path available.
      #
      # @param [Object] record      The user record
      #
      # Example:
      # login_as(user)

      def login_as(user)
        warn "[DEPRECATION] `login_as(user)` is deprecated.  Please use `sign_in` instead."

        visit(new_user_session_path)
        fill_in("Email", :with => user.email)
        fill_in("Password", :with => user.password)
        click_button("Sign in")
        @current_user = user
      end

      ##
      # Set's a global variable that can be used to fake authentication
      # when running acceptance tests. This is much faster then using
      # the sign in form everytime but requires you to make a small change
      # to your application code. Please see [View source] for details.
      #
      # @param [Object] record      The user record
      #
      # Example:
      # sign_in_as(user)

      def sign_in_as(user = nil)
        $signed_in = true
        @current_user = user

        # Your authentication filter should look something like:
        #
        # class ApplicationController < ActionController::Base
        #   before_filter :authenticate
        #
        #   private
        #
        #   def authenticate!
        #     redirect_to :new_sessions_url unless authenticated?
        #   end
        #
        #   def authenticated?
        #     $signed_in or begin
        #       # Do your normal authentication logic here.
        #       # E.g:
        #       @current_user = User.find(session[:user_id]) if session[:user_id].present?
        #     end
        #   end
        # end
      end
      alias :sign_in :sign_in_as

      ##
      # See sign_in for details.
      #
      # Example:
      # sign_out
      #

      def sign_out
        $signed_in = false
        @current_user = nil
      end
    end
  end
end