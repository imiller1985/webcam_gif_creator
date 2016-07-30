require 'open-uri'
require 'rmagick'

#url for webcam. Note that this only works with webcams with static urls
image_url = "http://www.nps.gov/webcams-olym/current_ridgecam.jpg"
# folder to store images
directory_name = 'images'
gif_name = "hurricane_ridge"

Dir.mkdir(directory_name) unless File.exists?(directory_name)

# runs the timer, the sleep period is the time in seconds between images. In this
# case it is 6 minutes
start_time = Time.now.to_i
hours_of_runtime = 5
run_time = 3600 * hours_of_runtime
finish_time = start_time + run_time
sleep_period = 600

# captures the images and saves them to the directory specified above
def image_downloader(finish_time, directory_name, image_url, sleep_period)
  until Time.now.to_i >= finish_time
    begin
      true if open(image_url)
      open(image_url) do |f|
        File.open("#{directory_name}/#{Time.now.to_i}.jpg","w") do |file|
          file.puts f.read
          puts "saved image at #{Time.now}, script will end at #{Time.at(finish_time)}"
          sleep sleep_period
        end
      end
    rescue
# if a connection can't be established this will sleep the script for 5 seconds before trying again
      false
      puts "Can't connect at #{Time.now}, trying again in 5 seconds"
      sleep 5
    end
  end
end

# converts the jpg to a gif using ImageMagick.
def images_to_gif(directory_name, gif_name)
  puts "converting to gif"
  sequence = Magick::ImageList.new
  Dir.glob("#{directory_name}/*.jpg").each do |image|
      sequence << Magick::Image.read("#{image}").first
# Sets the delay between images. Lower number = less delay between image change
      sequence.cur_image.delay = 10
    end
  end
  sequence.write("#{gif_name}_timelapse.gif")
end
