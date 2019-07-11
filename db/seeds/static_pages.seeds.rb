# rubocop:disable Layout/IndentArray
require_relative 'support'

puts ' -- Start Static Page Seeds -- '

# ===== CREATE STATIC PAGES ===== #
static_pages = {}

{
  home: 'Home Page',
  about: 'About Us',
  contact: 'Contact Us',
  shri_mataji: 'Shri Mataji',
  subtle_system: 'Chakras & Channels',
  sahaja_yoga: 'Sahaja Yoga',
  articles: 'Inspiration',
  treatments: 'Improving Meditation',
  tracks: 'Music for Meditation',
  meditations: 'Meditate Now',
  classes: 'Classes Near Me',
  self_realization: 'The First Experience',
  privacy: 'Privacy Notice',
}.each do |role, name|
  static_pages[role] = StaticPage.find_or_initialize_by(role: role)
  static_pages[role].update!(name: name)
  puts "Created Static Page - #{role}"
end

# ===== CREATE HOME PAGE CONTENT ===== #
static_pages[:home].update!(content: content([
  {
    type: :splash,
    data: {
      image: content_attachment('general/background.jpg', static_pages[:home]),
      title: 'Meditation is a state of inner peace.',
      text: 'No special skills are required, you just have to',
      action: 'Feel it',
      url: '/en/page/self-realization',
      style: :home,
    },
  },
  {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/front/sahaja-yoga.jpg', static_pages[:home]),
      title: 'Choose your meditation',
      text: '<p>Whether you’re looking to de-stress, boost your self-esteem or simply seeking a moment to pause, follow our easy yet effective guided meditations to elevate your state and establish peace within.</p>',
      action: 'Meditate Now',
      url: '/en/meditations',
      alignment: :left,
      decorations: {
        sidetext: 'Guided Meditations',
        circle: true,
      },
    },
  },
  {
    type: :video,
    data: {
      items: Array.new(3) { |_i| vimeo_attachment },
      asGallery: true,
      decorations: {
        gradient: { alignment: :right, color: :blue },
        sidetext: 'Stories',
      },
    },
  },
  {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/front/shri-mataji.jpg', static_pages[:home]),
      title: 'Making History',
      text: '<p>Shri Mataji Nirmala Devi maintained that there is a powerful, yet loving energy lying within each human being, and through her immense compassion for humanity developed the meditation technique for awakening it, described as Self-Realization.</p>',
      action: 'Learn More',
      url: '/en/page/shri-mataji',
      alignment: :center,
      decorations: {
        triangle: { alignment: :left },
        sidetext: 'Shri Mataji',
      },
    },
  },
  {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/front/music.jpg', static_pages[:home]),
      title: 'Enhance the Experience',
      text: '<p>Music is a great aid to a deep meditation experience. Personalize the soundtrack to your session with our custom music player, featuring exclusive recordings from world class musicians.</p>',
      action: 'Discover my sound',
      url: '/en/music',
      alignment: :right,
      decorations: { sidetext: 'Music' },
    },
  },
  {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/front/meditation.jpg', static_pages[:home]),
      title: 'Beyond the Practice',
      text: '<p>The benefits of meditation go far beyond what you experience during the sessions.</p><p>It has the power to improve every aspect of your life, from your personal growth, to your work and family life, and can even spark immense creativity...</p>',
      action: 'Get Inspired',
      url: '/en/inspiration',
      alignment: :center,
      invert: true,
      decorations: {
        gradient: { alignment: :left, color: :orange },
        triangle: { alignment: :right },
        sidetext: 'Results?',
      },
    },
  },
  {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/front/classes.jpg', static_pages[:home]),
      title: 'Get Connected',
      text: '<p>The experience of meditation is even stronger when it is shared! Discover the beauty of collective meditations, lead by experienced practitioners in hundreds of cities aroudn the world - always completely free.</p>',
      action: 'Classes near me',
      url: '/en/cities/local',
      alignment: :left,
      decorations: {
        sidetext: 'Meditation Classes',
        gradient: {
          color: :gray,
          alignment: :right,
        },
      },
    },
  }, {
    type: :header,
    data: {
      text: 'FAQ',
      centered: true,
    },
  }, {
    type: :link,
    data: {
      format: :articles,
      items: Article.where(name: ['Why Meditate?', 'Is it right for me?', 'Who else is doing it?']).map { |article|
        { id: article.id, name: article.name }
      },
    },
  },
]))

