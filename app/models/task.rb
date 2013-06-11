class Task < ActiveRecord::Base
  attr_accessible :completed, :description, :finished_at, :title, :list_id

  #Relations
  belongs_to :list, :inverse_of => :tasks,  :validate => true


  #Validations
  validates_presence_of :title
  validates_presence_of :list
  validate :check_if_the_date_is_valid

  after_save :check_if_the_list_is_complete
  after_destroy :check_if_the_list_is_complete

  private
  def check_if_the_list_is_complete
    list = self.list
    if list(true).all_tasks_completed?
      logger.debug "A lista de id #{list.id} referente a task de id #{self.id} está completa"
      list.completed = true
      list.finished_at = Time.now
      list.save!
    else
      logger.debug "A lista de id #{list.id} referente a task de id #{self.id} não está completa"
      list.completed = false
      list.finished_at = nil
      list.save!
    end
  end

  def check_if_the_date_is_valid
    if self.completed?
      if self.finished_at.nil?
        errors.add(:finished_at, 'Uma tarefa concluída deve ter uma data de conclusão')
      end
    end
  end
end
