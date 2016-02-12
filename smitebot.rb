require 'snoo'
require 'smite'
require 'set'
require_relative './smite_parser.tab.rb'

class SmiteBot
  SUBREDDIT = 'smiteinfobot'
  MYNAME = 'SmiteInfoBot'

  attr_reader :reddit, :smite, :username, :parser

  def initialize(reddit_user, reddit_pass, dev_id, api_auth)
    @reddit   = Snoo::Client.new
    @username = reddit_user
    success   = true

    success &&= Smite::Game.authenticate!(dev_id, api_auth)
    success &&= @reddit.log_in reddit_user, reddit_pass
    raise StandardError.new('Could not authenticate') unless success

    @parser = SmiteParser.new
  end

  def get_top_100_posts
    posts = reddit.get_listing(subreddit: SUBREDDIT, limit: 1000)
    posts['data']['children'].map { |l| l['data']['id']}
  end

  def get_all_comments(parent)
    comments = []
    return comments if parent.nil? || parent['data'].nil?

    children  = parent['data']['children']
    return comments if children.empty?

    children.each do |reply|
      replies     = reply['data']['replies']
      i_made_this = reply['data']['author'].downcase == MYNAME.downcase 

      if replies.empty?# && !i_made_this
        comments << [reply['data']['id'], reply['data']['body']]
        next
      else
        reply_children  = reply['data']['children']
        reply_authors   = reply_children.map { |r| r['data']['author'].downcase }
        # if !reply_authors.include?(MYNAME.downcase)# && !i_made_this
          comments << [reply['data']['id'], reply['data']['body']]
        # end
      end

      comments += get_all_comments(replies)
    end

    comments
  end

  def comments_that_need_reply(post_id)
    comments = reddit.get_comments(link_id: post_id, limit: 1000, depth: 1000)
    comments = get_all_comments(comments[1]).map do |comment|
      { 
        id:           comment[0],
        scanned_body: comment[1].scan(/\{\{(.+?)\}\}/).flatten.map { |k| k.downcase.strip }
      }
    end
    comments = comments.reject { |comment| comment[:scanned_body].empty? }
    comments.map { |comment| comment[:scanned_body].map { |req| parser.parse(req) } }
  end

  def run!
    puts "Scanning posts..."
    loop do
      posts = get_top_100_posts
      posts.each do |post_id|
        comments = comments_that_need_reply(post_id)
        sleep(0.5)
        next if comments.empty?
        p comments
      end
      sleep(200)
    end
  end
end