# ===== CREATE ABOUT PAGE CONTENT ===== #
static_pages[:about].update!(content: content([
  {
    type: :header,
    data: {
      text: 'About We Meditate',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(5),
    },
  },
]))

# ===== CREATE CONTACT PAGE CONTENT ===== #
static_pages[:contact].update!(content: content([
  {
    type: :form,
    data: {
      title: 'Still have questions? Get in touch',
      action: 'Submit',
      format: :contact,
    },
  },
]))

# ===== CREATE SHRI MATAJI PAGE CONTENT ===== #
static_pages[:shri_mataji].update!(content: content([
  {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/shri-mataji/founder.jpg', static_pages[:shri_mataji]),
      title: 'The founder of Sahaja Yoga',
      text: '<p>Shri Mataji Nirmala Devi discovered a unique method of meditation "Sahaja Yoga", which allows one to achieve inner enlightenment, and reveals the true potential of mankind. Shri Mataji devoted her entire life to the development and dissemination of this method, and today hundreds of thousands of people around the world practice Sahaja Yoga.</p>',
      alignment: :left,
      decorations: {
        sidetext: 'The Founder',
        circle: true,
      },
    },
  }, {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/shri-mataji/master-of-yoga.jpg', static_pages[:shri_mataji]),
      title: 'The great master of yoga',
      text: '<p>Shri Mataji showed that within each person there is a motherly spiritual energy called "Kundalini", the awakening of which leads a person to a state of spontaneous meditation. Unlike many ancient teachers who were only able to share this experience with a few individuals, Shri Mataji could raise the Kundalini in thousands of people, which was previously considered impossible.</p><p>It is the opportunity to awaken this inner spiritual energy that distinguishes Sahaja Yoga from other methods of meditation. It is an extraordinary living experience which allows us to touch the very essence of ourselves, to uncover our very best qualities and to achieve a state of complete peace and satisfaction.</p>',
      alignment: :center,
      decorations: { triangle: { alignment: :left } },
    },
  }, {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/shri-mataji/try-meditation.jpg', static_pages[:shri_mataji]),
      title: 'Try Guided Meditation with Shri Mataji',
      action: 'Start meditation',
      url: 'https://vimeo.com/266576047',
      alignment: :right,
      asVideo: true,
    },
  }, {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/shri-mataji/social-work.jpg', static_pages[:shri_mataji]),
      title: 'A life dedicated to humanity',
      text: '<p>Shri Mataji not only founded and spread the method of Sahaja Yoga far across the world, but also created many non-profit organizations in various fields of public life.</p><p>From a centre for destitute women and orphans and international schools with comprehensive and balanced education, to health centres using the methods of Sahaja Yoga and academies teaching classical arts - the list of Shri Mataji’s achievements is striking in its diversity.</p>',
      alignment: :left,
      stretch: true,
      decorations: {
        sidetext: 'Social Work',
        gradient: { alignment: :right, color: :blue },
      },
    },
  }, {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/shri-mataji/family.jpg', static_pages[:shri_mataji]),
      title: 'Life among great people',
      text: '<p>Right from the beginning, Shri Mataji was always surrounded by outstanding people. Her parents were scholars and political activists who played an important role in the liberation movement of India, seeking independence of their country together with Mahatma Gandhi, who noticed the extraordinary potential of the young Shri Mataji and consulted her on spiritual issues.</p><p>Throughout her life, Shri Mataji was often in the circle of prominent political and public figures. Her husband, Sir Chandrika Prasad Srivastava, started out as a young officer in the Indian Civil Service but soon rose through the ranks to become Private Secretary to the Prime Minister of India, Lal Bahadur Shastri. Later, he was appointed Secretary General of the United Nations International Maritime Organisation in London, and served in this post for four successive terms. For his relentless dedication to public service and exceptional achievements, he was awarded a knighthood by Queen Elizabeth II, the first Indian to receive such honour after India gained independence. </p>',
      alignment: :right,
      stretch: true,
      decorations: { sidetext: 'Family' },
    },
  }, {
    type: :header,
    data: {
      text: 'Early Years',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'Shri Mataji was born on the 21st of March, 1923 in Chhindwara, India under the name of Nirmala Srivastava, into a truly unique family. Descended from the royal Shalivahana dynasty of India, she was raised Christian following her forefathers’ decision to convert from Hinduism in light of the cruel treatment of widows. Her parents were highly educated; her father a lawyer and scientist, fluently speaking 14 languages ​​and famous for translating the Qur\'an into Hindi, and her mother was the first woman in India to receive an honors degree in mathematics.',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'The parents of Shri Mataji also actively participated in the struggle for India\'s independence from British occupation, both jailed several times for their involvement. Shri Mataji herself often visited the ashram of Mahatma Gandhi as a child, discussing with him means to bring about social and spiritual liberation. In 1942, Shri Mataji, as a teenager, was even detained and tortured by British soldiers for participating in the liberation movement. However, this was considered a necessary sacrifice - so much was the conviction that the internal liberation of people can come only after the country\'s liberation from foreign rule.',
    },
  }, {
    type: :image,
    data: {
      items: [{
        image: content_attachment('static_pages/shri-mataji/early-years.jpg', static_pages[:shri_mataji]),
        caption: 'Shri Mataji with family, second from the left, middle row. In the middle - Shri Mataji’s parents.',
      }],
    },
  }, {
    type: :paragraph,
    data: {
      text: 'In 1947, Shri Mataji married a young political figure, Chandrika Prasad, later known as Sir CP, with whom she had two daughters. They led a family life in India, and Shri Mataji was a housewife and raised the daughters while Sir CP helped develop the newly liberated country and moved up the political ladder, serving in various posts in the state hierarchy. However, Shri Mataji always remembered her true destiny - the search for a method for the spiritual enlightenment of mankind.',
    },
  }, {
    type: :quote,
    data: {
      text: 'When are you finally going to start your spiritual work? Now you are free, and you have to start.',
      credit: 'Mahatma Gandhi',
      caption: 'in a conversation with Shri Mataji, the day before he was assasinated',
    },
  }, {
    type: :header,
    data: {
      text: 'The founding of ‘Sahaja Yoga’',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'Shri Mataji always knew that the meaning of her life was to find a way to teach as many people as possible the truth of meditation, because only through the inner transformation of every person can the whole society become harmonious.',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'She also saw how many people try to learn the truth, and how many so-called "gurus" use this pure impulse for their own enrichment. After attending a lecture of one of such pseudo-teachers, she saw how he manipulated people, and was absolutely disgusted by this attitude. Shri Mataji spent the whole of that night on a beach in Nargol, West India, contemplating this dilemma. She knew that in order for people to reach a higher awareness of themselves they must be able to go beyond their minds and be connected to their subtle being.',
    },
  }, {
    type: :header,
    data: {
      text: 'From Nirmala to ‘Shri Mataji’',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'В скором времени Шри Матаджи начала обучать этому новому методу первых учеников в Индии. Это был непростой процесс – пробуждение кундалини - ведь издревне было известно, что только самые достойные йоги достигали такого пробуждения.',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'Однако присутствие Шри Матаджи и ее терпеливая работа над людьми, казалось, были катализатором этого процесса, и через некоторое время ее ученики достигали этого удивительного состояния внутренней свободы и легкости, а также чувствовали прохладый поток на ладонях и над головой. Именно из-за этого эффекта присутствия Шри Матаджи и ее терпеливой и бескорыстной работы над людьми, ее ученики дали ей имя «Шри Матаджи», что дословно означает «уважаемая (святая) мать».',
    },
  },
  {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/shri-mataji/sharing-the-experience.jpg', static_pages[:shri_mataji]),
      title: 'Sharing the experience',
      text: '<p>Метод медитации, открытый Шри Матаджи, начал распространяться по всему миру после того, как она с семьей переехала Лондон: ее муж Сэр Си Пи был назначен главой морской организации ООН и был переведен на службу в этот город.</p><p>От первых учеников, которых Шри Матаджи буквально приютила в своем доме в Лондоне, обучая их основам медитации и постепенно восстанавливая их разрушенные тонкие тела, до выступлений на международных конференциях в многотысячных залах в столицах стран Европы и Америми, - учение Шри Матаджи находило отклик у самых разных частей общества по всему миру.</p>',
      alignment: :left,
      stretch: true,
      decorations: {
        sidetext: 'Spreading the Word',
        gradient: { alignment: :right, color: :blue },
      },
    },
  },
  {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/shri-mataji/vision.jpg', static_pages[:shri_mataji]),
      title: 'The global vision',
      text: '<p>Right from the beginning, Shri Mataji was always surrounded by outstanding people. Her parents were scholars and political activists who played an important role in the liberation movement of India, seeking independence of their country together with Mahatma Gandhi, who noticed the extraordinary potential of the young Shri Mataji and consulted her on spiritual issues.</p><p>Throughout her life, Shri Mataji was often in the circle of prominent political and public figures. Her husband, Sir Chandrika Prasad Srivastava, started out as a young officer in the Indian Civil Service but soon rose through the ranks to become Private Secretary to the Prime Minister of India, Lal Bahadur Shastri. Later, he was appointed Secretary General of the United Nations International Maritime Organisation in London, and served in this post for four successive terms. For his relentless dedication to public service and exceptional achievements, he was awarded a knighthood by Queen Elizabeth II, the first Indian to receive such honour after India gained independence.</p>',
      alignment: :right,
      stretch: true,
      decorations: { sidetext: 'Vision' },
    },
  }, {
    type: :header,
    data: {
      text: 'Recognition around the world',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'Noble peace prize nomination twice. Personal recognition from Claes Nobel 1997 Mr. Claes Nobel, grandnephew of Alfred Nobel, chairman of United Earth and The National Society of High School Scholars, honoured the life and work of Shri Mataji in a public speech at the Royal Albert Hall.Recognizing the scientific and verifiable nature of her teachings, the Petrovskaya Academy of Arts and Sciences in St. Petersburg bestowed an Honorary Membership upon Shri Mataji, telling her, “You are even higher than science.”',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'Некоторые из выдающихся моментов жизни Шри Матаджи включают:',
    },
  }, {
    type: :structured,
    data: {
      items: [
        { title: 'Italy, 1986', text: 'Declared ‘Personality of the Year’ by the Italian Government.' },
        { title: 'Moscow, Russia, 1989', text: 'Following Shri Mataji’s meeting with the USSR Minister of Health, Sahaja Yoga was granted full government sponsorship, including funding for scientific research.' },
        { title: 'St. Petersburg, Russia, 1993', text: 'Appointed as Honorary Member of the Petrovskaya Academy of Art and Science. In the history of the Academy, only twelve people have been granted this honour, Einstein being one of them. Shri Mataji inaugurated the first International Conference on Medicine and Self-Knowledge, which became an annual event at the Academy thereafter.' },
        { title: 'Italy, 1986', text: 'Declared ‘Personality of the Year’ by the Italian Government.' },
        { title: 'Moscow, Russia, 1989', text: 'Following Shri Mataji’s meeting with the USSR Minister of Health, Sahaja Yoga was granted full government sponsorship, including funding for scientific research.' },
        { title: 'St. Petersburg, Russia, 1993', text: 'Appointed as Honorary Member of the Petrovskaya Academy of Art and Science. In the history of the Academy, only twelve people have been granted this honour, Einstein being one of them. Shri Mataji inaugurated the first International Conference on Medicine and Self-Knowledge, which became an annual event at the Academy thereafter.' },
      ],
      format: :grid,
    },
  },
]))

