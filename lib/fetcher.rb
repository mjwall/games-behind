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
    msg = ""

    begin
      todays = Daily.fetch_latest
      stored = Daily.from_stored_file todays.stored_as[0..7], data_dir
      if (!todays.nil? && stored.nil?) || !todays.same_as?(stored)
        todays_filename = "#{todays.stored_as}"
        msg += "Storing #{todays} to #{data_dir}/#{todays_filename[0..3]}/#{todays_filename}"
        todays.persist_to data_dir, true
        mail.add_file :filename => todays.stored_as, :content => todays.xml
        mail.text_part { body msg }
        mail.delivery_method :sendmail
        mail.deliver
      else
        stored_filename = "#{stored.stored_as}"
        msg += "File same as stored #{data_dir}/#{stored_filename[0..3]}/#{stored_filename}"
      end
    rescue => ex
      msg = "There was an error at #{Time.now}\n"
      msg += "#{ex.message}: #{ex.class}\n"
      ex.backtrace.map{|e| msg += "#{e}\n"}
      unless todays.nil?
        mail.add_file :filename => "todays-#{todays.stored_as}", :content => todays.xml
      end
      unless stored.nil?
        mail.add_file :filename => "stored-#{stored.stored_as}", :content => stored.xml
      end
      mail.text_part { body msg }
      mail.delivery_method :sendmail
      mail.deliver
    end
    msg
  end
end
