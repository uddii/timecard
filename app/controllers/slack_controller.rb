class SlackController < ApplicationController
    protect_from_forgery :except => [:slackmessage]

    def top
    
    end
    def slackmessage
        token = params[:token]
        if token != "XoeXsgC2PcytS5cuiazz7fSh"
            return
        end
        userName = params[:user_id]
        text1 = params[:text]
        text = "@#{userName}"
        notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
        notifier.ping(text)
   
    end
end
