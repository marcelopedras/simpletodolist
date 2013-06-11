class ListManagerController < ApplicationController

  before_filter :authenticate_user!
  before_filter :check_if_the_list_is_valid, :only => [:new_list]
  before_filter :check_proprietary_of_list, :only=>[:complete_list, :show_list, :delete_list]
  before_filter :check_if_the_list_is_public_and_does_not_belong_to_the_user_himself, :only => [:show_public_list]
  before_filter :check_proprietary_of_task_on_create, :only=> [:new_task]
  before_filter :check_proprietary_of_task, :only=>[:delete_task, :show_task, :complete_task]
  before_filter :check_if_the_list_belongs_to_my_favorites, :only => [:show_favorite, :delete_favorite]
  before_filter :check_if_the_list_is_public_and_does_not_belong_to_me_to_my_favorites, :only => [:add_favorite]
  before_filter :show_error

  def index
    @editable = true
    @lists = List.where(:user_id => current_user.id)
    @favorites = current_user.my_favorites
  end

  def complete_list
    @editable = true
    unless @invalid_list
      now = Time.now
      undo = params[:undo]
      if undo
        @list.completed = false
        @list.save!
        @list.undo_all_tasks
      else
        @list.completed = true
        @list.finished_at = now
        @list.save!
        #TODO Testar se realmente ao completar uma lista automaticamente suas respectives tarefas também são atualizadas
        #@list.complete_the_tasks_that_have_not_yet_been_completed
      end
      render :show_list
    end

  end

  def new_list
    @editable = true
    @list.save!
  end

  def delete_list
    @editable = true
    unless @invalid_list
      @list.destroy
      @lists = current_user.lists
    end
  end

  def show_list
    @editable = true
  end

  def show_public_list
    list_id = params[:list_id]
    @list = List.find(list_id)
    @editable = false
  end





  def complete_task
      @editable = true
      now = Time.now
      undo = params[:undo]
      @task = Task.find(params[:task_id])
      @list = @task.list
      if undo
        @task.completed = false
        @task.finished_at = nil
        @task.save!
      else
        @task.completed = true
        @task.finished_at = now
        @task.save!
      end
      render :show_list
  end

  def new_task
    @editable = true
      @task = Task.new(params[:task])
      logger.info "Task válida: #{@task.valid?}"
      @task.save!
      @list = @task.list
      if @list.completed?
        @list.completed = false
        @list.save!
        @list_updated = true
      end
      logger.debug "Adicionada Task referente a lista: #{@task.list_id}"
      render :show_list
  end

  def delete_task
      @editable = true
      @task = Task.find(params[:task_id])
      @list = @task.list
      @task.destroy
      render :show_list
  end

  def show_task
    @editable = true
  end

  def show_favorite
    @editable = false
    @undo_favorite = true
    render :show_list
  end

  def find_favorite
   @query = params[:search]
   logger.info "Procurar lista pública que contenha no título ou descrição a expressão: '#{@query}'"
   @results = List.load_public_lists_by_condition_except(current_user, @query)
   logger.debug "#{@results.size} listas encontradas"
  end

  def add_favorite
    list_id = params[:list_id]
    @list = List.find list_id

    @favorite = Favorite.new
    @favorite.user = current_user
    @favorite.list = @list
    @favorite.save!
    logger.info("Usuario de id #{current_user.id} criou um novo favorito referente a lista de id #{@list.id}")
    @favorites = current_user.my_favorites
  end

  def delete_favorite
    list_id = params[:list_id]
    @list = List.find list_id
    @favorite = Favorite.find_by_user_id_and_list_id(current_user.id, @list.id)
    @favorite.destroy
    logger.info("Usuario de id #{current_user.id} destruiu seu favorito referente a lista de id #{@list.id}")
    @favorites = current_user.my_favorites
  end


  private

  def check_proprietary_of_list(options={})
    list_id = params[:list_id]
    if(options[:list_id])
      list_id = options[:list_id]
    end

    if load_list(list_id)
      if @list.user != current_user
        @invalid_list = true
        logger.info "Tentativa de acesso indevido. User de id #{current_user.id} tentou acessar a lista de id #{list_id}"
        @list = nil
        return
      else
        logger.info "Lista de id #{@list.id} válida encontrada para usuário de id #{@list.user_id}"
      end
    end
  end


  def check_proprietary_of_task_on_create
    task = Task.new params[:task]
    if task.valid?
      check_proprietary_of_list({:list_id=>task.list.id})
    else
      @invalid_task = true
    end
  end

  def check_proprietary_of_task
    task_id = params[:task_id]
    begin
      @task = Task.find(task_id)
    rescue
      logger.info "Task não encontrada para id #{task_id}"
      @task = nil
      @invalid_task = true
      return
    end

    check_proprietary_of_list({:list_id => @task.list.id})
  end

  def check_if_the_list_is_valid
    @list = List.new params[:list]
    @list.user = current_user
    unless @list.valid?
      logger.info "O usuario id #{current_user.id} tentou criar uma lista inválida"
      @list = nil
      @invalid_list = true
    end
  end

  def check_if_the_list_is_public_and_does_not_belong_to_the_user_himself
    if load_list(params[:list_id])
      if !@list.public
        @invalid_list = true
        logger.info "Tentativa de acesso indevido. User de id #{current_user.id} tentou acessar a lista particular de id #{@list.id}"
        @list = nil
        return
      else
        if @list.user == current_user
          @invalid_list = true
          logger.info "Tentativa de acesso indevido. User de id #{current_user.id} tentou acessar sua própria lista de id #{@list.id} em modo somente leitura. Isso não é permitido"
        end
      end
    end
  end

  def check_if_the_list_belongs_to_my_favorites
    if load_list(params[:list_id])
      if !current_user.this_is_my_favorite_list? @list
        @invalid_list = true
        logger.info "Tentativa de acesso indevido. User de id #{current_user.id} tentou acessar uma lista de id #{@list.id} como favorita, mas esta lista não pertence aos seus favoritos"
        @list = nil
        return
      end
     end
  end

  def check_if_the_list_is_public_and_does_not_belong_to_me_to_my_favorites
    if load_list(params[:list_id])
      if current_user.this_is_my_favorite_list? @list
        @invalid_list = true
        logger.info "User de id #{current_user.id} tentou adicionar a lista de id #{@list.id} aos favoritos, mas ela já pertence aos seus favoritos"
        @list = nil
      elsif !@list.public
        @invalid_list = true
        logger.info "Tentativa de acesso indevido. User de id #{current_user.id} tentou adicionar a lista particular de id #{@list.id} aos seus favoritos"
        @list = nil
      end
    end
  end
  
  def show_error
    if @invalid_list || @invalid_task
      render 'erro'
    end
  end

  def load_list(list_id)
    begin
      @list = List.find(list_id)
    rescue
      logger.info "Lista não encontrada para id #{list_id}"
      @list = nil
      @invalid_list = true
      return false
    end
    true
  end

 end
