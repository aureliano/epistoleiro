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

    unless signed_user_can_delete_group? @group
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

end