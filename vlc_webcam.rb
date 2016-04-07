require 'open-uri'
require 'rmagick'

gif_name = "VLC"
directory_name = "VLSC_cam1_archive"


def images_to_gif(directory_name, gif_name)
  puts "converting to gif"
  sequence = Magick::ImageList.new
  counter = 1
  Dir.glob("#{directory_name}/*.jpg").each do |image|
    # If you don't want every image run the if statement below. Currently set up
    # to run the first image and every 5th image after that (1, 6, 11, ..)
    # If you want to run every 3rd image you would change counter % 5 to counter % 3
    if counter == 1 || counter % 5 == 1
      sequence << Magick::Image.read("#{image}").first
      # Sets the delay between images. Lower number = less delay between image change
      sequence.cur_image.delay = 10
    end
    counter += 1
  end
  sequence.write("#{gif_name}_timelapse.gif")
end

images_to_gif(directory_name, gif_name)
