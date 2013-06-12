class Groups::PublicGroupsController < BaseController
  before_filter :authenticate_user!, except: [:index, :find]

  def index
    if params[:query]
      @groups = Group.where("name ILIKE ?", "%#{params[:query]}%").page params[:page]
    else
      @groups = Group.visible_to_the_public.page params[:page]
    end
  end
end
