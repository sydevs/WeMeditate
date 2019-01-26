
file_root = Rails.root.join('db/seeds/files')
puts ' -- Start Static Page Seeds -- '

def attachment path, name, type, parent
  media_file = parent.media_files.find_or_initialize_by(name: name)
  media_file.update!({ name: name, category: type, file: Rails.root.join('db/seeds/files').join(path).open })
  media_file.id
end

# ===== CREATE STATIC PAGES ===== #
static_pages = {}

{
  home: 'Front Page',
  about: 'About Us',
  contact: 'Contact Us',
  shri_mataji: 'Shri Mataji',
  subtle_system: 'Chakras & Channels',
  sahaja_yoga: 'About Sahaja Yoga',
  articles: 'Inspiration',
  treatments: 'Improving Meditation',
  tracks: 'Music for Meditation',
  meditations: 'Meditate Now',
  world: 'Meditation classes',
  country: 'Meditation classes',
  city: 'City Page Template',
}.each do |role, name|
  static_pages[role] = StaticPage.find_or_initialize_by(role: role)
  static_pages[role].update!(name: name)
  puts "Created Static Page - #{role}"
end


# ===== CREATE FRONT PAGE SECTIONS ===== #
front_page_video_id = attachment('general/video.mp4', 'Video.mp4', :video, static_pages[:home])

[{
  content_type: :special,
  format: :banner,
  title: 'Meditation is a state of inner peace.',
  text: 'No special skills are required, you just have to',
  action: 'Feel it',
  url: '/en/meditations/first-experience',
  extra: {
    desktop_image_id: attachment('general/background.jpg', 'Banner.png', :image, static_pages[:home]),
    mobile_image_id: attachment('static_pages/front/banner-mobile.png', 'Banner Mobile.png', :image, static_pages[:home]),
    banner_style: 'front_page',
    color: 'light',
  },
}, {
  content_type: :textbox,
  format: :lefthand,
  title: 'Meditate Now',
  text: '<p>Whether you\'re looking to de-stress, boost your self-esteem or simply seeking a moment to pause, follow our easy yet effective guided meditations to elevate your state and establish peace within.</p>',
  action: 'Choose your meditation',
  url: '/en/meditations',
  extra: {
    image_id: attachment('static_pages/front/sahaja-yoga.jpg', 'Sahaja Yoga.jpg', :image, static_pages[:home]),
    decorations: {
      enabled: ['sidetext', 'circle'],
      options: {
        sidetext: ['top-left'],
      },
      sidetext: 'Guided Meditations',

    },
  },
}, {
  content_type: :video,
  format: :video_gallery,
  extra: {
    items: 4.times.map {|i|
      {
        title: "Video #{i+1}",
        image_id: attachment("static_pages/front/slide-#{i+1}.jpg", "Video #{i+1}.jpg", :image, static_pages[:home]),
        video_id: front_page_video_id,
      }
    },
    decorations: {
      enabled: ['sidetext', 'gradient'],
      options: {
        sidetext: ['top-right'],
        gradient: ['right', 'blue'],
      },
      sidetext: 'Video',
    },
  },
}, {
  content_type: :textbox,
  format: :overtop,
  title: 'Making History',
  text: '<p>Shri Mataji Nirmala Devi maintained that there is a powerful, yet loving energy lying within each human being, and through her immense compassion for humanity developed the meditation technique for awakening it, described as Self-Realization.</p>',
  action: 'Learn More',
  url: '/en/page/shri-mataji',
  extra: {
    image_id: attachment('static_pages/front/shri-mataji.jpg', 'Shri Mataji.jpg', :image, static_pages[:home]),
    decorations: {
      enabled: ['sidetext', 'triangle'],
      options: {
        sidetext: ['top-left'],
        triangle: ['left'],
      },
      sidetext: 'Shri Mataji',
    },
    color: 'dark',
  },
}, {
  content_type: :textbox,
  format: :righthand,
  title: 'Enhance the Experience',
  text: '<p>Music is a great aid to a deep meditation experience. Personalize the soundtrack to your session with our custom music player, featuring exclusive recordings from world class musicians.</p>',
  action: 'Discover my sound',
  url: '/en/music',
  extra: {
    image_id: attachment('static_pages/front/music.jpg', 'Music.jpg', :image, static_pages[:home]),
    decorations: {
      enabled: ['sidetext'],
      options: {
        sidetext: ['top-right'],
      },
      sidetext: 'Music',
    },
  },
}, {
  content_type: :textbox,
  format: :overtop,
  title: 'Beyond the Practice',
  text: '<p>The benefits of meditation go far beyond what you experience during the sessions.</p><p>It has the power to improve every aspect of your life, from your personal growth, to your work and family life, and can even spark immense creativity...</p>',
  action: 'Get Inspired',
  url: '/en/inspiration',
  extra: {
    image_id: attachment('static_pages/front/meditation.jpg', 'Meditation.jpg', :image, static_pages[:home]),
    decorations: {
      enabled: ['sidetext', 'triangle', 'gradient'],
      options: {
        sidetext: ['top-left'],
        triangle: ['right'],
        gradient: ['left', 'orange'],
      },
      sidetext: 'Results?',
    },
    color: 'light',
  },
}, {
  content_type: :textbox,
  format: :lefthand,
  title: 'Get Connected',
  text: '<p>The experience of meditation is even stronger when it is shared! Discover the beauty of collective meditations, lead by experienced practitioners in hundreds of cities aroudn the world - always completely free.</p>',
  action: 'Classes near me',
  url: '/en/cities/local',
  extra: {
    image_id: attachment('static_pages/front/events.jpg', 'Events.jpg', :image, static_pages[:home]),
    decorations: {
      enabled: ['sidetext', 'gradient'],
      options: {
        sidetext: ['top-left'],
        gradient: ['right', 'gray'],
      },
      sidetext: 'Meditation Classes',
    },
  },
}, {
  content_type: :special,
  format: :articles,
  extra: {
    article_ids: Article.all.sample(4).map(&:id),
  },
}].each_with_index do |atts, index|
  section = static_pages[:home].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE ABOUT PAGE SECTIONS ===== #
