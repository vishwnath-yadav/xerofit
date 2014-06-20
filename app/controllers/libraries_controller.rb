class LibrariesController < ApplicationController
	before_filter :authenticate_user!
	def index
		@libraries = Library.where(user_id: current_user.id).paginate(:page => params[:page], :per_page => 7).order('created_at DESC')
	end
	
	def new
		@library = Library.new
		@libvideo = LibraryVideo.new
		@library.build_association
	end
	
	def edit
		@library = Library.find(params[:id])
	end
	
	def create
	  @library = Library.new(library_params)
	  @library.user_id = current_user.id
	  if @library.save
	  	video = LibraryVideo.find(params[:video])
	  	video.library = @library
	  	video.save!
	    redirect_to libraries_path, :notice => "Thank you for uploading video!"
	  else
	  	@libvideo = LibraryVideo.new
	    render :new
	  end
	end

	def show
		@library = Library.find(params[:id])
	end

	def update
		@library = Library.find(params[:id])
		respond_to do |format|
	      if @library.update_attributes(library_params)
	        format.html { redirect_to libraries_path, notice: 'successfully updated prescription.' }
	        format.json { head :no_content }
	      else
	        format.html { render action: "edit" }
	        format.json { render json: @library.errors, status: :unprocessable_entity }
	      end
    	end
	end

	def sort_video
		if params[:val] == 'Name'
		  @libraries = Library.where(user_id: current_user.id).paginate(:page => params[:page], :per_page => 7).order('title ASC')
		elsif params[:val] == 'Date'
		  @libraries = Library.where(user_id: current_user.id).paginate(:page => params[:page], :per_page => 7).order('created_at DESC')
		end
		respond_to do |format|
	        format.js
        end
	end

	private
	  def library_params
	    params.require(:library).permit!
	  end
end
