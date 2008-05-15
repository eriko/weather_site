class AdminController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "admin_layout" }
before_filter CASClient::Frameworks::Rails::Filter
          before_filter :can_i
    active_scaffold :admin do |config| 
    end
end