[{
  content_type: :text,
  format: :just_text,
  title: 'About We Meditate',
  text: '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam gravida neque quam, eget eleifend dolor ultricies eget. Morbi sed imperdiet dolor. Nulla facilisi. Nulla sed erat cursus, bibendum tortor non, suscipit ante. Praesent venenatis libero ante, in vestibulum eros aliquam eu. Vivamus non efficitur turpis. Integer vitae nunc id ligula luctus mollis ut sit amet velit. Praesent congue sed mauris vitae aliquam.</p><p>Phasellus tempor sem ut libero consectetur feugiat. Nulla ultrices ut felis id consequat. Nam semper vel augue sit amet semper. Donec ut feugiat purus. Duis facilisis, tellus vel pretium auctor, mauris odio ultricies ligula, eu scelerisque lorem lectus in erat. Duis quam orci, tristique ut iaculis ac, lacinia sit amet sem. Integer vitae lacinia enim, ut egestas eros. Proin feugiat id tortor a pulvinar. Nunc at augue iaculis, facilisis ex eget, vulputate dui.</p><p>In congue elit eu accumsan egestas. Morbi vitae malesuada nisi. Duis elit dolor, varius feugiat tempus eu, dignissim ut lectus. Praesent sit amet est et nisl mattis facilisis. Cras sed mauris sed arcu fermentum interdum vel imperdiet enim. Nulla bibendum sed tortor vel rhoncus. Donec ac tellus accumsan nibh rutrum faucibus non non odio.</p>',
}].each_with_index do |atts, index|
  section = static_pages[:about].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE CONTACT PAGE SECTIONS ===== #
[{
  content_type: :special,
  format: :banner,
  title: 'Contact Us',
  action: 'Submit',
  url: '#',
  extra: {
    desktop_image_id: attachment('static_pages/contact/banner.jpg', 'Banner.jpg', :image, static_pages[:contact]),
    banner_style: 'contact_page',
    color: 'light',
  },
}, {
  content_type: :action,
  format: :button,
  action: 'Come Meditate',
  url: '/en/cities/local',
  extra: {
    decorations: {
      enabled: ['circle', 'gradient'],
      options: {
        gradient: ['right', 'orange'],
      },
    },
  },
}, {
  content_type: :special,
  format: :local_contacts,
  title: 'Contact any of these people for help',
  action: 'Contact Them',
  extra: {
    items: [
      { name: 'Celeste', location: 'New York' },
      { name: 'Adam', location: 'Atlanta' },
      { name: 'James', location: 'Los Angeles' },
      { name: 'Anthony', location: 'Seattle' },
      { name: 'Laura', location: 'Denver' },
    ].each_with_index.map {|atts, i|
      atts.merge({
        text: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Rerum accusantium beatae labore quod hic culpa officia ut eligendi unde, nemo veniam eius at molestiae voluptatibus, eaque maiores, illo quos totam?',
        url: 'https://www.facebook.com/',
        image_id: attachment("static_pages/contact/contacts/#{i+1}.jpg", "Contact #{i+1}.jpg", :image, static_pages[:contact]),
      })
    },
  },
}].each_with_index do |atts, index|
  section = static_pages[:contact].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE SHRI MATAJI PAGE SECTIONS ===== #
