$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/namespace'
require 'rss'

require 'lib/feed'
require 'lib/feedparser'

class DevReactions < Sinatra::Application
  helpers Sinatra::JSON

  set :bind, '0.0.0.0'
  
  configure do
    set :json_content_type, :js, :charset => 'utf-8'

    @@requests_served = 0
    
    FEEDPARSER = FeedParser.new(
      Feed.new(
        :title       => 'DevOps Reactions',
        :feed_url    => 'http://devopsreactions.tumblr.com/rss',
        :regex       => %r{<img.+?src="(?<imageurl>https?://.+?)"},
        ),
      Feed.new(
        :title       => 'Infosec Reactions',
        :feed_url    => 'http://securityreactions.tumblr.com/rss',
        :regex       => %r{<img.+?src="(?<imageurl>https?://.+?)"},
        ),
      )
  end

  before do
    # Reload reactions every n requests
    if @@requests_served % 100 == 0
      @@requests_served = 0
      @@reactions = FEEDPARSER.reactions
    end

    @@requests_served += 1
  end

  # Index route
  get '/' do
    erb :reaction
  end

  namespace '/api' do
    namespace '/reactions' do
      # Returns a random reaction as JSON
      get '/random' do
        @reaction = @@reactions.sample
        if @reaction
          json({
            :count    => @@reactions.count,
            :reaction => @reaction.serialize
          }) 
        else
          status 404
        end
      end
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end