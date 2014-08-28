require_relative 'serializable'

class Reaction
  require 'json'

  include Serializable

  attr_reader :title, :url, :image, :no, :feed

  def initialize(params)
    @title, @url, @image, @feed, @id = params.values_at(:title, :url, :image, :feed, :id)
  end
end