# rubocop:disable Layout/IndentArray
require_relative 'support'

puts ' -- Start Article Seeds -- '

# ===== CREATE AUTHOR ===== #
author = Author.find_or_initialize_by(name: 'John Smith')
author.update!({
  name: 'Jane Smith',
  title: 'WeMeditate Writer',
  description: sentences(4),
  years_meditating: 12,
  image: file_root.join('articles/author.jpg').open,
  country_code: 'GB',
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
    date: '',
    vimeo_id: '',
    published: true,
    published_at: DateTime.now,
  })
  article.update! thumbnail_id: attachment("articles/thumbnails/#{index}.png", article)

  puts "Created Generic Article #{index}"
end

3.times.each do |index|
  index += 1
  article = Article.find_or_initialize_by(name: "Article #{index}")
  article.update!({
    name: "Article #{index}",
    excerpt: sentences(2),
    thumbnail_id: attachment("articles/thumbnails/#{index}.png", article),
    category: categories.values.sample,
    date: '',
    vimeo_id: '',
    published: false,
    published_at: DateTime.now,
  })

  puts "Created Unpublished Article #{index}"
end

# ===== ADD RANDOM SPECIAL ARTICLES ===== #
Article.all.sample(5).each do |article|
  article.update!(date: (1..500).to_a.sample.days.from_now)
  puts "Added Date #{article.date} to #{article.name}"
end

Article.all.sample(5).each do |article|
  article.update!(vimeo_id: 208643382)
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

# ===== FAQ ARTICLES ===== #
faq = Article.find_or_initialize_by(name: 'Why Meditate?')
faq.update!({
  name: 'Why Meditate?',
  excerpt: 'The benefits of meditation cover all areas of wellbeing, be it mental, physical or emotional, and touch all spheres of day to day life. What’s more the benefits can be felt by literally anyone.',
  category: categories['Articles'],
  published: true,
  published_at: DateTime.now,
  original_locale: :en,
})
faq.update! thumbnail_id: attachment('articles/thumbnails/1.png', faq)

faq = Article.find_or_initialize_by(name: 'Is it right for me?')
faq.update!({
  name: 'Is it right for me?',
  excerpt: 'There are many myths about meditation which can put one off trying it out, such as the length of time needed or the right environment. We debunk these myths and prove that meditation is truly for everyone.',
  category: categories['Articles'],
  published: true,
  published_at: DateTime.now,
  original_locale: :en,
})
faq.update! thumbnail_id: attachment('articles/thumbnails/2.png', faq)

faq = Article.find_or_initialize_by(name: 'Who else is doing it?')
faq.update!({
  name: 'Who else is doing it?',
  excerpt: 'There are many myths about meditation which can put one off trying it out, such as the length of time needed or the right environment. We debunk these myths and prove that meditation is truly for everyone.',
  category: categories['Articles'],
  published: true,
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
  published: true,
  published_at: DateTime.now,
  author: author,
  original_locale: :en,
})
article.update! thumbnail_id: attachment('articles/thumbnails/1.png', article)

