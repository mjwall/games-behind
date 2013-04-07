require_relative "models.rb"
require 'mail'

class Fetcher
  private_class_method :new

  def initialize
    @data_dir = File.dirname(__FILE__) + "/../data"
    @msg = ""
    msg_append "Data directory: #{@data_dir}"
  end

  def data_dir
    @data_dir ||= raise RuntimeError.new "Data directory not set"
  end

  def msg
    @msg
  end

  def msg_append txt
    @msg += "#{txt}\n"
  end

  def send_mail?
    @send_mail || false
  end

  def set_mail_send
    @send_mail = true
  end

  def mail
    @mail ||= Mail.new do
      from 'mjwall@gmail.com'
      to 'mjwall@gmail.com'
      subject 'Fetcher called'
      delivery_method :sendmail
    end
  end

  def mail_add_file daily
    mail.add_file :filename => daily.file_name, :content => daily.xml
  end

  def deliver_mail
    if send_mail?
      mail.text_part { body msg }
      mail.delivery_method :sendmail
      mail.deliver
      msg_append "Mail sent"
    else
      msg_append "No mail sent"
    end
  end

  def fetch daily_method, *date_str
    begin
      msg_append "Calling Daily.#{daily_method} with #{date_str}"
      remote = Daily.send(daily_method.to_sym, *date_str)
      remote.persist_to data_dir
      mail_add_file remote
      set_mail_send
    rescue => e
      if e.message.match("Not overwriting, same file already exists")
        msg_append "#{e.message}"
      else
        msg_append "Error:"
        msg_append "#{e.message}: #{e.class}"
        e.backtrace.map do |ex|
          msg_append "#{ex}"
        end
        set_mail_send
      end
    end
  end

  def self.hourly_fetch
    fetcher = Fetcher.send(:new)
    fetcher.fetch "yesterday_source"
    fetcher.fetch "latest_source"
    fetcher.deliver_mail
    fetcher.msg
  end

  def self.fetch_for date_str
    fetcher = Fetcher.send(:new)
    fetcher.fetch "source", date_str
    fetcher.msg
  end
end
