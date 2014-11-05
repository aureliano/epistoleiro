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

end