require 'open-uri'
require 'rmagick'
require 'pry'

image_url = "http://www.nps.gov/webcams-olym/current_ridgecam.jpg"
directory_name = 'hurricane_ridge_images'
gif_name = "hurricane_ridge"

Dir.mkdir(directory_name) unless File.exists?(directory_name)

start_time = Time.now.to_i
hours_of_runtime = 9
run_time = 3600 * hours_of_runtime
finish_time = start_time + run_time
sleep_period = 600

def image_downloader(finish_time, directory_name, image_url, sleep_period)
  until Time.now.to_i >= finish_time
    begin
      true if open(image_url)
      open(image_url) do |f|
        File.open("#{directory_name}/#{Time.now.to_i}.jpg","w") do |file|
          file.puts f.read
          sleep sleep_period
        end
      end
    rescue
      false
      sleep 30
    end
  end
end


def images_to_gif(directory_name, gif_name)
  sequence = Magick::ImageList.new
  Dir.glob("#{directory_name}/*.jpg").each do |image|
    sequence << Magick::Image.read("#{image}").first
    sequence.cur_image.delay = 12
  end
  sequence.write("#{gif_name}_timelapse.gif")
end

image_downloader(finish_time, directory_name, image_url, sleep_period)
images_to_gif(directory_name, gif_name)
