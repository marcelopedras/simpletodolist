class Favorite < ActiveRecord::Base

  #Relations
  belongs_to :user, :validate => true
  belongs_to :list,:validate => true

  #Validations
  validates_presence_of :user
  validates_presence_of :list
  validate :check_if_the_list_is_public
  validate :check_the_list_belongs_to_yourself
  validate :check_if_there_is_already_favorite


  private

  def check_if_the_list_is_public
    if(self.list)
      if !self.list(true).public?
        errors.add(:list_id, 'Uma lista privada não pode ser um favorito')
      end
    else
      errors.add(:list_id, 'list_id deve ser válido')
    end
  end


  def check_the_list_belongs_to_yourself
    if(self.list)
      if(self.list.user == self.user)
        errors.add(:list_id, 'Um usuário não pode ter como favorito sua própria lista')
      end
    end
  end

  def check_if_there_is_already_favorite
    if Favorite.find_by_list_id_and_user_id(self.list_id,self.user_id)
      errors.add(:list_id, 'Esta lista já pertence a um favorito deste usuário')
    end

  end

end
