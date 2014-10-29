class HomeController < ApplicationController

  def test
  	respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "file_name"
      end
    end
  end
  
end