# ===== CREATE SAHAJA YOGA PAGE CONTENT ===== #
static_pages[:sahaja_yoga].update!(content: content([
  {
    type: :header,
    data: {
      text: 'About Sahaja Yoga',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'Coming soon',
    },
  },
]))

# ===== CREATE TRACKS PAGE CONTENT ===== #
static_pages[:tracks].update!(content: content([
  {
    type: :header,
    data: {
      text: 'Header',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :header,
    data: {
      text: 'Header',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :header,
    data: {
      text: 'Header',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  }, {
    type: :header,
    data: {
      text: 'Header',
    },
  }, {
    type: :paragraph,
    data: {
      text: sentences(4),
    },
  },
]))

# ===== CREATE TREATMENTS PAGE CONTENT ===== #
static_pages[:treatments].update!(content: content([
  {
    type: :header,
    data: {
      text: 'Methods for improving meditation',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'The state of pure meditation is reached when the Kundalini energy within is raised through all of our energy centers, or chakras, Using some simple methods to cleanse our chakras we can make this process easier and thus achieve a longer and deeper experience of thoughtless awareness.',
    },
  },
]))

# ===== CREATE CLASSES CONTENT ===== #
static_pages[:classes].update!(content: content([
  {
    type: :textbox,
    data: {
      image: content_attachment('static_pages/classes/class.jpg', static_pages[:classes]),
      title: 'Group meditation works better',
      text: '<p>Whether you’re looking to de-stress, boost your self-esteem or simply seeking a moment to pause, follow our easy yet effective guided meditations to elevate your state and establish peace within.</p>',
      alignment: :left,
      decorations: { circle: true },
    },
  }, {
    type: :header,
    data: {
      text: 'You get support from an expert',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'The benefits of meditation go far beyond what you experience during the sessions. It has the power to improve every aspect of your life, from your personal growth, to your work and family life, and can even spark immense creativity...',
    },
  },{
    type: :header,
    data: {
      text: 'What to expect at a class',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'The benefits of meditation go far beyond what you experience during the sessions. It has the power to improve every aspect of your life, from your personal growth, to your work and family life, and can even spark immense creativity...',
    },
  }, {
    type: :header,
    data: {
      text: 'FAQ',
      centered: true,
    },
  }, {
    type: :structured,
    data: {
      items: [
        { title: 'Why is it free?', text: sentences(4) },
        { title: 'What do I bring?', text: sentences(4) },
        { title: 'Do I need to have meditated before?', text: sentences(4) },
      ],
      format: :accordion,
    },
  },
]))

# ===== CREATE SELF REALIZATION CONTENT ===== #
static_pages[:self_realization].update!(content: content([
  {
    type: :video,
    data: {
      items: [vimeo_attachment],
    },
  },
]))

# ===== CREATE SELF REALIZATION CONTENT ===== #
static_pages[:privacy].update!(content: content([
  {
    type: :header,
    data: {
      text: 'Background',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'WeMeditate understands that your privacy is important to you and that you care about how your information is used and shared online. We respect and value the privacy of everyone who visits Our Site and will only collect and use information in ways that are useful to you and in a manner consistent with your rights and Our obligations under the law.',
    },
  }, {
    type: :paragraph,
    data: {
      text: 'This Policy applies to Our use of any and all data collected by us in relation to your use of Our Site. Please read this Privacy Policy carefully and ensure that you understand it. Your acceptance of Our Privacy Policy is deemed to occur upon your first use of Our Site. If you do not accept and agree with this Privacy Policy, you must stop using Our Site immediately.',
    },
  },
]))

puts ' -- Finished Static Page Seeds -- '
# rubocop:enable Layout/IndentArray
