#!/usr/bin/env ruby

=begin notes

usage: cat (list of repo urls) | ./test-diff-canonical-to-v000.rb > results

Note: You can use track_output.py with its -c option to harvest the canonical
URLS for a track.

Example Input

https://github.com/learn-co-curriculum/welcome-to-learn-verified
https://github.com/learn-co-curriculum/intro-to-tic-tac-toe-rb
https://github.com/learn-co-curriculum/matz-readme
https://github.com/learn-co-curriculum/ruby-lecture-intro-what-is-a-program
https://github.com/learn-co-curriculum/hello-world-ruby

Example Output:

[OK] https://github.com/learn-co-curriculum/welcome-to-learn-verified
[OK] https://github.com/learn-co-curriculum/intro-to-tic-tac-toe-rb
[ERROR] https://github.com/learn-co-curriculum/matz-readme
[OK] https://github.com/learn-co-curriculum/ruby-lecture-intro-what-is-a-program
[OK] https://github.com/learn-co-curriculum/hello-world-ruby

=end

require 'octokit'
require 'dotenv'

Dotenv.load

class Comparer
  def initialize(client, io)
    @client = client
    @io = io
  end

  def report
    urls.each do |url|
      canonical_reponame = url.sub(/.*github.com\//,'')
      web_class_reponame = canonical_reponame.sub('curriculum', 'students') + '-v-000'

      begin
      sha1, sha2 = [last_sha_for_repo(canonical_reponame), last_sha_for_repo(web_class_reponame)]
      rescue Octokit::NotFound => e
        puts "[NOT FOUND] #{url}: #{e.message}"
      end

      puts sha1 == sha2 ? "[OK] #{url}" :  "[ERROR] #{url}"
    end
  end

  def last_sha_for_repo(repo)
    all_commits = @client.commits(repo)
    commit_obj = all_commits.first.to_h
    sha_url = commit_obj[:commit][:url]
    sha_url.split('/').last
  end

  def urls
    @io.split("\n")
  end
end

client = Octokit::Client.new(
  :client_id => ENV["GH_OAUTH_APPID"],
  :client_secret => ENV["GH_OAUTH_APP_SECRET"]
)

Comparer.new(client, STDIN.read()).report
