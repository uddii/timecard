class SlackController < ApplicationController
    protect_from_forgery :except => [:slackmessage]
    require "date"
    def top
    
    end
    def slackmessage
    
       
        token = params[:token]
        if token != "XoeXsgC2PcytS5cuiazz7fSh"
            return
        end
        userName = params[:user_id]
        text1 = params[:text]
        if params[:trigger_word] == '出勤'
            now = Date.today 
            text = "<@#{userName}>\n出勤を確認しました！！\n打刻時刻：#{now}"
        elsif params[:trigger_word] == '退勤'
            now = Date.today 
        text = "<@#{userName}>\n本日もお疲れ様 (^_^)\n打刻時刻：#{now}"
        else
            text = "<@#{userName}>\nもっとはたらけよ"
        end
        notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
        notifier.ping(text)
        
    end
end
