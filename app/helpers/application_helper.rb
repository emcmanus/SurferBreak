# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  
  class NoThumbnailOptionForSelect
    def id
      -1
    end
    def s3_path( platform="snes" )
      "/images/thumbnails/#{platform}_generic.png"
    end
  end
  
  def no_thumbnail_option
    NoThumbnailOptionForSelect.new
  end
end