[{
  content_type: :textbox,
  format: :lefthand,
  title: 'Founder of Sahaja Yoga',
  text: '<p>Shri Mataji Nirmala Devi quietly transformed lives. For more than forty years, she travelled internationally, offering free public lectures and the experience of self-realization to all, regardless of race, religion or circumstance. She not only enabled people to pass this valuable experience on to others, but taught them the meditation technique necessary to sustain it, known as Sahaja Yoga.</p>',
  extra: {
    image_id: attachment('static_pages/shri-mataji/founder.jpg', 'Founder.jpg', :image, static_pages[:shri_mataji]),
    decorations: {
      enabled: ['sidetext'],
      options: {
        sidetext: ['top-left'],
      },
      sidetext: 'Founder',
    },
  },
}, {
  content_type: :textbox,
  format: :overtop,
  title: 'What is Sahaja Yoga?',
  text: '<p>Shri Mataji maintained that there is an innate spiritual potential within every human being, and it can be spontaneously awakened, bringing one into the state of spontaneous meditation. The inner balance and stress-reduction that accompanies the practice of Sahaja Yoga meditation has already benefited hundreds of thousands worldwide.</p><p>The ability to quickly and easily activate our innate, spiritual energy - and experience its benefits differentiates Sahaja Yoga from other forms of meditation. With practice, individuals are able to direct their own energy and redress mental, physical and emotional imbalances to achieve a state of well-being, serenity and fulfillment.</p>',
  action: 'More about Sahaja Yoga',
  url: '/en/page/about-sahaja-yoga',
  extra: {
    image_id: attachment('static_pages/shri-mataji/sahaja-yoga.jpg', 'Sahaja Yoga.jpg', :image, static_pages[:shri_mataji]),
    decorations: {
      enabled: ['sidetext', 'triangle'],
      options: {
        sidetext: ['top-left'],
        triangle: ['right'],
      },
      sidetext: 'Sahaja Yoga',
    },
    color: 'light',
  },
}, {
  content_type: :special,
  format: :try_meditation,
  title: 'Meditation under the arm',
  subtitle: 'Shri Mataji',
  url: '/en/meditations/first-experience',
  action: 'Try meditation right now',
  extra: {
    image_id: attachment('static_pages/shri-mataji/try-meditation.jpg', 'Try Meditation.jpg', :image, static_pages[:shri_mataji]),
    video_id: attachment('general/video.mp4', 'Video.mp4', :image, static_pages[:shri_mataji]),
  },
}, {
  content_type: :textbox,
  format: :lefthand,
  title: 'Social Work',
  text: '<p>Brought up in a family that considered self-sacrifice the highest calling, Shri Mataji dedicated her life to a continuous program of public and spiritual work.She created charitable organizations such as the Vishwa Nirmala Prem Ashram for destitute women and orphan children, founded international schools promoting a holistic and balanced education, established health clinics, created a classical art academy, and much more. All of these endeavors complemented her global work of spiritual transformation.</p>',
  extra: {
    image_id: attachment('static_pages/shri-mataji/social-work.jpg', 'Social Work.jpg', :image, static_pages[:shri_mataji]),
    decorations: {
      enabled: ['sidetext'],
      options: {
        sidetext: ['top-left'],
      },
      sidetext: 'Social Work',
    },
  },
}, {
  content_type: :textbox,
  format: :righthand,
  title: 'Shri Mataji\'s Family',
  text: '<p>Brought up in a family that considered self-sacrifice the highest calling, Shri Mataji dedicated her life to a continuous program of public and spiritual work.She created charitable organizations such as the Vishwa Nirmala Prem Ashram for destitute women and orphan children, founded international schools promoting a holistic and balanced education, established health clinics, created a classical art academy, and much more. All of these endeavors complemented her global work of spiritual transformation.</p>',
  extra: {
    image_id: attachment('static_pages/shri-mataji/family.jpg', 'Family.jpg', :image, static_pages[:shri_mataji]),
    decorations: {
      enabled: ['sidetext', 'gradient'],
      options: {
        sidetext: ['top-right'],
        gradient: ['right', 'blue'],
      },
      sidetext: 'Family',
    },
  },
}, {
  content_type: :structured,
  format: :grid,
  title: 'Awards',
  text: '<p>Phasellus tempor sem ut libero consectetur feugiat. Nulla ultrices ut felis id consequat. Nam semper vel augue sit amet semper. Donec ut feugiat purus. Duis facilisis, tellus vel pretium auctor, mauris odio ultricies ligula, eu scelerisque lorem lectus in erat. Duis quam orci, tristique ut iaculis ac, lacinia sit amet sem. Integer vitae lacinia enim, ut egestas eros. Proin feugiat id tortor a pulvinar. Nunc at augue iaculis, facilisis ex eget, vulputate dui.</p>',
  extra: {
    items: [
      { title: 'Italy, 1986', text: 'Declared ‘Personality of the Year’ by the Italian Government.' },
      { title: 'Moscow, Russia, 1989', text: 'Following Shri Mataji’s meeting with the USSR Minister of Health, Sahaja Yoga was granted full government sponsorship, including funding for scientific research.' },
      { title: 'St. Petersburg, Russia, 1993', text: 'Appointed as Honorary Member of the Petrovskaya Academy of Art and Science. In the history of the Academy, only twelve people have been granted this honour, Einstein being one of them. Shri Mataji inaugurated the first International Conference on Medicine and Self-Knowledge, which became an annual event at the Academy thereafter.' },
      { title: 'Italy, 1986', text: 'Declared ‘Personality of the Year’ by the Italian Government.' },
      { title: 'Moscow, Russia, 1989', text: 'Following Shri Mataji’s meeting with the USSR Minister of Health, Sahaja Yoga was granted full government sponsorship, including funding for scientific research.' },
      { title: 'St. Petersburg, Russia, 1993', text: 'Appointed as Honorary Member of the Petrovskaya Academy of Art and Science. In the history of the Academy, only twelve people have been granted this honour, Einstein being one of them. Shri Mataji inaugurated the first International Conference on Medicine and Self-Knowledge, which became an annual event at the Academy thereafter.' },
    ],
  },
}].each_with_index do |atts, index|
  section = static_pages[:shri_mataji].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE SUBTLE SYSTEM PAGE SECTIONS ===== #
