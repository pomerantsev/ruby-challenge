class IssuesController < ApplicationController
  def index
    @backlog = Issue.backlog
    @in_progress = Issue.in_progress
    @done = Issue.done
  end
end
