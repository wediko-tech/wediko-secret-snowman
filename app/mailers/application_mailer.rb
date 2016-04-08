class ApplicationMailer < ActionMailer::Base
  default from: "snowman@wediko.org"
  layout "mailer/mailer_layout"
end
