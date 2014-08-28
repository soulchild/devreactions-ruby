require_relative 'serializable'

class Feed
  include Serializable

  attr_reader :title, :feed_url, :regex

  def initialize(params)
    @title, @feed_url, @regex = params.values_at(:title, :feed_url, :regex)
  end

  def vars_to_serialize
    [:title, :feed_url]
  end
end