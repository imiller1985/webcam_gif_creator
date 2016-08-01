# Webcam Gif Creator
A Ruby script to capture images from National Park webcams, can be converted to run on other webcams with static url's.

[Sample output](http://i.imgur.com/qLB4W05.gifv)
![alt tag](http://i.imgur.com/qLB4W05.gifv "Description goes here")

## Implemntation 
1. To run the gif creator make sure you have Ruby installed and clone the repo to your desired directory using the command: `$ git clone https://github.com/imiller1985/webcam_gif_creator`
2. Navigate to the new directory using: `$ cd webcam_gif_creator`
3. Two gems are required: open-uri and rmagick. Rmagick is an interface between Ruby and the ImageMagick processing library and will require installing ImageMagick on your machine. More information on the gem can be found on the rmagick [Github Page](https://github.com/rmagick/rmagick) while download instructions can be found at the [Image Magick Homepage](http://www.imagemagick.org/script/index.php)
4. Once installed the script can be run via the command `$ ruby webcam.rb`
5. The script is currently setup to run on Hurrican Ridge Webcam in Olympic National Park. However that can be changed by changing the variable `image_url = "http://www.nps.gov/webcams-olym/current_ridgecam.jpg"` to another static url that displays a jpg image. In some cases a webcams url will contain a timestamp but on occassion removing the timestamp from the url will still return the current image and the script will still run. Additionally the name of the produced gif is set using the variable `gif_name`.
6. The script runs in two parts. The initial step includes downloading all images over a set period of time, this can be done using the variables `hours_of_runtime` and `sleep_period`. Sleep period is in seconds, and is currently set at 10 minutes. 
```ruby
start_time = Time.now.to_i
hours_of_runtime = 5
run_time = 3600 * hours_of_runtime
finish_time = start_time + run_time
sleep_period = 600
```
Once the variables are set the method `image_downloader` will download all images into a new folder labeled `images` which can be changed using the variable `directory_name`. A few pieces of the method are worth noting, primarily that the images will be saved with a timestamp of the current time and in the `.jpg` format. Additionally a failsafe has been built in so that if a connection can't be established the script will sleep for 5 seconds before trying again, which prevents the script from failing due to an internet connection failure. 
```ruby
def image_downloader(finish_time, directory_name, image_url, sleep_period)
  until Time.now.to_i >= finish_time
    begin
      true if open(image_url)
      ...
    rescue
# if a connection can't be established this will sleep the script for 5 seconds before trying again
      false
      puts "Can't connect at #{Time.now}, trying again in 5 seconds"
      sleep 5
    end
  end
end
``` 
Once all images have been downloaded the script will convert the images to an animated gif and save it in the home directory using the method below:
```ruby
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
``` 
Of primary concern is the line `sequence.cur_image.delay = 10`. This sets the delay between images chaning in the gif, the lower the number the less the delay. Once the gif has been created the original set of images is retained. This was done so that after a batch of images have been created the delay can be changed to a desired length and a new gif created. To do this simple comment out the method `image_downloader`and rerun the script. Because of this manually deleting the files from the images folder is required before running another batch.
Enjoy!
