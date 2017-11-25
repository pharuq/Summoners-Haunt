# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

WillPaginate::ViewHelpers.pagination_options[:previous_label] = '&lt 前へ'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '次へ &gt'

Time::DATE_FORMATS[:datetime] = "%Y年%m月%d日 %H時%M分"
Time::DATE_FORMATS[:date] = "%Y年%m月%d日"
Time::DATE_FORMATS[:time] = "%H時%M分"
