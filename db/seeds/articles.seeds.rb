
file_root = Rails.root.join('db/seeds/files')
puts ' -- Start Article Seeds -- '

def attachment path, name, type, parent
  media_file = parent.media_files.find_or_initialize_by(name: name)
  media_file.update!({ name: name, category: type, file: Rails.root.join('db/seeds/files').join(path).open })
  media_file.id
end

def sentences count
  [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'Aliquam gravida neque quam, eget eleifend dolor ultricies eget.',
    'Morbi sed imperdiet dolor. Nulla facilisi. Nulla sed erat cursus, bibendum tortor non, suscipit ante.',
    'Praesent venenatis libero ante, in vestibulum eros aliquam eu. Vivamus non efficitur turpis.',
    'Integer vitae nunc id ligula luctus mollis ut sit amet velit. Praesent congue sed mauris vitae aliquam.',
    'Phasellus tempor sem ut libero consectetur feugiat.',
    'Nulla ultrices ut felis id consequat. Nam semper vel augue sit amet semper.',
    'Donec ut feugiat purus. Duis facilisis, tellus vel pretium auctor, mauris odio ultricies ligula, eu scelerisque lorem lectus in erat.',
    'Duis quam orci, tristique ut iaculis ac, lacinia sit amet sem. Integer vitae lacinia enim, ut egestas eros.',
    'Proin feugiat id tortor a pulvinar. Nunc at augue iaculis, facilisis ex eget, vulputate dui.',
    'In congue elit eu accumsan egestas. Morbi vitae malesuada nisi.',
    'Duis elit dolor, varius feugiat tempus eu, dignissim ut lectus.',
    'Praesent sit amet est et nisl mattis facilisis.',
    'Cras sed mauris sed arcu fermentum interdum vel imperdiet enim.',
    'Nulla bibendum sed tortor vel rhoncus. Donec ac tellus accumsan nibh rutrum faucibus non non odio.',
    'Nullam at leo et lectus tristique ullamcorper. Morbi rhoncus dolor nec ornare dapibus.',
    'In lectus est, facilisis in sagittis eget, rutrum quis neque. Nam vitae ullamcorper lectus, et auctor justo.',
    'Mauris fringilla orci est, non facilisis urna euismod at.',
    'Cras lobortis tellus purus, id cursus purus rhoncus at.',
    'Donec scelerisque consectetur lacus, vitae ultricies lectus cursus quis.',
    'Ut quam est, dictum eu dapibus vitae, rhoncus eu nisi.',
    'Vivamus enim erat, sagittis a bibendum nec, varius non nulla.',
    'Sed suscipit quam vel ex suscipit, sollicitudin rutrum massa cursus.',
    'Phasellus malesuada mattis risus sit amet eleifend.',
  ].shuffle.sample(count).join(' ')
end

def paragraphs count
  [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam gravida neque quam, eget eleifend dolor ultricies eget. Morbi sed imperdiet dolor. Nulla facilisi. Nulla sed erat cursus, bibendum tortor non, suscipit ante. Praesent venenatis libero ante, in vestibulum eros aliquam eu. Vivamus non efficitur turpis. Integer vitae nunc id ligula luctus mollis ut sit amet velit. Praesent congue sed mauris vitae aliquam.',
    'Phasellus tempor sem ut libero consectetur feugiat. Nulla ultrices ut felis id consequat. Nam semper vel augue sit amet semper. Donec ut feugiat purus. Duis facilisis, tellus vel pretium auctor, mauris odio ultricies ligula, eu scelerisque lorem lectus in erat. Duis quam orci, tristique ut iaculis ac, lacinia sit amet sem. Integer vitae lacinia enim, ut egestas eros. Proin feugiat id tortor a pulvinar. Nunc at augue iaculis, facilisis ex eget, vulputate dui.',
    'In congue elit eu accumsan egestas. Morbi vitae malesuada nisi. Duis elit dolor, varius feugiat tempus eu, dignissim ut lectus. Praesent sit amet est et nisl mattis facilisis. Cras sed mauris sed arcu fermentum interdum vel imperdiet enim. Nulla bibendum sed tortor vel rhoncus. Donec ac tellus accumsan nibh rutrum faucibus non non odio.',
    'Nullam at leo et lectus tristique ullamcorper. Morbi rhoncus dolor nec ornare dapibus. In lectus est, facilisis in sagittis eget, rutrum quis neque. Nam vitae ullamcorper lectus, et auctor justo. Mauris fringilla orci est, non facilisis urna euismod at. Cras lobortis tellus purus, id cursus purus rhoncus at. Donec scelerisque consectetur lacus, vitae ultricies lectus cursus quis. Ut quam est, dictum eu dapibus vitae, rhoncus eu nisi. Vivamus enim erat, sagittis a bibendum nec, varius non nulla. Sed suscipit quam vel ex suscipit, sollicitudin rutrum massa cursus. Phasellus malesuada mattis risus sit amet eleifend.',
  ].shuffle.sample(count).map{|p| "<p>#{p}</p>"}.join
