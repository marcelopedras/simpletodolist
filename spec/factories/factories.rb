FactoryGirl.define do
  factory :user do
    email 'marceloteste@gmail.com'
    password '12345678'
    password_confirmation '12345678'
  end

  factory :list do
    title 'Lista de teste'
    description 'Descrição da lista de teste'
    public false
    completed false
    user
  end

  factory :task do
    title 'Tarefa 1'
    description 'Descricao da tarefa 1'
    completed false
    list
  end

end
