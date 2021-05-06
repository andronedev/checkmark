class Task < ApplicationRecord
  include ActionDispatch::Routing::PolymorphicRoutes
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :task_group, optional: true
  belongs_to :streak, optional: true
  has_many :task_likes
  has_many :task_comments
  has_and_belongs_to_many :projects
  has_many_attached :images

  enum state: [
    :todo,
    :doing,
    :done
  ]

  before_create :assign_projects
  before_create :assign_task_group, if: Proc.new { |task| task.task_group.nil? }
  before_create :assign_streak, if: Proc.new { |task| task.streak.nil? }
  after_create :notify_webhooks

  def assign_projects
    matches = self.content.scan(/#(\w*)/)

    matches.each do |match|
      project = Project.find_by_slug(match)
      if project.present? && !self.projects.exists?(project.id)
        self.projects << project
      end
    end
  end

  def assign_task_group
    timezone = self.user.timezone
    task_group = self.user.task_groups.where(created_at: DateTime.now.in_time_zone(timezone).beginning_of_day..DateTime.now.in_time_zone(timezone).end_of_day).first
    if task_group.nil?
      task_group = TaskGroup.new()
      task_group.user = self.user
      task_group.save!
    end

    self.task_group = task_group
  end

  def assign_streak
    last_streak = self.user.last_streak
    if last_streak.nil?
      last_streak = Streak.new
      last_streak.user = self.user
      last_streak.save!
    end

    last_task = last_streak.tasks.order(created_at: :desc).first

    if last_task.present? && last_task.created_at.to_datetime.beginning_of_day < DateTime.yesterday
      last_streak = Streak.new
      last_streak.user = self.user
      last_streak.save!
    end

    self.streak = last_streak
  end

  private
    def notify_webhooks
      Webhook.all.each do |webhook|
        data = ApplicationController.render(template: 'webhook_job/task_created', assigns: {
          task: self
        })

        WebhookJob.perform_later(webhook, 'task.created', data)
      end
    end

end
