HoptoadNotifier.configure do |config|
   config.api_key = {:project => 'weathersite', # the identifier you specified for your project in Redmine
                     :tracker => 'Bug - web app',                           # the name of your Tracker of choice in Redmine
                     :api_key => 'MUqEWiVNXUxp61u77uNR',            # the key you generated before in Redmine (NOT YOUR HOPTOAD API KEY!)
                     :assigned_to => 'ordwaye',                     # the login of a user the ticket should get assigned to by default (optional.)
                     :priority => 5                               # the default priority (use a number, not a name. optional.)
                    }.to_yaml
   config.host = 'rails.evergreen.edu'                            # the hostname your Redmine runs at
   config.suburi = 'accomphelp'
   config.port = 80                                              # the port your Redmine runs at
   config.secure = false                                           # sends data to your server via SSL (optional.)
 end
