Epistoleiro::App.controllers :group do
  
  before do
    validate_user_access
  end

  get :list_groups, :map => '/groups' do
    @current_page = 1
    @groups = if params[:query]
      Group.where(:tags => { '$all' => params[:query].split(/\s+/)})
    else
      Group.all
    end.asc(:name).skip(0).limit(DataTable.default_page_size)

    render 'group/list_groups'
  end

  post :list_groups, :map => '/groups' do
    @current_page = params['dt_groups-index'].to_i
    @current_page += 1 if @current_page == 0
    skip = (@current_page - 1) * DataTable.default_page_size
    
    @groups = unless params[:query].to_s.empty?
      Group.where(:tags => { '$all' => params[:query].split(/\s+/)})
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

  post :create do
    unless signed_user_has_permission? Rules::GROUP_CREATE_GROUP
      put_message :message => 'view.create_group.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end     

    group = build_group_creation_model(params[:group])
    group.save
    @messages = format_validation_messages group

    if @messages.empty?
      raise 'Sending e-mail is not implemented yet' if RACK_ENV == 'production'
      session[:msg] = I18n.translate('view.create_group.message.success')
      session[:msg_type] = 's'

      redirect url :group, :list_groups
    else
      put_message :message => @messages.join('<br/>'), :type => 'w', :translate => false
      render 'group/create'
    end
  end

  get :detail, :map => '/group/:id' do
    @group = Group.where(:id => params[:id]).first
    return render('errors/404', :layout => false) if @group.nil?

    @members_current_page = params['dt_members-index'].to_i
    @members_current_page += 1 if @members_current_page == 0
    skip = (@members_current_page - 1) * DataTable.default_page_size

    @members = @group.members.asc(:nickname).skip(skip).limit(DataTable.default_page_size)

    @sub_groups_current_page = params['dt_sub_groups-index'].to_i
    @sub_groups_current_page += 1 if @sub_groups_current_page == 0
    skip = (@sub_groups_current_page - 1) * DataTable.default_page_size

    @sub_groups = @group.sub_groups.asc(:name).skip(skip).limit(DataTable.default_page_size)

    render 'group/dashboard'
  end

end