[{
  content_type: :special,
  format: :subtle_system,
  title: 'Hover over a chakra to learn more',
}].each_with_index do |atts, index|
  section = static_pages[:subtle_system].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE SAHAJA YOGA PAGE SECTIONS ===== #
[{
  content_type: :text,
  format: :just_text,
  title: 'About Sahaja Yoga',
  text: '<p>Coming soon</p>',
}].each_with_index do |atts, index|
  section = static_pages[:sahaja_yoga].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE TRACKS PAGE SECTIONS ===== #
4.times.map {|i|
  {
    content_type: :text,
    format: :just_text,
    title: 'Header',
    text: '<p>In congue elit eu accumsan egestas. Morbi vitae malesuada nisi. Duis elit dolor, varius feugiat tempus eu, dignissim ut lectus. Praesent sit amet est et nisl mattis facilisis. Cras sed mauris sed arcu fermentum interdum vel imperdiet enim. Nulla bibendum sed tortor vel rhoncus. Donec ac tellus accumsan nibh rutrum faucibus non non odio.</p>',
  }
}.each_with_index do |atts, index|
  section = static_pages[:tracks].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE TREATMENTS PAGE SECTIONS ===== #
[{
  content_type: :special,
  format: :banner,
  title: 'Awaken the inner energy!',
  text: 'Before using methods to improve meditation, you need to awaken',
  action: 'Vigorous',
  url: '/en/meditations/first-experience',
  extra: {
    desktop_image_id: attachment('treatments/banner.png', 'Desktop Banner.png', :image, static_pages[:treatments]),
    mobile_image_id: attachment('treatments/banner-mobile.png', 'Mobile Banner.png', :image, static_pages[:treatments]),
    banner_style: 'treatments_page',
    color: 'dark',
  },
}, {
  content_type: :text,
  format: :just_text,
  title: 'Methods for improving meditation',
  text: '<p>Using simple methods, a person gets the opportunity to purify his energy centers and thereby adjust the state of his organs and systems (blood, lymphatic, etc.).</p><p>In people who have received self-realization, without medicines, the blood composition is corrected, the metabolism is normalized, stress is eliminated - the cause of many complex diseases.</p>',
}].each_with_index do |atts, index|
  section = static_pages[:treatments].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE MEDITATIONS PAGE SECTIONS ===== #
