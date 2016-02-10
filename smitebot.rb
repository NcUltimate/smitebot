require 'snoo'
require 'smite'

class SmiteBot
  MYNAME = 'SmiteInfoBot'

  attr_reader :reddit, :smite, :username

  def initialize(reddit_user, reddit_pass, dev_id, api_auth)
    @reddit = Snoo::Client.new
    @reddit.log_in reddit_user, reddit_pass
    @username = reddit_user

    Smite::Game.authenticate!(dev_id, api_auth)
  end

  def get_top_100_posts
    posts = reddit.get_listing(subreddit: 'smite', limit: 1000)
    posts['data']['children'].map { |l| l['data']['id']}
  end

  def get_all_comments(parent)
    comments = []
    return comments if parent.nil? || parent['data'].nil?

    children  = parent['data']['children']
    return comments if children.empty?

    children.each do |reply|
      replies = reply['data']['replies']
      next unless replies

      reply_data = replies['data']
      next unless reply_data

      reply_children  = reply_data['children']
      reply_authors   = reply_children.map { |r| r['data']['author'].downcase }
      if !reply_authors.include?(MYNAME.downcase) && reply['data']['author'].downcase != MYNAME.downcase 
        comments << [reply['data']['id'], reply['data']['body']]
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
        scanned_body: comment[1].scan(/\{\{(.+?)\}\}/).flatten.map(&:downcase)
      }
    end
    comments.reject { |comment| comment[:scanned_body].empty? }
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