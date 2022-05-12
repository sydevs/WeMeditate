# rubocop:disable Layout/IndentArray
require_relative 'support'

puts ' -- Start Article Seeds -- '

# ===== CREATE AUTHOR ===== #
author = Author.find_or_initialize_by(name: 'Jane Smith')
author.update!({
  name: 'Jane Smith',
  title: 'Meditation Practitioner',
  description: sentences(4),
  years_meditating: 12,
  image: file_root.join('articles/author.jpg').open,
  country_code: 'GB',
  state: :published,
  published_at: DateTime.now,
})

puts "Created Author - #{author.name}"

# ===== CREATE CATEGORIES ===== #
categories = {}

%w[Stories Wisdom Creativity Events Articles].each_with_index do |name, index|
  categories[name] = Category.find_or_initialize_by(order: index)
  categories[name].update!({
    name: name,
    order: index,
    published: true,
    published_at: DateTime.now,
  })
  puts "Created Category - #{name}"
end

# ===== CREATE GENERIC ARTICLE ===== #
14.times.each do |index|
  index += 1
  article = Article.find_or_initialize_by(name: "Article #{index}")
  article.update!({
    name: "Article #{index}",
    excerpt: sentences(2),
    category: categories.values.sample,
    date: nil,
    vimeo_id: nil,
    state: :published,
    published_at: DateTime.now,
  })
  article.update! thumbnail_id: attachment("articles/thumbnails/#{index}.png", article)

  puts "Created Generic Article #{index}"
end

# ===== ADD RANDOM SPECIAL ARTICLES ===== #
Article.with_translation.order('RANDOM()').limit(5).each do |article|
  article.update! date: (1..500).to_a.sample.days.from_now
  puts "Added Date #{article.date} to #{article.name}"
end

Article.with_translation.order('RANDOM()').limit(5).each do |article|
  article.update! vimeo_id: 208643382
  puts "Added Video to #{article.name}"
end

Article.with_translation.order('RANDOM()').limit(3).each do |article|
  article.update! priority: Article.priorities[:low]
  puts "Set Low Priority for #{article.name}"
end

Article.with_translation.order('RANDOM()').limit(3).each do |article|
  article.update! priority: Article.priorities[:high]
  puts "Set High Priority for #{article.name}"
end

# ===== CREATE STATE ARTICLES ===== #
3.times.each do |index|
  index += 1
  article = Article.find_or_initialize_by(name: "WIP Article #{index}")
  article.update!({
    name: "WIP Article #{index}",
    excerpt: sentences(2),
    category: categories.values.sample,
    date: nil,
    vimeo_id: nil,
    state: :in_progress,
  })
  article.update! thumbnail_id: attachment("articles/thumbnails/#{index}.png", article)

  puts "Created In Progress Article #{index}"
end

3.times.each do |index|
  index += 1
  article = Article.find_or_initialize_by(name: "Unpublished Article #{index}")
  article.update!({
    name: "Unpublished Article #{index}",
    excerpt: sentences(2),
    category: categories.values.sample,
    date: nil,
    vimeo_id: nil,
    state: :unpublished,
    published_at: DateTime.now,
  })
  article.update! thumbnail_id: attachment("articles/thumbnails/#{index}.png", article)

  puts "Created Unpublished Article #{index}"
end

3.times.each do |index|
  index += 1
  article = Article.find_or_initialize_by(name: "Archived Article #{index}")
  article.update!({
    name: "Archived Article #{index}",
    excerpt: sentences(2),
    category: categories.values.sample,
    date: nil,
    vimeo_id: nil,
    state: :archived,
    published_at: [nil, DateTime.now].sample,
  })
  article.update! thumbnail_id: attachment("articles/thumbnails/#{index}.png", article)

  puts "Created Archived Article #{index}"
end

