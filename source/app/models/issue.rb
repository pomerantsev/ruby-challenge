class Issue
  def self.backlog
    @issues ||= Issue.get_issues
    @issues.select { |issue| issue['state'] == 'open' && !issue['pull_request']['html_url'] }
  end

  def self.in_progress
    @issues ||= Issue.get_issues
    @issues.select { |issue| issue['state'] == 'open' && issue['pull_request']['html_url'] }
  end

  def self.done
    @issues ||= Issue.get_issues
    @issues.select { |issue| issue['state'] == 'closed' }
  end

  private

  def self.get_issues
    issues_by_state = {}
    %i(open closed).each do |state|
      issues_by_state[state] = HTTParty.get "https://api.github.com/repos/sinatra/sinatra/issues?state=#{state}&per_page=50",
                                            headers: { 'User-Agent' => 'pomerantsev' }
    end
    (issues_by_state[:open] + issues_by_state[:closed])
      .sort_by { |issue| issue['created_at'] }
      .last(50)
      .reverse
  end
end
