require 'Twitter'

SEVEN_DAYS = 60*60*24*7

Twitter.configure do |config|
	config.consumer_key = 'TWITTER_APP_CONSUMER_KEY'
	config.consumer_secret = 'TWITTER_APP_CONSUMER_SECRET'

	config.oauth_token = 'USERS_OAUTH_TOKEN'
	config.oauth_token_secret = 'USERS_OAUTH_TOKEN_SECRET'
end

userInfo = {}
userCounts = {}
userCounts.default = 0

options = {:count => 200}

lastDate = Time.now
sevenDaysAgo = Time.now - SEVEN_DAYS

while lastDate > sevenDaysAgo
	for t in Twitter.home_timeline(options) do
	
		userCounts[t.user.id] += 1
		userInfo[t.user.id] = t.user.screen_name

		if lastDate > t.created_at
			lastDate = t.created_at
			options[:max_id] = t.id - 1
		end
	
	end
end

for userId, count in userCounts.sort_by {|k, v| v} do
	puts "#{userInfo[userId]}: #{count}"
end