4.times.each do |index|
  index += 1
  article = Article.find_or_initialize_by(name: "Pinned Article #{index}")
  article.update!({
    name: "Pinned Article #{index}",
    excerpt: sentences(2),
    category: categories.values.sample,
    date: nil,
    vimeo_id: nil,
    state: :published,
    priority: Article.priorities[:pinned],
    published_at: DateTime.now,
  })
  article.update! thumbnail_id: attachment("articles/thumbnails/#{index}.png", article)

  puts "Created Pinned Article #{index}"
end

# ===== FAQ ARTICLES ===== #
faq = Article.find_or_initialize_by(name: 'Why Meditate?')
faq.update!({
  name: 'Why Meditate?',
  excerpt: 'The benefits of meditation cover all areas of wellbeing, be it mental, physical or emotional, and touch all spheres of day to day life. What’s more the benefits can be felt by literally anyone.',
  category: categories['Articles'],
  state: :published,
  published_at: DateTime.now,
  original_locale: :en,
})
faq.update! thumbnail_id: attachment('articles/thumbnails/1.png', faq)

faq = Article.find_or_initialize_by(name: 'Is it right for me?')
faq.update!({
  name: 'Is it right for me?',
  excerpt: 'There are many myths about meditation which can put one off trying it out, such as the length of time needed or the right environment. We debunk these myths and prove that meditation is truly for everyone.',
  category: categories['Articles'],
  state: :published,
  published_at: DateTime.now,
  original_locale: :en,
})
faq.update! thumbnail_id: attachment('articles/thumbnails/2.png', faq)

faq = Article.find_or_initialize_by(name: 'Who else is doing it?')
faq.update!({
  name: 'Who else is doing it?',
  excerpt: 'There are many myths about meditation which can put one off trying it out, such as the length of time needed or the right environment. We debunk these myths and prove that meditation is truly for everyone.',
  category: categories['Articles'],
  state: :published,
  published_at: DateTime.now,
  original_locale: :en,
})
faq.update! thumbnail_id: attachment('articles/thumbnails/3.png', faq)

# ===== DEMO ARTICLE ===== #
article = Article.find_or_initialize_by(name: 'Demo Article')
article.update!({
  name: 'Demo Article',
  excerpt: sentences(2),
  category: categories.values.sample,
  state: :published,
  published_at: DateTime.now,
  author: author,
  original_locale: :en,
})
article.update! thumbnail_id: attachment('articles/thumbnails/1.png', article)

