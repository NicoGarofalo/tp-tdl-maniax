# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@example.com'
  layout 'mailer'
end