end

# ===== CREATE CATEGORIES ===== #
categories = {}

['Wisdom', 'Experiences', 'Creativity', 'Events'].each_with_index do |name, index|
  categories[name] = Category.find_or_initialize_by(order: index)
  categories[name].update!({ name: name, order: index })
  puts "Created Category - #{name}"
end

# ===== CREATE GENERIC ARTICLE ===== #
14.times.each do |index|
  index += 1
  article = Article.find_or_initialize_by(name: "Article #{index}")
  article.update!({
    name: "Article #{index}",
    excerpt: 'In congue elit eu accumsan egestas. Morbi vitae malesuada nisi. Duis elit dolor, varius feugiat tempus eu, dignissim ut lectus. Praesent sit amet est et nisl mattis facilisis. Cras sed mauris sed arcu fermentum interdum vel imperdiet enim. Nulla bibendum sed tortor vel rhoncus. Donec ac tellus accumsan nibh rutrum faucibus non non odio.',
    thumbnail_id: attachment("articles/thumbnails/#{index}.png", 'Thumbnail.png', :image, article),
    category: categories.values.sample,
    date: '',
    video_id: '',
  })

  puts "Created Generic Article #{index}"
end

# ===== ADD RANDOM SPECIAL ARTICLES ===== #
Article.all.sample(5).each do |article|
  article.update!(date: (1..500).to_a.sample.days.from_now)
  puts "Added Date #{article.date} to #{article.name}"
end

Article.all.sample(5).each do |article|
  article.update!(video_id: attachment('general/video.mp4', 'Featured Video.mp4', :video, article))
  puts "Added Video to #{article.name}"
end

Article.all.sample(3).each do |article|
  article.update!(priority: :low)
  puts "Set Low Priority for #{article.name}"
end

Article.all.sample(3).each do |article|
  article.update!(priority: :high)
  puts "Set High Priority for #{article.name}"
end

# ===== TEST ARTICLE ===== #
article = Article.find_or_initialize_by(name: 'Test Article')
article.update!({
  name: 'Test Article',
  excerpt: 'In congue elit eu accumsan egestas. Morbi vitae malesuada nisi. Duis elit dolor, varius feugiat tempus eu, dignissim ut lectus. Praesent sit amet est et nisl mattis facilisis. Cras sed mauris sed arcu fermentum interdum vel imperdiet enim. Nulla bibendum sed tortor vel rhoncus. Donec ac tellus accumsan nibh rutrum faucibus non non odio.',
  category: categories.values.sample,
  thumbnail_id: attachment('articles/thumbnails/1.png', 'Thumbnail.png', :image, article),
})

