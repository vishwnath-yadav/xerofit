class HomeController < ApplicationController
  

  

  def test
    @library = Library.new
    @libvideo = LibraryVideo.new
  end
  
end
