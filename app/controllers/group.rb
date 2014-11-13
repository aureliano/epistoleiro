Epistoleiro::App.controllers :group do
  
  before do
    validate_user_access
  end

  get :list_groups, :map => '/groups' do
    @current_page = 1
    @groups = Group.all.asc(:name).skip(0).limit(DataTable.default_page_size)

    render 'group/list_groups'
  end

  post :list_groups, :map => '/groups' do
    @current_page = params['dt_groups-index'].to_i
    @current_page += 1 if @current_page == 0
    skip = (@current_page - 1) * DataTable.default_page_size
    
    @groups = unless params[:query].to_s.empty?
      Group.where(:tags => { '$all' => query_to_tags(params[:query]) })
    else
      Group.all
    end.asc(:name).skip(skip).limit(DataTable.default_page_size)

    render 'group/list_groups'
  end

  get :create do
    unless signed_user_has_permission? Rules::GROUP_CREATE_GROUP
      put_message :message => 'view.create_group.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    params['group'] = {}
    render 'group/create'
  end

  get :create, :with => :id do
    @base_group = Group.where(:id => params[:id]).first
    return render('errors/404', :layout => false) if @base_group.nil?

    unless signed_user_has_permission? Rules::GROUP_CREATE_GROUP
      put_message :message => 'view.create_group.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    params['group'] = { 'base_group' => @base_group.name }
    render 'group/create'
  end

  post :create do
    unless signed_user_has_permission? Rules::GROUP_CREATE_GROUP
      put_message :message => 'view.create_group.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    group = build_group_creation_model(params[:group])
    if group.base_group && group.owner != group.base_group.owner
      put_message :message => I18n.translate('model.group.validation.group_and_subgroup_with_different_owners'), :type => 'w'
      return render 'group/create'
    end

    group.save
    @messages = format_validation_messages group

    if @messages.empty?
      session[:msg] = I18n.translate('view.create_group.message.success')
      session[:msg_type] = 's'

      redirect url :group, :dashboard, :id => group.id
    else
      put_message :message => @messages.join('<br/>'), :type => 'w', :translate => false
      render 'group/create'
    end
  end

  get :dashboard, :map => '/group/:id' do
    @group = Group.where(:id => params[:id]).first
    return render('errors/404', :layout => false) if @group.nil?

    @members_current_page = params['dt_members-index'].to_i
    @members_current_page += 1 if @members_current_page == 0
    skip = (@members_current_page - 1) * DataTable.default_page_size

    @members = @group.members.asc(:nickname).skip(skip).limit(DataTable.default_page_size)

    @sub_groups_current_page = params['dt_sub_groups-index'].to_i
    @sub_groups_current_page += 1 if @sub_groups_current_page == 0
    skip = (@sub_groups_current_page - 1) * DataTable.default_page_size

    @sub_groups = Group.where(:base_group => @group).asc(:name).skip(skip).limit(DataTable.default_page_size)

    render 'group/dashboard'
  end

  delete :delete, :with => :id do
    @group = Group.where(:id => params[:id]).first
    return render('errors/404', :layout => false) if @group.nil?

    unless can_delete_group? @group, nil
      put_message :message => 'view.group_dashboard.message.delete_group.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    @sub_groups = Group.where(:base_group => @group)
    @group.delete
    @sub_groups.each {|sub_group| sub_group.delete }

    session[:msg] = I18n.translate('view.group_dashboard.message.delete_group.success')
    session[:msg_type] = 's'

    redirect url :group, :list_groups
  end

  get :edit, :with => :id do
    @group = Group.where(:id => params[:id]).first
    return render('errors/404', :layout => false) if @group.nil?
    user = signed_user

    unless can_edit_group? @group, user
      put_message :message => 'view.edit_group.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    @edit_mode = true
    @base_group = @group.base_group
    @base_group ||= Group.new
    params['group'] = { 'base_group' => @base_group.name, 'id' => @group.id, 'name' => @group.name, 'description' => @group.description }

    render 'group/edit'
  end

  post :edit, :with => :id do
    @group = Group.where(:id => params[:id]).first
    return render('errors/404', :layout => false) if @group.nil?
    user = signed_user

    unless can_edit_group? @group, user
      put_message :message => 'view.edit_group.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    @group.name = params[:group][:name]
    @group.description = params[:group][:description]

    @base_group = Group.where(:id => params[:group][:base_group]).first
    @group.base_group = @base_group

    if @group.base_group && @group.owner != @group.base_group.owner
      put_message :message => I18n.translate('model.group.validation.group_and_subgroup_with_different_owners'), :type => 'w'
      @edit_mode = true
      params['group'] = { 'base_group' => @base_group.name, 'id' => @group.id, 'name' => @group.name, 'description' => @group.description }

      return render 'group/edit'
    end

    @group.save
    @messages = format_validation_messages @group

    if @messages.empty?
      session[:msg] = I18n.translate('view.edit_group.message.success')
      session[:msg_type] = 's'

      redirect url :group, :dashboard, :id => @group.id
    else
      put_message :message => @messages.join('<br/>'), :type => 'w', :translate => false
      render 'group/create'
    end
  end

  get :change_group_owner, :map => '/group/change-owner/:id' do
    @group = Group.where(:id => params[:id]).first
    return render('errors/404', :layout => false) if @group.nil?
    @signed_user = signed_user

    unless can_change_group_owner? @group, @signed_user
      put_message :message => 'view.change_group_owner.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    render 'group/change_owner'
  end

  post :change_group_owner, :map => '/group/change-owner/:id' do
    @group = Group.where(:id => params[:id]).first
    return render('errors/404', :layout => false) if @group.nil?
    @signed_user = signed_user

    unless can_change_group_owner? @group, @signed_user
      put_message :message => 'view.change_group_owner.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    
    @sub_groups = Group.where(:base_group => @group)

    new_owner = User.where(:nickname => params[:group_owner]).first
    @group.owner = new_owner
    @group.members << new_owner if (!new_owner.nil?) && !@group.members.include?(new_owner)
    @group.save

    @messages = format_validation_messages @group

    if @messages.empty?
      session[:msg] = I18n.translate('view.change_group_owner.message.success')
      session[:msg_type] = 's'

      @sub_groups.each do |sub_group|
        sub_group.owner = new_owner
        sub_group.members << new_owner if (!new_owner.nil?) && !sub_group.members.include?(new_owner)
        sub_group.save
      end

      redirect url :group, :dashboard, :id => @group.id
    else
      put_message :message => @messages.join('<br/>'), :type => 'w', :translate => false
      render 'group/change_owner'
    end
  end

  post :subscribe, :with => [:group_id, :user_id] do
    @group = Group.where(:id => params[:group_id]).first
    @user = User.where(:id => params[:user_id]).first
    return render('errors/404', :layout => false) if @group.nil? || @user.nil?

    unless can_subscribe_to_group? @group, @user
      put_message :message => 'view.group_dashboard.message.subscribe.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    @group.members ||= []
    @group.members << @user

    @user.subscribed_groups ||= []
    @user.subscribed_groups << @group

    @group.save
    @user.save

    session[:msg] = I18n.translate('view.group_dashboard.message.subscribe.success')
    session[:msg_type] = 's'
    redirect url :group, :dashboard, :id => @group.id
  end

  post :unsubscribe, :with => [:group_id, :user_id] do
    _unsubscribe

    session[:msg] = I18n.translate('view.group_dashboard.message.unsubscribe.success')
    session[:msg_type] = 's'

    redirect url :group, :dashboard, :id => @group.id
  end

  post :unsubscribe do
    _unsubscribe
    redirect url :index
  end
end