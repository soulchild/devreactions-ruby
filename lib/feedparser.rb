require_relative 'reaction'

class FeedParser
  attr_reader :feeds, :reactions

  def initialize(*feeds)
    @feeds = []
    self.add_feeds(*feeds)
  end

  def add_feeds(*feeds)
    self.feeds.push(*feeds)
  end

  def reactions
    reactions = Array.new

    feeds.each do |feed|
      parsed = RSS::Parser.parse(feed.feed_url)

      # Extract info from every item in the feed
      id = 0
      parsed.items.each do |item|
        feed.regex.match(item.description.to_s) do |m|
          reactions << Reaction.new(
            :title => item.title,
            :image => m[:imageurl],
            :url   => item.link,
            :feed  => feed,
            :id    => id += 1
            )
        end
      end
    end

    reactions
  end
end