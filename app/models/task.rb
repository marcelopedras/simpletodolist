class Task < ActiveRecord::Base
  attr_accessible :completed, :description, :finished_at, :title, :list_id

  #Relations
  belongs_to :list, :inverse_of => :tasks,  :validate => true


  #Validations
  validates_presence_of :title
  validates_presence_of :list

  after_save :check_if_the_list_is_complete

  private
  def check_if_the_list_is_complete
    list = self.list
    if list(true).all_tasks_completed?
      logger.debug "A lista de id #{list.id} referente a task de id #{self.id} está completa"
      list.completed = true
      list.finished_at = self.finished_at
      list.save!
    else
      logger.debug "A lista de id #{list.id} referente a task de id #{self.id} não está completa"
      list.completed = false
      list.finished_at = nil
      list.save!
    end
  end
end
