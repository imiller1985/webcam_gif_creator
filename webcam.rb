require 'open-uri'
require 'rmagick'

image_url = "http://www.nps.gov/webcams-olym/current_ridgecam.jpg"
# directory_name = 'hurricane_ridge_images'
gif_name = "VLC"
directory_name = "VLSC_cam1_archive"

# Dir.mkdir(directory_name) unless File.exists?(directory_name)

# start_time = Time.now.to_i
# hours_of_runtime = 5
# run_time = 3600 * hours_of_runtime
# finish_time = start_time + run_time
# sleep_period = 600

# def image_downloader(finish_time, directory_name, image_url, sleep_period)
#   until Time.now.to_i >= finish_time
#     begin
#       true if open(image_url)
#       open(image_url) do |f|
#         File.open("#{directory_name}/#{Time.now.to_i}.jpg","w") do |file|
#           file.puts f.read
#           puts "saved image at #{Time.now}, script will end at #{Time.at(finish_time)}"
#           sleep sleep_period
#         end
#       end
#     rescue
#       false
#       puts "Can't connect at #{Time.now}, trying again in 5 seconds"
#       sleep 5
#     end
#   end
# end


def images_to_gif(directory_name, gif_name)
  puts "converting to gif"
  sequence = Magick::ImageList.new
  counter = 1
  Dir.glob("#{directory_name}/*.jpg").each do |image|
    if counter == 1 || counter % 5 == 1
      sequence << Magick::Image.read("#{image}").first
      sequence.cur_image.delay = 10
    end
    counter += 1
  end
  sequence.write("#{gif_name}_timelapse.gif")
end

# deletes_photos(directory_name)
# image_downloader(finish_time, directory_name, image_url, sleep_period)
images_to_gif(directory_name, gif_name)
