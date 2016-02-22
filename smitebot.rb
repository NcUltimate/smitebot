require 'snoo'
require 'smite'
require 'set'
require 'pry'

require_relative './smite_parser.tab.rb'
require_relative './smite_formatter.rb'

class SmiteBot
  SUBREDDIT = 'smite'
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

    # Get the replies of this comment
    children  = parent['data']['children']
    return comments if children.empty?

    # For each reply
    children.each do |reply|
      # Get reply data (not actual replies)
      replies     = reply['data']['replies']

      # get author of parent comment
      next unless reply['data']['author']
      i_made_this = reply['data']['author'].downcase == MYNAME.downcase 

      # binding.pry
      # no reply data
      if replies.empty?
        comments << [reply['data']['id'], reply['data']['body']] if !i_made_this
        next
      else
        # get actual replies
        reply_children  = replies['data']['children']

        # skip if there are none
        next if reply_children.nil?

        # otherwise, map to the authors
        reply_authors   = reply_children.map do |r| 
          r['data']['author'] ? r['data']['author'].downcase : nil
        end
        if !reply_authors.include?(MYNAME.downcase) && !i_made_this
          comments << [reply['data']['id'], reply['data']['body']]
        end
      end

      comments += get_all_comments(replies)
    end

    comments
  end

  def comments_that_need_reply(post_id)
    comments = reddit.get_comments(link_id: post_id, limit: 1000, depth: 1000)
    comments = get_all_comments(comments[1]).map do |comment|
      { 
        id:       comment[0],
        requests: comment[1].scan(/\{\{(.+?)\}\}/).flatten.map { |k| k.downcase.strip }
      }
    end
    comments.reject { |comment| comment[:requests].empty? }
  end

  def process_replies(comments)
    comments.each do |comment|
      comment[:requests].map! do |req|
        parsed = parser.parse(req) rescue nil
        next "" unless parsed

        SmiteFormatter.format!(parsed) rescue nil
      end
    end
    comments.each do |comment|
      next if comment[:requests].compact.empty?

      puts "Commenting on t1_#{comment[:id]}"
      reddit.comment(comment[:requests].join("\n\n"), 't1_'+comment[:id])
      sleep(2)
    end
  end

  def run!
    loop do
      begin
        posts = get_top_100_posts
        posts.each_with_index do |post_id, idx|
          puts "(#{idx} / #{posts.count}) Finding comments that need reply..."
          comments = comments_that_need_reply(post_id)
          sleep(2)
          next if comments.empty?

          puts "processing replies..."
          process_replies(comments)
        end
      rescue
      ensure
        sleep(10)
      end
    end
  end
end