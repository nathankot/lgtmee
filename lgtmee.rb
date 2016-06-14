require 'github_api'
require 'sinatra'
require 'puma'
require 'json'

if ENV['WEBHOOK_SECRET'].nil?
  puts "WARNING, proceeding without a configured secret,"
  puts "This disables webhook validation"
end

if ENV['GITHUB_USER'].nil?
  puts "Please set GITHUB_USER to continue"
  exit 1
end

if ENV['GITHUB_ACCESS_TOKEN'].nil?
  puts "Please set GITHUB_ACCESS_TOKEN to continue"
  exit 1
end

github = Github.new do |config|
  config.endpoint = (ENV['GITHUB_SITE'] || 'https://github.com') << '/api/v3'
  config.site = ENV['GITHUB_SITE'] || 'https://github.com'
  config.user = ENV['GITHUB_USER']
  config.basic_auth = "#{ENV['GITHUB_USER']}:#{ENV['GITHUB_ACCESS_TOKEN']}"
  config.ssl = { verify: true }
end

# Keep list of emojii in memory
emojii = JSON.parse(File.open('emoji.json').read)

configure do
  set :server, :puma
end

post '/' do
  request.body.rewind
  body = request.body.read

  # Verify webhook origin
  unless ENV['WEBHOOK_SECRET'].nil?
    received_signature = request.env['HTTP_X_HUB_SIGNATURE']
    halt 412, 'X-HUB-SIGNATURE header missing' unless received_signature

    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(
                  OpenSSL::Digest.new('sha1'),
                  ENV['WEBHOOK_SECRET'],
                  body)

    halt 401, 'Bad signature' unless Rack::Utils.secure_compare(
                                        signature,
                                        received_signature)
  end

  data = JSON.parse body

  halt 422, "Bad Github event" unless request.env['X_GITHUB_EVENT'] == 'issue_comment'
  halt 422, "Only new comments are considered" unless data['action'] == 'created'

  issue_number = data['issue']['number']
  comment_sender = data['sender']['login']
  comment_body = data['comment']['body']
  repo_owner = data['repository']['owner']['login']
  repo_name = data['repository']['name']

  comment_sender_emoji = emojii[comment_sender]
  halt 204, "Commenter has no emoji registered" if comment_sender_emoji.nil?
  halt 204, "Comment does not contain a review emoji" unless comment_body.include? comment_sender_emoji

  github.issues.labels.add user: repo_owner,
                           repo: repo_name,
                           number: issue_number,
                           name: "reviewed:#{comment_sender}"

  status 201
end
