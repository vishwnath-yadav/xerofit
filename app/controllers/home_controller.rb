class HomeController < ApplicationController
  

  

  def test
    @library = Move.new
    @libvideo = LibraryVideo.new
  end
  
end
