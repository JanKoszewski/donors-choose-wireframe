class ProjectsController < ApplicationController
  def new
    @projects = Project.limit(10)
    @project = Project.new
  end

  def create
    url = params[:project][:proposal_url]
    if Project.valid_url(url)
      project = Project.from_donors_choose_url(url)
      if project.new_record?
        project.set_attrs_from_donors_choose(url)
        redirect_to new_project_challenge_path(:project_id => project.id), flash[:notice] = t(:new_project)
      else
        redirect_to project_path(project), flash[:notice] = t(:project_already_exists)
      end
    else
      redirect_to root_path, flash[:error] = t(:unable_to_match_url)
    end
  end

  def show
    @project = Project.find(params[:id])
    @challenges = Challenge.where("project_id = ?",
                                  params[:id]).order("amount ASC").limit(6)
  end

  def index
    @projects = Project.where(:funding_status => "needs funding").order(
      "title").page(params[:page]).per(8)
  end
end
