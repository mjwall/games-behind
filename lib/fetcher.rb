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
      todays = Daily.fetch_today
      stored = Daily.from_stored_file todays.stored_as[0..7], data_dir
      unless todays.same_as? stored
        msg += "Storing #{todays} to #{data_dir}"
        todays.persist_to data_dir
        mail.add_file :filename => todays.stored_as, :content => todays.xml
        mail.text_part { body msg }
        mail.delivery_method :sendmail
        mail.deliver
      else
        msg += "File already stored for #{todays}"
      end
    rescue Exception => e
      todays.persist_to data_dir if todays && stored.nil?
      msg = "There was an error at #{Time.now}\n"
      msg += "#{e.message}\n"
      msg += "fetched: #{todays.xml unless todays.nil?}\n"
      msg += "stored: #{stored.xml unless stored.nil?}"
      mail.text_part { body msg }
      mail.delivery_method :sendmail
      mail.deliver
    end
    msg
  end
end
