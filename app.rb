require 'sinatra/base'
require 'rss'

class Feed
  attr_reader :title, :feed_url, :regex

  def initialize(params)
    @title = params[:title]
    @feed_url = params[:feed_url]
    @regex = params[:regex]
  end
end

class Reaction
  attr_reader :title, :url, :image, :no, :feed

  def initialize(params)
    @title = params[:title]
    @url = params[:url]
    @image = params[:image]
    @feed = params[:feed]
    @no = params[:no]
  end
end

class FeedParser
  attr_reader :feeds, :reactions

  def initialize
    @feeds = []
    @reactions = []
  end

  def add_feeds(*feeds)
    @feeds.push(*feeds)
  end

  def reactions
    feeds.each do |feed|
      parsed = RSS::Parser.parse(feed.feed_url)

      # Extract info from every item in the feed
      no = 0
      parsed.items.each do |item|
        feed.regex.match(item.description.to_s) do |m|
          @reactions << Reaction.new(
            :title => item.title,
            :image => m[:imageurl],
            :url   => item.link,
            :feed  => feed,
            :no    => no += 1
            )
        end
      end
    end

    @reactions
  end
end

class DevReactions < Sinatra::Application
  set :bind, '0.0.0.0'

  configure do
    @@no_of_requests_served = 0
    
    FEEDPARSER = FeedParser.new
    FEEDPARSER.add_feeds(
      Feed.new(
        :title       => 'DevOps Reactions',
        :feed_url    => 'http://devopsreactions.tumblr.com/rss',
        :regex       => %r{<img.+?src="(?<imageurl>https?://.+?)"},
        ),
      Feed.new(
        :title       => 'Security Reactions',
        :feed_url    => 'http://securityreactions.tumblr.com/rss',
        :regex       => %r{<img.+?src="(?<imageurl>https?://.+?)"},
        ),
      )
  end

  get '/' do
    # Reload reactions every n requests
    if (@@no_of_requests_served == 0 || @@no_of_requests_served >= 100)
      @@no_of_requests_served = 0
      @@reactions = FEEDPARSER.reactions
    end

    @@no_of_requests_served += 1

    @reaction = @@reactions.sample
    erb :reaction, { 
      :locals => { 
        :no_of_reactions => @@reactions.count 
      } 
    }
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end