article.update!(content: content([
  {
    type: :paragraph,
    data: {
      type: :header,
      text: 'Section 1',
      level: :h2,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :textbox,
    data: {
      type: :text,
      text: sentences(1),
      alignment: :right,
      style: :simple,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      type: :header,
      text: 'Section 2',
      level: :h2,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :media,
    data: {
      type: :image,
      items: [{
        image: content_attachment('articles/callout.jpg', article),
        credit: 'John Smith',
      }],
      position: :left,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :media,
    data: {
      type: :image,
      items: [{
        image: content_attachment('articles/container-width.jpg', article),
        credit: 'John Smith',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
    },
  },
  {
    type: :paragraph,
    data: {
      type: :header,
      text: 'Section 3',
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :action,
    data: {
      type: :button,
      text: 'Try Meditation',
      url: '/page/the-first-experience',
      decorations: { leaves: true },
    },
  }, {
    type: :media,
    data: {
      type: :image,
      items: [{
        image: content_attachment('articles/page-width.jpg', article),
        credit: 'John Smith',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
      size: :wide,
      decorations: { triangle: { alignment: :right } },
    },
  }, {
    type: :paragraph,
    data: {
      type: :header,
      text: 'Section 4',
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(6),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :textbox,
    data: {
      type: :text,
      text: 'Joy starts to descend on your head all the time, spilling throughout the whole being, making you absolutely calm and beautiful.',
      credit: 'Shri Mataji',
      caption: 'Founder of the meditation method "Sahaja Yoga"',
      style: :hero,
    },
  }, {
    type: :action,
    data: {
      type: :button,
      text: 'Meditation with Shri Mataji',
      url: '/page/the-first-experience',
    },
  }, {
    type: :paragraph,
    data: {
      type: :header,
      text: 'Section 5',
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :action,
    data: {
      type: :form,
      title: '7 Daily Meditations',
      subtitle: 'Free guide',
      text: 'Simple meditations for a better life, delivered to you daily for a week.',
      action: 'Get the guide',
      form: :signup,
    },
  }, {
    type: :vimeo,
    data: {
      legacy: true,
      items: [vimeo_attachment],
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  },
]))

# ===== TEST ARTICLE ===== #
article = Article.find_or_initialize_by(name: 'Test Article')
article.update!({
  name: 'Test Article',
  excerpt: sentences(2),
  category: categories.values.sample,
  state: :published,
  published_at: DateTime.now,
  original_locale: :en,
})
article.update! thumbnail_id: attachment('articles/thumbnails/1.png', article)

article.update!(content: content([
  {
    type: :paragraph,
    data: {
      type: :header,
      text: 'Section 1',
      level: :h2,
    },
  }, {
    type: :paragraph,
    data: {
      type: :header,
      text: 'Section 2',
      level: :h3,
    },
  }, {
    type: :paragraph,
    data: {
      type: :header,
      text: 'Section 3',
      level: :h4,
    },
  }, {
    type: :paragraph,
    data: {
      type: :header,
      text: 'Section 4',
      level: :h5,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(8),
    },
  }, {
    type: :list,
    data: {
      type: :text,
      items: Array.new(3) { |_i| sentences(1) },
      style: :unordered,
    },
  }, {
    type: :list,
    data: {
      type: :text,
      items: Array.new(3) { |_i| sentences(1) },
      style: :ordered,
    },
  }, {
    type: :list,
    data: {
      type: :text,
      items: Array.new(3) { |_i| sentences(1) },
      style: :leaf,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(8),
    },
  }, {
    type: :textbox,
    data: {
      type: :text,
      text: sentences(1),
      credit: 'John Smith',
      caption: 'University professor',
      alignment: :right,
      style: :hero,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(8),
    },
  }, {
    type: :textbox,
    data: {
      type: :text,
      text: sentences(1),
      credit: 'John Smith',
      caption: 'University professor',
      alignment: :left,
      style: :hero,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(8),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(8),
    },
  }, {
    type: :textbox,
    data: {
      type: :text,
      text: sentences(2),
      credit: 'John Smith',
      caption: 'University professor',
      alignment: :center,
      style: :hero,
    },
  }, {
    type: :textbox,
    data: {
      type: :text,
      text: sentences(2),
      credit: 'A Poem About Truth',
      caption: 'John Smith',
      position: :left,
      style: :simple,
    },
  }, {
    type: :textbox,
    data: {
      type: :text,
      text: sentences(2),
      credit: 'A Poem About Truth',
      caption: 'John Smith',
      alignment: :right,
      style: :simple,
    },
  }, {
    type: :textbox,
    data: {
      type: :text,
      text: sentences(2),
      credit: 'A Poem About Truth',
      caption: 'John Smith',
      position: :center,
      style: :simple,
    },
  }, {
    type: :action,
    data: {
      type: :button,
      text: 'Button Text',
      url: '/inspiration',
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(8),
    },
  }, {
    type: :media,
    data: {
      type: :image,
      items: [{
        image: content_attachment('articles/callout.jpg', article),
        credit: 'John Smith',
        caption: 'This is a text caption, for this image.',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
      position: :left,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(6),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(8),
    },
  }, {
    type: :media,
    data: {
      type: :image,
      items: [{
        image: content_attachment('articles/callout.jpg', article),
        credit: 'John Smith',
        caption: 'This is a text caption, for this image.',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
      position: :right,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :media,
    data: {
      type: :image,
      items: [{
        image: content_attachment('articles/container-width.jpg', article),
        credit: 'John Smith',
        caption: 'This is a text caption, for this image.',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :media,
    data: {
      type: :image,
      items: [{
        image: content_attachment('articles/page-width.jpg', article),
        credit: 'John Smith',
        caption: 'This is a text caption, for this image.',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
      size: :wide,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :media,
    data: {
      type: :image,
      items: Array.new(9) { |i| { image: content_attachment("articles/thumbnails/#{i + 1}.png", article) } },
      quantity: :gallery,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :whitespace,
    data: {
      size: :small,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :whitespace,
    data: {
      size: :medium,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :whitespace,
    data: {
      size: :large,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(5),
    },
  }, {
    type: :vimeo,
    data: {
      legacy: true,
      items: [vimeo_attachment],
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :vimeo,
    data: {
      legacy: true,
      items: Array.new(4) { |_i| vimeo_attachment },
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :action,
    data: {
      type: :form,
      title: 'Still Have Questions?',
      subtitle: 'Contact us now,',
      text: 'or don\'t',
      action: 'Submit',
      form: :contact,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :action,
    data: {
      type: :form,
      title: 'Want to know more?',
      subtitle: 'Sign up for our newsletter,',
      text: 'or don\'t',
      action: 'Submit',
      form: :signup,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :layout,
    data: {
      type: :grid,
      items: Array.new(4) { |i| { title: "Item #{i}", text: sentences(3) } },
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :layout,
    data: {
      type: :accordion,
      items: Array.new(4) { |i| { title: "Item #{i + 1}", text: sentences(3) } },
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :layout,
    data: {
      type: :columns,
      items: Array.new(3) { |i|
        {
          title: "Item #{i + 1}",
          text: sentences(5),
          image: content_attachment("articles/thumbnails/#{i + 1}.png", article),
        }
      },
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :textbox,
    data: {
      type: :image,
      image: content_attachment('articles/lefthand.jpg', article),
      title: 'Overlapping Block',
      text: paragraphs(1),
      action: 'Read More',
      url: '/en',
      position: :left,
      spacing: :overlap,
    },
  }, {
    type: :paragraph,
    data: {
      type: :text,
      text: sentences(4),
    },
  }, {
    type: :textbox,
    data: {
      type: :image,
      image: content_attachment('articles/lefthand.jpg', article),
      title: 'Separated Block',
      text: paragraphs(1),
      action: 'Read More',
      url: '/en',
      position: :right,
      spacing: :separate,
    },
  }, {
    type: :textbox,
    data: {
      type: :image,
      image: content_attachment('articles/lefthand.jpg', article),
      title: 'About Us',
      text: paragraphs(1),
      action: 'Read More',
      url: '/en',
      position: :left,
    },
  }, {
    type: :textbox,
    data: {
      type: :image,
      image: content_attachment('articles/righthand.jpg', article),
      title: 'About Us',
      text: paragraphs(1),
      action: 'Read More',
      url: '/en',
      position: :right,
    },
  }, {
    type: :textbox,
    data: {
      type: :image,
      image: content_attachment('articles/behind.jpg', article),
      title: 'About Us',
      text: paragraphs(1),
      action: 'Read More',
      url: '/en',
      background: :image,
      position: :left,
      color: :light,
    },
  }, {
    type: :textbox,
    data: {
      type: :image,
      image: content_attachment('articles/ancient-wisdom.jpg', article),
      title: 'Ancient Knowledge',
      text: paragraphs(2),
      action: 'Read More',
      url: '/en',
      position: :left,
      background: :ornate,
    },
  }, {
    type: :textbox,
    data: {
      type: :image,
      image: content_attachment('articles/ancient-wisdom.jpg', article),
      title: 'Ancient Knowledge',
      text: paragraphs(2),
      action: 'Learn More',
      url: '/en',
      position: :right,
      background: :ornate,
    },
  }, {
    type: :catalog,
    data: {
      type: :articles,
      title: 'Articles',
      items: Article.all.sample(6).pluck(:id),
    },
  }, {
    type: :catalog,
    data: {
      type: :treatments,
      title: 'Treatments',
      items: Treatment.all.sample(3).pluck(:id),
    },
  }, {
    type: :catalog,
    data: {
      type: :meditations,
      title: 'Meditations',
      items: Meditation.all.sample(3).pluck(:id),
    },
  },
]))

puts ' -- Finished Article Seeds -- '
# rubocop:enable Layout/IndentArray
