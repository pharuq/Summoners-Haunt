class ApplicationMailer < ActionMailer::Base
  default charset: 'ISO-2022-JP',
              from: 'summoners.haunt@gmail.com'
  layout 'mailer'
end
