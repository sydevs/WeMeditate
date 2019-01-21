
file_root = Rails.root.join('db/seeds/files')
puts ' -- Start City Seeds -- '

def attachment path, name, type, parent
  media_file = parent.media_files.find_or_initialize_by(name: name)
  media_file.update!({ name: name, category: type, file: Rails.root.join('db/seeds/files').join(path).open })
  media_file.id
end

# ===== CREATE CITIES ===== #
[{
  name: 'Los Angeles',
  country: 'US',
  latitude: 34.0522,
  longitude: -118.2437,
}, {
  name: 'Atlanta',
  country: 'US',
  latitude: 33.7490,
  longitude: -84.3880,
}, {
  name: 'New York',
  country: 'US',
  latitude: 40.7128,
  longitude: -74.0060,
}, {
  name: 'Detroit',
  country: 'US',
  latitude: 42.3314,
  longitude: -83.0458,
}, {
  name: 'Anchorage',
  country: 'US',
  latitude: 61.2181,
  longitude: -149.9003,
}, {
  name: 'Berlin',
  country: 'DE',
  latitude: 52.5200,
  longitude: 13.404954,
}].each do |atts|
  city = City.find_or_initialize_by(name: atts[:name], country: atts[:country])
  atts[:banner_id] = attachment('cities/background.jpg', 'Banner.jpg', :image, city)
  city.update!(atts)

  [{
    content_type: :text,
    format: :box_with_righthand_image,
    title: 'What to expect at a class?',
    text: '<p>Iste exercitationem quaerat, praesentium quod corrupti beatae eligendi quasi nostrum natus ut, ea accusantium repellat ex placeat expedita dolores ad quas optio.</p><p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Iste exercitationem quaerat, praesentium quod corrupti beatae eligendi quasi nostrum natus ut, ea accusantium repellat ex placeat expedita dolores ad quas optio.</p><p>Ea accusantium repellat ex placeat expedita dolores ad quas optio.</p>',
    extra: {
      image_uuid: attachment('cities/classes.jpg', 'Classes.jpg', :image, city),
      decorations: {
        enabled: ['sidetext, triangle'],
        options: {
          sidetext: ['top-left'],
        },
        sidetext: 'Classes',
      },
    },
  }].each_with_index do |atts, index|
    section = city.sections.find_or_initialize_by(order: index)
    atts[:order] = index
    section.update!(atts)
  end
end

city = City.find_by(name: 'Los Angeles')
city.update!({
  contacts: [{
    name: 'Sarah',
    url: 'https://www.facebook.com/',
    image_id: attachment("cities/instructors/1.jpg", 'Contact 1.jpg', :image, city),
  }, {
    name: 'Alan',
    url: 'https://www.facebook.com/',
    image_id: attachment("cities/instructors/2.jpg", 'Contact 2.jpg', :image, city),
  }, {
    name: 'Jason',
    url: 'https://www.facebook.com/',
    image_id: attachment("cities/instructors/3.jpg", 'Contact 3.jpg', :image, city),
  }, {
    name: 'Alex',
    url: 'https://www.facebook.com/',
    image_id: attachment("cities/instructors/4.jpg", 'Contact 4.jpg', :image, city),
  }, {
    name: 'Julie',
    url: 'https://www.facebook.com/',
    image_id: attachment("cities/instructors/5.jpg", 'Contact 5.jpg', :image, city),
  }]
})

puts ' -- Finished Subtle System Seeds -- '
