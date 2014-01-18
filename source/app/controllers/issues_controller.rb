class IssuesController < ApplicationController
  def index
    issues_by_state = {}
    %i(open closed).each do |state|
      issues_by_state[state] = HTTParty.get "https://api.github.com/repos/sinatra/sinatra/issues?state=#{state}&per_page=50",
                                            headers: { 'User-Agent' => 'pomerantsev' }
    end
    @all_issues = (issues_by_state[:open] + issues_by_state[:closed])
      .sort_by { |issue| issue['created_at'] }
      .last(50)
      .reverse
  end
end
