class SlackController < ApplicationController
    protect_from_forgery :except => [:slackmessage,:count]
    require "date"
    def top
    
    end
    def slackmessage
        token = params[:token]
        if token != ENV['SLACK_OUTGOING_WEBHOOK_TOKEN']
            return
        end
        @userName = params[:user_id]
        text1 = params[:text]
        if params[:trigger_word] == '出勤'
            nowTime = DateTime.today 
            @start = Savetime.create(start: nowTime,who: @userName )
            text = "<@#{userName}>\n出勤を確認しました！！\n出勤時刻：#{nowTime.hour}時#{nowTime.minute}分#{nowTime.second}秒"
        elsif params[:trigger_word] == '退勤'
            nowTime = DateTime.today 
            @end = Savetime.create(end: nowTime,who: @userName)
        text = "<@#{userName}>\n本日もお疲れ様 (^_^)\n退勤時刻：#{nowTime.hour}時#{nowTime.minute}分#{nowTime.second}秒"
        redirect_to controller: 'slack', action: 'count', who: @userName
        else
            text = "<@#{userName}>\nもっとはたらけよ"
        end
        notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
        notifier.ping(text)
        
    end
    def count
        @start  = Savetime.where(who: params[:who]).last(2)
        @last = Savetime.where(who: params[:who]).last(1)
        @text = @last - @start 
        notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
        notifier.ping(@text)
    end
end
