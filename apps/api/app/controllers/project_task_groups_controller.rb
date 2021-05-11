class ProjectTaskGroupsController < ApplicationController
  before_action :set_project, only: [:index]

  api :GET, '/projects/:slug/task_groups'
  def index
    @task_groups = TaskGroup.includes([
      tasks: :projects,
      user: [:streaks, avatar_attachment: :blob],
    ])
      .joins(tasks: :projects)
      .where(projects: { id: @project.id })
      .order(created_at: :desc)
      .group(:id)
      .page(params[:page])

    render "projects/task_groups/index"
  end

  private
    def set_project
      @project = Project.find_by_slug!(params[:id])
    end
end
