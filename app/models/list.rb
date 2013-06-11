class List < ActiveRecord::Base
  attr_accessible :completed, :description, :finished_at, :public, :title, :user_id, :tasks_attributes

  #Relations
  belongs_to :user, :validate => true
  has_many :tasks, :inverse_of => :list, :dependent => :destroy
  has_many :favorites, :dependent => :destroy

  accepts_nested_attributes_for :tasks, :allow_destroy => true


  #Validations
  validates_presence_of :title
  validates_presence_of :user
  validate :check_if_the_date_is_valid

  after_save :complete_tasks_if_the_list_is_complete

  def complete_the_tasks_that_have_not_yet_been_completed
    self.finished_at = Time.now
    self.completed = true
    self.save!
    Task.where(:list_id => self.id, :completed => false).update_all(:completed => true, :finished_at => self.finished_at)
  end

  def undo_all_tasks
    self.finished_at = nil
    self.completed = false
    self.save!
    Task.where(:list_id => self.id).update_all(:completed => false, :finished_at => nil)
  end

  def all_tasks_completed?
    self.tasks.where(:completed =>false).count == 0
  end

  def self.load_public_lists_except(user)
    except_list = user.favorites
    if except_list.size == 0
      List.where("public = ? AND user_id <> ?", true, user.id)
    else
      List.where("public = ? AND user_id <> ? AND id NOT IN (?)", true, user.id, except_list.map{|l| l.list_id})
    end
  end

  def self.load_public_lists_by_condition_except(user, query)
    query = query.to_s
    if query.blank?
      self.load_public_lists_except(user)
    else
      query = "%#{query.to_s.upcase}%"
      except_list = user.favorites
      if except_list.size == 0
        List.where("public = ? AND user_id <> ? AND (upper(title) like ? OR upper(description) like ?)", true, user.id, query, query)
      else
        List.where("public = ? AND user_id <> ? AND (upper(title) like ? OR upper(description) like ?) AND id NOT IN (?)", true, user.id, query, query, except_list.map{|l| l.list_id})
      end
    end
  end

  private

  def complete_tasks_if_the_list_is_complete
    if self.completed?
      Task.where(:list_id => self.id, :completed => false).update_all(:completed => true, :finished_at => self.finished_at)
    end
  end

  def check_if_the_date_is_valid
    if self.completed?
      if self.finished_at.nil?
        errors.add(:finished_at, 'Uma lista concluída deve ter uma data de conclusão')
      end
    end
  end
end
