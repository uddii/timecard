class SlackController < ApplicationController
    def top
    
    end
    def slackmessage
        json= JSON.parse(request.body.read)
        token = json.parameter.token;
        if token != "gG82JQaDj6NNRSubJKQtvNPs"
            return
        end
        text = json.parameter.text;
         message = 'Outgoing 成功';
        notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
        notifier.ping(text)
   
    end
end
