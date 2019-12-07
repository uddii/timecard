class SlackController < ApplicationController
    def top
    
    end
    def slackmessage
        notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
        notifier.ping('aaaaa')
        redirect_to action: 'top'
    end
end
