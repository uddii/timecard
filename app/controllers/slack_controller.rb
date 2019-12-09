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
            nowTime = Time.now
            @day = Date.new
            @start = Savetime.create(start: nowTime,who: @userName,day: @day )
            text = "<@#{@userName}>\n出勤を確認しました！！\n出勤時刻：#{@start.hour}時#{@start.min}分#{@start.sec}秒"
        elsif params[:trigger_word] == '退勤'
            nowTime = Time.now
            @day = Date.new
            @end = Savetime.create(end: nowTime,who: @userName,day: @day )
            @start  = Savetime.where(who: @userName).last(2).first
        @text1 = @end.hour.to_i - @start.start.hour.to_i
        @text2 = @end.min.to_i - @start.start.min.to_i
        @text3 = @end.sec.to_i - @start.start.sec.to_i

        text = "<@#{@userName}>\n本日もお疲れ様 (^_^)\n退勤時刻：#{@end.hour}時#{@end.min}分#{@end.sec}秒\n勤務時間：#{@text1}時間#{@text2}分#{@text3}秒"

        else
            text = "<@#{@userName}>\nもっとはたらけよ"
        end
        notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
        notifier.ping(text)
        
    end
    def count
        
        
    end
end
