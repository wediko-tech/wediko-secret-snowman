class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.wediko_notification_address
  layout "mailer/mailer_layout"
end
