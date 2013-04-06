require_relative "models.rb"
require 'mail'

class Fetcher
  def self.fetch
    data_dir = File.dirname(__FILE__) + "/../data"
    mail = Mail.new do
      from 'mjwall@gmail.com'
      to 'mjwall@gmail.com'
      subject 'Rake fetch from openshift'
    end
    msg = "Run started at #{Time.now}\n"
    msg += "Data directory: #{data_dir}\n"
    #no need to send mail if no files are written and no exceptions are raised
    @send_mail = false

    begin
      msg += "Checking latest\n"
      latest = Daily.fetch_latest
      latest.persist_to data_dir
      mail.add_file :filename => latest.file_name, :content => latest.xml
      @send_mail = true
    rescue => e
      if e.message.match("Not overwriting, same file already exists")
        msg += "#{e.message}\n"
      else
        msg += "Error with latest\n"
        msg += "#{e.message}: #{e.class}\n"
        e.backtrace.map{|ex| msg += "#{ex}\n"}
        @send_mail = true
      end
    end

    begin
      msg += "Checking yesterdays\n"
      yesterdays = Daily.fetch_yesterday
      yesterdays.persist_to data_dir
      mail.add_file :filename => yesterdays.file_name, :content => yesterdays.xml
      @send_mail = true
    rescue => e
      if e.message.match("Not overwriting, same file already exists")
        msg += "#{e.message}\n"
      else
        msg += "Error with yestedays\n"
        msg += "#{e.message}: #{e.class}\n"
        e.backtrace.map{|ex| msg += "#{ex}\n"}
        @send_mail = true
      end
    end

    if @send_mail
      mail.text_part { body msg }
      mail.delivery_method :sendmail
      mail.deliver
    end

    msg
  end
end
