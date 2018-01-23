class Track < ApplicationRecord
  INSTRUMENTS = [ :voice, :sitar, :tabla, :flute ]

  enum mood: [ :cheerful, :peaceful, :joyful, :integration, :innocence ]

  mount_uploader :file, TrackUploader

  def instruments= list
    list &= INSTRUMENTS.map {|l| l.to_s} # only allow the allowed list of instruments
    super list.join(',')
  end

  def instruments
    list = super
    if list
      list.split(',')
    else
      []
    end
  end

end