[{
  content_type: :text,
  format: :just_text,
  text: paragraphs(4),
}, {
  content_type: :text,
  format: :with_quote,
  text: paragraphs(4),
  quote: 'Fusce faucibus commodo tempor. Nunc consequat lectus et ipsum rutrum pellentesque. Cras vulputate turpis sed neque dictum blandit. Maecenas hendrerit eu nulla vel tempus. Suspendisse eget purus sit amet dolor vulputate convallis. Morbi hendrerit enim nec interdum iaculis. Nullam eget massa orci.',
}, {
  content_type: :text,
  format: :with_image,
  text: paragraphs(4),
  credit: 'John Smith',
  extra: {
    image_id: attachment('articles/callout.jpg', 'Callout.jpg', :image, article),
  },
}, {
  content_type: :text,
  format: :box_with_lefthand_image,
  text: paragraphs(4),
  extra: {
    image_id: attachment('articles/lefthand.jpg', 'Lefthand.jpg', :image, article),
  },
}, {
  content_type: :text,
  format: :box_with_righthand_image,
  text: paragraphs(4),
  extra: {
    image_id: attachment('articles/righthand.jpg', 'Righthand.jpg', :image, article),
  },
}, {
  content_type: :text,
  format: :box_over_image,
  text: paragraphs(4),
  extra: {
    image_id: attachment('articles/behind.jpg', 'Background.jpg', :image, article),
  },
}, {
  content_type: :text,
  format: :grid,
  text: paragraphs(1),
  extra: {
    items: 6.times.map {|i| { title: "Grid Item #{i}", text: sentences(3) }},
  },
}, {
  content_type: :text,
  format: :columns,
  text: paragraphs(1),
  extra: {
    items: 3.times.map {|i| { title: "Column #{i}", text: sentences(3), image_id: attachment("subtle_system_nodes/chakra-1.png", 'Column.png', :image, article) }},
  },
}, {
  content_type: :text,
  format: :ancient_wisdom,
  text: '<p><strong>Header 1</strong></p><p>Phasellus tempor sem ut libero consectetur feugiat. Nulla ultrices ut felis id consequat. Nam semper vel augue sit amet semper. Donec ut feugiat purus. Duis facilisis, tellus vel pretium auctor, mauris odio ultricies ligula, eu scelerisque lorem lectus in erat. Duis quam orci, tristique ut iaculis ac, lacinia sit amet sem. Integer vitae lacinia enim, ut egestas eros. Proin feugiat id tortor a pulvinar. Nunc at augue iaculis, facilisis ex eget, vulputate dui.</p><p><strong>Header 2</strong></p><p>Nullam at leo et lectus tristique ullamcorper. Morbi rhoncus dolor nec ornare dapibus. In lectus est, facilisis in sagittis eget, rutrum quis neque. Nam vitae ullamcorper lectus, et auctor justo. Mauris fringilla orci est, non facilisis urna euismod at. Cras lobortis tellus purus, id cursus purus rhoncus at. Donec scelerisque consectetur lacus, vitae ultricies lectus cursus quis. Ut quam est, dictum eu dapibus vitae, rhoncus eu nisi. Vivamus enim erat, sagittis a bibendum nec, varius non nulla. Sed suscipit quam vel ex suscipit, sollicitudin rutrum massa cursus. Phasellus malesuada mattis risus sit amet eleifend.</p>',
}, {
  content_type: :quote,
  quote: 'Joy starts to descend on your head all the time, spilling throughout the whole being, making you absolutely calm and beautiful.',
  credit: 'Shri Mataji',
  subtitle: 'Founder of the meditation method "Sahaja Yoga"',
  action: 'Meditation with Shri Mataji',
  url: '/en/meditations/first-experience',
}, {
  content_type: :video,
  format: :single,
  title: 'The first method of meditation',
  extra: {
    image_id: attachment('general/video.jpg', 'Single Video.jpg', :image, article),
    video_id: attachment('general/video.mp4', 'Single Video.mp4', :video, article),
  },
}, {
  content_type: :video,
  format: :gallery,
  extra: {
    items: 4.times.map {|i| {
      title: "Video #{i+1}",
      image_id: attachment("static_pages/front/slide-#{i+1}.jpg", "Gallery Video #{i+1}.jpg", :image, article),
      video_id: attachment('general/video.mp4', "Gallery Video #{i+1}.mp4", :video, article),
    }}
  },
}, {
  content_type: :image,
  format: :fit_container_width,
  credit: 'John Smith',
  extra: {
    image_id: attachment('articles/container-width.jpg', 'Container Width.jpg', :image, article),
  }
}, {
  content_type: :image,
  format: :fit_page_width,
  credit: 'John Smith',
  extra: {
    image_id: attachment('articles/page-width.jpg', 'Page Width.jpg', :image, article),
  }
}, {
  content_type: :image,
  format: :gallery,
  text: paragraphs(1),
  extra: {
    image_ids: 14.times.map{|i| attachment("articles/thumbnails/#{i+1}.png", "Gallery Image #{i+1}.png", :image, article)},
  },
}, {
  content_type: :action,
  format: :signup,
  title: 'Meditation for 7 days',
  subtitle: 'Free guide',
  text: 'Simple Exercises for a Better Life, once a day.',
  action: 'Sign up',
  extra: { mailchimp_list_id: 1 }, # TODO: Make this this mailchimp work
}, {
  content_type: :action,
  format: :button,
  action: 'Try Meditation',
  url: '/en/meditations',
}].each_with_index do |atts, index|
  section = article.sections.find_or_initialize_by(order: index)
  atts[:title] = "Section #{index+1}" unless atts[:title].present?
  atts[:order] = index
  section.update!(atts)
