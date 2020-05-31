# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'slack-notifier'

url = 'https://bosyu.me/b'
url_prefix = 'https://bosyu.me'
slack_url = 'https://hooks.slack.com/services/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'

charset = nil

html = open(url) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)
doc.xpath('//a[@class="saishin-want-list__card"]').each do |node|
  diff = Time.now - Time.parse(node.css('time').attribute('title').text)
  break if diff / 60 > 60

  link = url_prefix + node[:href]

  notifier = Slack::Notifier.new(slack_url)
  notifier.ping(link, unfurl_links: true)
end