[{
  content_type: :special,
  format: :featured_meditations,
  extra: {
    daily_meditation: 'Meditation of the day',
    trending_meditation: 'Trending now',
    random_meditation: {
      title: 'Let Fate Decide',
      image_id: attachment('general/video.jpg', 'Random Meditation.png', :image, static_pages[:meditations]),
      subtitle: 'Generate a random meditation',
      text: 'Sahaja Yoga is a method of obtaining a real experience of introspection and worldview.',
    },
  },
}, {
  content_type: :special,
  format: :custom_meditation,
  title: 'Set up your own Meditation',
  action: 'Start meditation',
  extra: {
    goal_title: 'I want to feel',
    goal_action: 'Choose feelings',
    duration_title: 'I have',
    duration_suffix: 'min',
    decorations: {
      enabled: ['sidetext'],
      options: {
        sidetext: ['top-left'],
      },
      sidetext: 'Set up your own Meditation',
    },
  },
}].each_with_index do |atts, index|
  section = static_pages[:meditations].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE TREATMENTS PAGE SECTIONS ===== #
[{
  content_type: :special,
  format: :banner,
  title: 'Awaken the inner energy!',
  text: 'Before using methods to improve meditation, you need to awaken',
  action: 'Vigorous',
  url: '/en/meditations/first-experience',
  extra: {
    desktop_image_id: attachment('treatments/banner.png', 'Desktop Banner.png', :image, static_pages[:treatments]),
    mobile_image_id: attachment('treatments/banner-mobile.png', 'Mobile Banner.png', :image, static_pages[:treatments]),
    banner_style: 'treatments_page',
    color: 'dark',
  },
}, {
  content_type: :text,
  format: :just_text,
  title: 'Methods for improving meditation',
  text: '<p>Using simple methods, a person gets the opportunity to purify his energy centers and thereby adjust the state of his organs and systems (blood, lymphatic, etc.).</p><p>In people who have received self-realization, without medicines, the blood composition is corrected, the metabolism is normalized, stress is eliminated - the cause of many complex diseases.</p>',
}].each_with_index do |atts, index|
  section = static_pages[:treatments].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE COUNTRY PAGE SECTIONS ===== #
[{
  content_type: :special,
  format: :country,
  title: 'It\'s much easier to meditate together!',
  text: 'Come to free classes in your city',
  extra: {
    action_title: 'No classes in your city?',
    action_subtitle: 'Visit the free webinar!',
    action_text: 'Let\'s go',
  },
}].each_with_index do |atts, index|
  section = static_pages[:country].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE WORLD PAGE SECTIONS ===== #
[{
  content_type: :special,
  format: :world,
  title: 'Find local classes near you',
  text: 'Lorem ipsum dolor sit amet consectetur adipisicing elit.',
  action: 'Choose a country',
}].each_with_index do |atts, index|
  section = static_pages[:world].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

# ===== CREATE CITY PAGE SECTIONS ===== #
[{
  content_type: :special,
  format: :banner,
  title: 'Meditation in %city',
  text: 'Free classes for beginners - unlock your true potential',
  action: 'Join the class',
  extra: { banner_style: 'city_page' }
}, {
  label: 'Better to Meditation Together',
  content_type: :text,
  format: :just_text,
  title: 'Meditation works better in a group',
  text: '<p>In congue elit eu accumsan egestas. Morbi vitae malesuada nisi. Duis elit dolor, varius feugiat tempus eu, dignissim ut lectus. Praesent sit amet est et nisl mattis facilisis. Cras sed mauris sed arcu fermentum interdum vel imperdiet enim. Nulla bibendum sed tortor vel rhoncus. Donec ac tellus accumsan nibh rutrum faucibus non non odio.</p>',
}, {
  content_type: :special,
  format: :city_sections,
}, {
  content_type: :special,
  format: :venue_map,
}, {
  content_type: :special,
  format: :local_contacts,
  title: 'Questions?',
  subtitle: 'Ask the instructors directly!',
  action: 'Ask',
}, {
  label: 'Frequently Asked Questions',
  content_type: :text,
  format: :just_text,
  title: 'FAQ',
  text: '<p><strong>What to bring with me?</strong></p><p>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Eveniet harum iste similique, vel, cupiditate modi voluptatibus necessitatibus eaque ut rem, esse corrupti vero itaque eos fugiat quisquam ipsum mollitia libero.</p><p><strong>Why is it free?</strong></p><p>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Eveniet harum iste similique, vel, cupiditate modi voluptatibus necessitatibus eaque ut rem, esse corrupti vero itaque eos fugiat quisquam ipsum mollitia libero.</p>',
}, {
  label: 'Sign Up Button',
  content_type: :action,
  format: :button,
  action: 'Sign up for a free class',
  url: '#signup',
}].each_with_index do |atts, index|
  section = static_pages[:city].sections.find_or_initialize_by(order: index)
  atts[:order] = index
  section.update!(atts)
end

puts ' -- Finished Static Page Seeds -- '
