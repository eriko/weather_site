# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3ebfd748a4a2ba6c747da4bb9a61f8ab'
   
   layout proc{ |c| c.request.xhr? ? false : "weather_layout" }


   def logout
        reset_session
        redirect_to CASClient::Frameworks::Rails::Filter.client.logout_url(request.referer)
      end
      
    ActiveScaffold.set_defaults do |config| 
      config.ignore_columns.add [:lock_version]
    end

    def can_i
      if !session[:admin_id]
        if session[:casfilteruser]
          if !(admin = Admin.find_by_username(session[:casfilteruser]))
            admin.username = session[:casfilteruser]
            admin.save 
            session[:admin_id] = admin.id
            return true
          else
            return false
          end
        else
          redirect_to :controller => :weather , :action => :index
        end
      else
        return true
      end
    end
    
end