end

# ===== DEMO ARTICLE ===== #
article = Article.find_or_initialize_by(name: 'Demo Article')
article.update!({
  name: 'Demo Article',
  excerpt: sentences(5),
  category: categories.values.sample,
  thumbnail_id: attachment('articles/thumbnails/1.png', 'Thumbnail.png', :image, article),
})

[{
  content_type: :text,
  format: :with_quote,
  title: 'Section 1',
  text: paragraphs(4),
  quote: 'Fusce faucibus commodo tempor. Nunc consequat lectus et ipsum rutrum pellentesque. Cras vulputate turpis sed neque dictum blandit. Maecenas hendrerit eu nulla vel tempus. Suspendisse eget purus sit amet dolor vulputate convallis. Morbi hendrerit enim nec interdum iaculis. Nullam eget massa orci.',
}, {
  content_type: :text,
  format: :with_image,
  title: 'Section 2',
  text: paragraphs(3),
  credit: 'John Smith',
  extra: {
    image_id: attachment('articles/callout.jpg', 'Callout.jpg', :image, article),
  },
}, {
  content_type: :image,
  format: :fit_container_width,
  credit: 'John Smith',
  extra: {
    image_id: attachment('articles/container-width.jpg', 'Container Width.jpg', :image, article),
  }
}, {
  content_type: :text,
  format: :just_text,
  title: 'Section 3',
  text: paragraphs(3),
}, {
  content_type: :action,
  format: :button,
  action: 'Try Meditation',
  url: '/en/meditations/first-experience',
  extra: { decorations: { enabled: ['leaf'] } },
}, {
  content_type: :image,
  format: :fit_page_width,
  credit: 'John Smith',
  extra: {
    image_id: attachment('articles/page-width.jpg', 'Page Width.jpg', :image, article),
  }
}, {
  content_type: :text,
  format: :just_text,
  title: 'Section 4',
  text: paragraphs(4),
}, {
  content_type: :quote,
  quote: 'Joy starts to descend on your head all the time, spilling throughout the whole being, making you absolutely calm and beautiful.',
  credit: 'Shri Mataji',
  subtitle: 'Founder of the meditation method "Sahaja Yoga"',
  action: 'Meditation with Shri Mataji',
  url: '/en/meditations/first-experience',
}, {
  content_type: :text,
  format: :just_text,
  title: 'Section 5',
  text: paragraphs(4),
}, {
  content_type: :action,
  format: :signup,
  title: 'Meditation for 7 days',
  subtitle: 'Free guide',
  text: 'Simple Exercises for a Better Life, once a day.',
  action: 'Sign up',
  extra: { mailchimp_list_id: 1 }, # TODO: Make this this mailchimp work
}, {
  content_type: :video,
  format: :single,
  title: 'The first method of meditation',
  extra: {
    image_id: attachment('general/video.jpg', 'Single Video.jpg', :image, article),
    video_id: attachment('general/video.mp4', 'Single Video.mp4', :video, article),
  },
}, {
  content_type: :text,
  format: :just_text,
  text: paragraphs(1),
}].each_with_index do |atts, index|
  section = article.sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end


puts ' -- Finished Article Seeds -- '
