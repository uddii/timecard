class SlackController < ApplicationController
    protect_from_forgery :except => [:slackmessage,:count]
    require "date"
    def top
      
    end

    def getrank
        @rankdatas = Total.all.order(totalseconds: "DESC")
        respond_to do |format|
            format.html
            format.json { render json: {rankdatas: @rankdatas} }
         end
    end

    def slackmessage
        token = params[:token]
        if token != ENV['SLACK_OUTGOING_WEBHOOK_TOKEN']
            return
        end
        @userName = params[:user_id]
        text1 = params[:text]

        if params[:trigger_word] =='表示名'
            @text = params[:text].sub(/表示名/, '').gsub(" ", "")   
            @thistotal = Total.find_by(who: @userName)
            @thistotal.nickname = @text
            @thistotal.save
            return
        end
        if params[:trigger_word] =='ん、出勤してなくね？？'
            return
        elsif params[:trigger_word] =='ん、退勤してなくね？？'
            return
        end



        if params[:trigger_word] == '出勤'
           unless Savetime.where(who: @userName).last(1).first.nil?
            @last = Savetime.where(who: @userName).last(1).first
            if @last.end.nil?
                text = 'ん、退勤してなくね？？'
                notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
                notifier.ping(text)
                return
            else
            nowTime = Time.now
            @day = Date.new
            @start = Savetime.create(start: nowTime,who: @userName,day: @day )
            text = "<@#{@userName}>\n出勤を確認しました！！\n出勤時刻：#{@start.start.hour}時#{@start.start.min}分#{@start.start.sec}秒"
            end
        else
            nowTime = Time.now
            @day = Date.new
            @start = Savetime.create(start: nowTime,who: @userName,day: @day )
            text = "<@#{@userName}>\n出勤を確認しました！！\n出勤時刻：#{@start.start.hour}時#{@start.start.min}分#{@start.start.sec}秒"
        end
        elsif params[:trigger_word] == '退勤'
            @start  = Savetime.where(who: @userName).last(1).first
            if @start.start.nil?
                text = 'ん、出勤してなくね？？'
                notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
                notifier.ping(text)
                return
            else
            nowTime = Time.now
            @day = Date.new
            @end = Savetime.create(end: nowTime,who: @userName,day: @day )

            @text1 = @end.end.hour.to_i - @start.start.hour.to_i
            if @text1 ==  0
            @text2 = @end.end.min.to_i - @start.start.min.to_i
            elsif @text1 > 0 
                if @end.end.min.to_i < @start.start.min.to_i
                    @text2 = 60 - (@start.start.min.to_i -  @end.end.min.to_i)
                elsif @end.end.min.to_i >= @start.start.min.to_i
                    @text2 = @end.end.min.to_i - @start.start.min.to_i
                end
            end
        end

          @total = Total.find_by(who: @userName)
            unless @total.nil?
                @calTotalminutes = @total.totalminutes + @text2
                if  @calTotalminutes >= 60
                     @hourFromTotalMinutes = @calTotalminutes/60.to_f.floor
                     @total.totalhour = @total.totalhour + @text1 + @hourFromTotalMinutes
                     @total.totalminutes = @calTotalminutes - (60 * @hourFromTotalMinutes)
                     @total.totalseconds = @total.totalhour * 3600 + @total.totalminutes * 60 
                     @total.save
                else
                    @total.totalminutes = @calTotalminutes
                    @total.totalhour += @text1
                    @total.totalseconds =  @total.totalhour * 3600 + @total.totalminutes * 60 
                    @total.save
                end
                
            else
                @total = Total.create(who: @userName,totalhour: @text1, totalminutes: @text2)
            end
            text = "<@#{@userName}>\n本日もお疲れ様 (^_^)\n退勤時刻：#{@end.end.hour}時#{@end.end.min}分#{@end.end.sec}秒\n勤務時間：#{@text1}時間#{@text2}分\nトータルの勤務時間：#{ @total.totalhour}時間#{@total.totalminutes}分"
        else
            text = "<@#{@userName}>\nもっとはたらけよ"
        end
        notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
        notifier.ping(text)
        
    end
 
end