article.update!(content: content([
  {
    type: :header,
    data: {
      text: 'Section 1',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :quote,
    data: {
      text: sentences(1),
      callout: :right,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :header,
    data: {
      text: 'Section 2',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :image,
    data: {
      items: [{
        image: content_attachment('articles/callout.jpg', article),
        credit: 'John Smith',
      }],
      callout: :left,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :image,
    data: {
      items: [{
        image: content_attachment('articles/container-width.jpg', article),
        credit: 'John Smith',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
    },
  },
  {
    type: :header,
    data: {
      text: 'Section 3',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :link,
    data: {
      action: 'Try Meditation',
      url: '/page/the-first-experience',
      format: :button,
      decorations: { leaves: true },
    },
  }, {
    type: :image,
    data: {
      items: [{
        image: content_attachment('articles/page-width.jpg', article),
        credit: 'John Smith',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
      stretch: :true,
      decorations: { triangle: { alignment: :right } },
    },
  }, {
    type: :header,
    data: {
      text: 'Section 4',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(6),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :quote,
    data: {
      text: 'Joy starts to descend on your head all the time, spilling throughout the whole being, making you absolutely calm and beautiful.',
      credit: 'Shri Mataji',
      caption: 'Founder of the meditation method "Sahaja Yoga"',
    },
  }, {
    type: :link,
    data: {
      action: 'Meditation with Shri Mataji',
      url: '/page/the-first-experience',
      format: :button,
    },
  }, {
    type: :header,
    data: {
      text: 'Section 5',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :form,
    data: {
      title: '7 Daily Meditations',
      subtitle: 'Free guide',
      text: 'Simple meditations for a better life, delivered to you daily for a week.',
      action: 'Get the guide',
      format: :signup,
    },
  }, {
    type: :video,
    data: {
      items: [vimeo_attachment],
    },
  }, {
    type: :paragraph,
    data: {
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
  published: true,
  published_at: DateTime.now,
  original_locale: :en,
})
article.update! thumbnail_id: attachment('articles/thumbnails/1.png', article)

article.update!(content: content([
  {
    type: :header,
    data: {
      text: 'Section 1',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(8),
    },
  }, {
    type: :list,
    data: {
      items: Array.new(3) { |_i| sentences(1) },
      style: :unordered,
    },
  }, {
    type: :list,
    data: {
      items: Array.new(3) { |_i| sentences(1) },
      style: :ordered,
    },
  }, {
    type: :list,
    data: {
      items: Array.new(3) { |_i| sentences(1) },
      style: :leaf,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(8),
    },
  }, {
    type: :quote,
    data: {
      text: sentences(1),
      credit: 'John Smith',
      caption: 'University professor',
      callout: :right,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(8),
    },
  }, {
    type: :quote,
    data: {
      text: sentences(1),
      credit: 'John Smith',
      caption: 'University professor',
      callout: :left,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(8),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(8),
    },
  }, {
    type: :quote,
    data: {
      text: sentences(2),
      credit: 'John Smith',
      caption: 'University professor',
    },
  }, {
    type: :link,
    data: {
      action: 'Button Text',
      url: '/en/inspiration',
      format: :button,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(8),
    },
  }, {
    type: :image,
    data: {
      items: [{
        image: content_attachment('articles/callout.jpg', article),
        credit: 'John Smith',
        caption: 'This is a text caption, for this image.',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
      callout: :left,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(6),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(8),
    },
  }, {
    type: :image,
    data: {
      items: [{
        image: content_attachment('articles/callout.jpg', article),
        credit: 'John Smith',
        caption: 'This is a text caption, for this image.',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
      callout: :right,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  }, {
    type: :image,
    data: {
      items: [{
        image: content_attachment('articles/container-width.jpg', article),
        credit: 'John Smith',
        caption: 'This is a text caption, for this image.',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :image,
    data: {
      items: [{
        image: content_attachment('articles/page-width.jpg', article),
        credit: 'John Smith',
        caption: 'This is a text caption, for this image.',
      }], # rubocop:disable Style/TrailingCommaInArrayLiteral
      stretch: true,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :image,
    data: {
      items: Array.new(9) { |i| { image: content_attachment("articles/thumbnails/#{i + 1}.png", article) } },
      asGallery: true,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :video,
    data: {
      items: [vimeo_attachment],
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :video,
    data: {
      items: Array.new(4) { |_i| vimeo_attachment },
      asGallery: true,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :form,
    data: {
      title: 'Still Have Questions?',
      subtitle: 'Contact us now,',
      text: 'or don\'t',
      action: 'Submit',
      format: :contact,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :form,
    data: {
      title: 'Want to know more?',
      subtitle: 'Sign up for our newsletter,',
      text: 'or don\'t',
      action: 'Submit',
      format: :signup,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :structured,
    data: {
      items: Array.new(4) { |i| { title: "Item #{i}", text: sentences(3) } },
      format: :grid,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :structured,
    data: {
      items: Array.new(4) { |i| { title: "Item #{i}", text: sentences(3) } },
      format: :accordion,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :structured,
    data: {
      items: Array.new(3) { |i|
        {
          title: "Item #{i + 1}",
          text: sentences(5),
          image: content_attachment("articles/thumbnails/#{i + 1}.png", article),
        }
      },
      format: :columns,
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :textbox,
    data: {
      image: content_attachment('articles/lefthand.jpg', article),
      title: 'About Us',
      text: paragraphs(1),
      action: 'Read More',
      url: '/en',
      alignment: :left,
    },
  }, {
    type: :textbox,
    data: {
      image: content_attachment('articles/righthand.jpg', article),
      title: 'About Us',
      text: paragraphs(1),
      action: 'Read More',
      url: '/en',
      alignment: :right,
    },
  }, {
    type: :textbox,
    data: {
      image: content_attachment('articles/behind.jpg', article),
      title: 'About Us',
      text: paragraphs(1),
      action: 'Read More',
      url: '/en',
      alignment: :center,
      invert: true,
    },
  }, {
    type: :textbox,
    data: {
      image: content_attachment('articles/ancient-wisdom.jpg', article),
      title: 'Ancient Knowledge',
      text: paragraphs(2),
      action: 'Read More',
      url: '/en',
      alignment: :left,
      asWisdom: true,
    },
  }, {
    type: :textbox,
    data: {
      image: content_attachment('articles/ancient-wisdom.jpg', article),
      title: 'Ancient Knowledge',
      text: paragraphs(2),
      action: 'Learn More',
      url: '/en',
      alignment: :right,
      asWisdom: true,
    },
  }, {
    type: :link,
    data: {
      format: :articles,
      items: Article.all.sample(6).map { |article_item|
        { id: article_item.id, name: article_item.name }
      },
    },
  },
]))

puts ' -- Finished Article Seeds -- '
# rubocop:enable Layout/IndentArray
