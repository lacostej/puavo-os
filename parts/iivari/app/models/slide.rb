class Slide < OrganisationData
  belongs_to :channel
  has_many :slide_timers
  
  acts_as_list

  after_update :set_channel_updated_at
  after_create :set_channel_updated_at

  attr_accessor :slide_html

  def image_url(resolution)
    unless self.image.nil?
      "image/#{self.template}/#{self.image}?resolution=#{resolution}"
    end
  end

  def self.image_urls(channel, resolution)
    channel.slides.inject([]) do |result, s|
      s.image.nil? ? result : ( result.push s.image_url(resolution) )
    end
  end

  def updated_at
    self.channel.updated_at
  end

  def timers
    return self.slide_timers.map do |timer|
      { "start_datetime" => (timer.start_datetime.getutc rescue ""),
        "end_datetime" => (timer.end_datetime.getutc rescue ""),
        "start_time" => (timer.start_time.getutc rescue ""),
        "end_time" => (timer.end_time.getutc rescue ""),
        "weekday_0" => timer.weekday_0,
        "weekday_1" => timer.weekday_1,
        "weekday_2" => timer.weekday_2,
        "weekday_3" => timer.weekday_3,
        "weekday_4" => timer.weekday_4,
        "weekday_5" => timer.weekday_5,
        "weekday_6" => timer.weekday_6 }
    end
  end

  protected

  def set_channel_updated_at
    self.channel.updated_at = Time.now
    self.channel.save
  end
end
