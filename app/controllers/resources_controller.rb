class ResourcesController < ApplicationController
  def index
  	@resources = Resource.order('upvotes - downvotes desc').all

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  	@resource = Resource.find(params[:id])
    @comments = @resource.comments.select{|c| !c.spam?}
  end

  def new
  	@resource = Resource.new
  end

  def create
    @resource = Resource.new(params[:resource])
    if @resource.save
      flash[:notice] = "Resource created"
      redirect_to resources_path
    else
      flash[:alert] = "Resource not created" + @resource.errors.full_messages.to_yaml
      redirect_to :action => "new"
    end
  end

  def edit
  	@resource = Resource.find(params[:id])
  end

  def update
  	@resource = Resource.find(params[:id])
  	if @resource.update_attributes(params[:resource])
  	  flash[:notice] = "Resource updated!"
  	  redirect_to resources_path
  	else
  	  flash[:alert] = "Resource not updated" + @resource.errors.full_messages.to_yaml
  	  redirect_to :action => "edit"
  	end
  end

  def destroy
  	@resource = Resource.find(params[:id])
  	@resource.destroy
  	flash[:notice] = "Resource deleted" if @resource.destroy
  	redirect_to resources_path
  end

  def upvote
    @resource = Resource.find(params[:id])
    @resource.upvote
    @resource.save
    redirect_to resources_path(:format => :js)
  end

  def downvote
    @resource = Resource.find(params[:id])
    @resource.downvote
    @resource.save
    redirect_to resources_path(:format => :js)
  end
end
