class DescriptionController < ApplicationController
layout proc{ |c| c.request.xhr? ? false : "admin_layout" }  
before_filter CASClient::Frameworks::Rails::Filter
          before_filter :can_i
    active_scaffold :description do |config| 
    end
end
