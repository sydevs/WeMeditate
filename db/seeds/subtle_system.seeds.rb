# rubocop:disable Layout/IndentArray
require_relative 'support'

puts ' -- Start Subtle System Seeds -- '

chakra_in_life_content = ''
chakra_in_life_content << '<p>By manifesting the qualities of our Mooladhara chakra in our daily life, this center can grow stronger, deepening our meditations and making us less susceptible to imbalances. When we neglect this chakra we may lack spontaneous joy and dynamism, make unwise decisions and swing to extremes of a sexual nature.</p>'
chakra_in_life_content << '<p><b>Tips for a balanced Mooladhara chakra:</b></p>'
chakra_in_life_content << '<p> - Make a surprise gift or experience for a friend. See just how much joy you can bring to them!</p>'
chakra_in_life_content << '<p> - Whether in studies or work, try for one hour to do your tasks without overthinking.</p>'
chakra_in_life_content << '<p> - Try to keep your attention on nature throughout the day - look at the sky, the grass, admire the flowers!</p>'
chakra_in_life_content << '<p> - If you have a desire, try to detach from the outcome completely, and see if you can find joy in any result.</p>'

# ===== CREATE TREATMENTS ===== #
treatments = []

[{
  name: 'Foot Soak',
  excerpt: 'Simple and inexpensive, soaking your feet in saltwater is the daily habit you didn’t know you needed. Imagine standing with your feet in the ocean, letting it soothe your stresses away and calm your mind. Luckily, foot-soaking can also be done in the comfort of your own home!',
}, {
  name: 'Ice on Liver',
  excerpt: 'Feeling overworked and exhausted? The liver is like an overheated running engine, constantly working to provide fuel for the brain. Cool your thoughts down by meditating with an ice pack on your liver.',
}, {
  name: 'Candle Flame',
  excerpt: 'Feeling lethargic, overly-emotional or depressed? The left channel functions properly when we are in a balanced emotional state. This channel can freeze up when out of balance, leaving us feeling sad or helpless. To bring light and warmth back within, try a candle flame!',
}, {
  name: 'Hand on Chakra',
  excerpt: 'We can heal ourselves with the energy that flows through our hands, once our Kundalini is awakened. Placing our hand on a Chakra is an easy and effective way of invigorating it and strengthening its qualities in us.',
}, {
  name: 'Mantras',
  excerpt: sentences(1),
}, {
  name: 'Releasing Guilt',
  excerpt: sentences(1),
}].each_with_index do |atts, index| # rubocop:disable Style/TrailingCommaInArrayLiteral
  treatment = Treatment.find_or_initialize_by(order: index)
  treatment.update!(atts.merge({
    order: index,
    thumbnail_id: attachment("treatments/#{index + 2}.jpg", treatment),
    vertical_vimeo_id: 152153054,
    horizontal_vimeo_id: 208643382,
    content: content([
      { type: :header, data: { text: 'When is it used?' } },
      { type: :paragraph, data: { text: 'You may have experienced the soothing feeling of sitting on the bank of a river, or standing on an ocean shore, with your feet in the cool water on a hot day. Maybe you were chatting with a friend and enjoying the view, not really paying attention to your state of being, but nevertheless the water would have cooled you down, relaxed and invigorated you.' } },
      { type: :paragraph, data: { text: 'When you want to wind down after a hard day’s work or calm yourself before going to bed, doing a foot-soak is one of the easiest and most effective techniques out there. Whether you are feeling down, or hyped up and restless, soaking your feet in salt-water helps to restore balance within. Once you get into the routine of enjoying this simple 10-minute method, it can become as important to you as brushing your teeth.' } },
      { type: :header, data: { text: 'How is it done?' } },
      { type: :paragraph, data: { text: 'You will need a plastic tub designated solely for this purpose. Fill it with enough water to cover your feet with water up to your ankles. The water should be cool if you are feeling overactive, and warm if you are feeling more lethargic or emotional. Take lukewarm water if in doubt. Add a handful of salt to your water (we recommend sea salt). Prepare a chair to sit on, a towel to dry your feet and a jug of water to rinse your feet after the 10-minute foot-soak. Once all this is in place, you are ready to begin.' } },
      { type: :paragraph, data: { text: 'First, to start the foot-soak raise your Kundalini and give yourself a Bandhan, then sit with your palms facing upward and your feet immersed in the salt water. Try to keep your eyes closed, with your attention resting at the top of your head. You can combine other methods of cleansing with your foot-soak e.g.: keeping ice on your liver and/or listening to music or saying Bija mantras. At the end of your foot-soak, raise your Kundalini and give yourself a Bandhan once more. You will then need to rinse your feet over the bucket, dry them off with a towel, and simply throw the foot-soak water down the toilet.' } },
      { type: :paragraph, data: { text: 'Note: Doing a foot-soak in a lake, river, or in the ocean can be even more effective because of the additional soothing and cleansing effect of being outdoors and in the nature (in this case no salt is added, because the qualities of Mother Earth are present already).' } },
      { type: :header, data: { text: 'Why does it work?' } },
      { type: :paragraph, data: { text: 'A lot of nerves end in our feet and soaking them in salt water can help soothe those nerves, relax our muscles and improve circulation.' } },
      { type: :paragraph, data: { text: 'Apart from the rewarding physical benefits, the salt water foot-soak quickly and efficiently clears out energetic blockages in our subtle system, especially those linked to the first three Chakras. How so? Water is the element of the Nabhi Chakra, based at the solar plexus. While perhaps a seemingly simple fact, water has a powerful capacity to cleanse and soothe us. Salt represents the earth element, which is related to the first center, the Mooladhara, located at the base of our spine or the pelvic plexus. The earth element also has the power to absorb and restore us, which is often why we might suddenly feel more at ease and relaxed when sitting in nature. The combination of salt and water thus has an immense power to absorb and revitalize us no matter what state we are in.' } },
    ]),
    published: true,
    published_at: DateTime.now,
  }))

  treatments.push(treatment)

  puts "Created Treatment - #{atts[:name]}"
end

# ===== CREATE SUBTLE SYSTEM NODES ===== #
{
  chakra_1: 'Mooladhara',
  chakra_2: 'Swadhistan',
  chakra_3: 'Nabhi',
  chakra_3b: 'Void',
  chakra_4: 'Anahat',
  chakra_5: 'Vishuddhi',
  chakra_6: 'Agnya',
  chakra_7: 'Sahastrara',
}.each do |role, name|
  subtle_system_node = SubtleSystemNode.find_or_initialize_by(role: role)
  subtle_system_node.update!({
    role: role,
    name: "#{name} Chakra",
    excerpt: sentences(1),
    published_at: DateTime.now,
  })

  if %i[chakra_3b chakra_6 chakra_7].include? role
    first_blocks = [
      {
        type: :image,
        data: {
          items: [{ image: content_attachment("subtle_system_nodes/#{role.to_s.dasherize.downcase}.png", subtle_system_node) }],
          callout: :left,
        },
      }, {
        type: :paragraph,
        data: { text: sentences(5) },
      }
    ]
  else
    first_blocks = [
      {
        type: :structured,
        data: {
          format: :columns,
          items: [
            {
              image: content_attachment("subtle_system_nodes/#{role.to_s.dasherize.downcase}-small.png", subtle_system_node),
              title: 'Left Aspect',
              text: '<p>The left Mooladhara is the first center through which our Kundalini must pass when it is first awakened. It is concerned with our sense of chastity and pure desire to grow spiritually. Sex has its place in human life as a physical expression of love, and through this, birth and creation continue their course.</p><p>However, it is another thing to allow sex to dominate our lives, desires, and attention, thus completely bringing us out of balance. By clearing this center we can develop a sense of rightful conduct, hugely improving our quality of attention, and fostering a pure desire to grow spiritually.</p>',
            },
            {
              image: content_attachment("subtle_system_nodes/#{role.to_s.dasherize.downcase}.png", subtle_system_node),
              title: 'Central Aspect',
              text: '<p>The fundamental quality of the central Mooladhara chakra is innocence, or action without motive or desire for gross personal gain, as witnessed in babies and young children. With this innocence comes an innate wisdom which, if left undisturbed, develops into a balanced set of priorities in an adult.</p><p>Thus, when this center is clear and healthy, we can naturally sense what is that right path for us, removing the need to analyse or question our decisions and allowing us to enjoy freely. By awakening the qualities of the central Mooladhara, we can learn again to become more innocent beings, to bring joy to those around us, and to establish the discrimination to make wise decisions.</p>',
            },
            {
              image: content_attachment("subtle_system_nodes/#{role.to_s.dasherize.downcase}-small.png", subtle_system_node),
              title: 'Right Aspect',
              text: '<p>The right aspect of our Mooladhara has to do with our sense of dynamism and discipline. As the left aspect represents our sense of chastity and can go out of balance when in an indulgent extreme, the same will work against the right Mooladhara in a person who is obsessively strict, fanatic, and over-disciplined in their life.</p><p>A person who is living a forcibly disciplined life with very little joy or spontaneity will often have an imbalance in the right Mooladhara. This chakra can be brought back into balance by allowing for spontaneous joy to take over, which can also be seen as “innocence in action,” making our actions dynamic and effortless.</p>',
            },
          ],
        },
      },
    ]
  end

  subtle_system_node.update!(content: content(first_blocks + [
    {
      type: :textbox,
      data: {
        image: content_attachment('subtle_system_nodes/background.jpg', subtle_system_node),
        title: "How to open the #{name}",
        text: chakra_in_life_content,
        alignment: :center,
        invert: true,
        decorations: {
          gradient: { alignment: :right, color: :orange },
          sidetext: 'In Life',
        },
      },
    },
    {
      type: :catalog,
      data: {
        type: :treatments,
        items: treatments.sample(4).map { |treatment|
          { id: treatment.id, name: treatment.name }
        },
        decorations: { sidetext: 'Cleansing Techniques' },
      },
    },
    {
      type: :video,
      data: {
        items: [vimeo_attachment],
        decorations: {
          sidetext: 'Shri Mataji\'s Words',
          gradient: { alignment: :left, color: :orange },
        },
      },
    },
    {
      type: :textbox,
      data: {
        image: content_attachment('subtle_system_nodes/ancient-wisdom.jpg', subtle_system_node),
        title: 'The Eternal Child',
        text: '<p>When seeking to express the qualities of the Mooladhara chakra, one can study the archetype of the Hindu deity, Shri Ganesha. He is said to be the primordial child, completely pure and innocent, formed from the earth by the Goddess Parvati. His elephant head represents the innate wisdom that he imbibes, and the story of how he gained it demonstrates his complete dedication to his mother.</p><p>One day, the Goddess Parvati was taking a bath and asked Shri Ganesha to guard the door, and to let no one enter under any circumstance. Anyone who tried to approach the door to call on Goddess Parvati, Shri Ganesha swiftly sent away. However after some time, her husband Shri Shiva arrived and asked to enter. Shri Ganesha, in total innocence and devotion to his mother’s instructions, repeatedly refused and would not step aside. In a furious rage, Shri Shiva cut off the head of the child, not knowing that it was his own son.</p><p>When Shri Parvati came out and saw her dead son, she was struck by grief. Upon learning his mistake, Shri Shiva asked his soldiers to bring him the head of the first beast they find, which happened to be an elephant. Shri Shiva attached the elephant head to the body of the boy and gave him life again. From that point onward, Shri Ganesha became revered for his unwavering devotion and grounded inner strength.<p><p>In Hinduism, Shri Ganesha is venerated as the remover of obstacles, a symbol of pure innocence, intelligence and wisdom, and is worshipped at the start of any endeavor or ceremony. Although this story may seem abstract, we can take some value from the moral. Our inner awakening takes place when we are devoted to our innate motherly energy, the Kundalini. This is why the Mooladhara chakra is the first center on our central nervous system, placed below the sacrum bone where the Kundalini lies dormant. When we invoke our own sense of innocence and show our complete faith in our Kundalini, the same way a child does to their mother, she rises in us and nourishes us within.</p>',
        alignment: :right,
        asWisdom: true,
        decorations: { sidetext: 'Ancient Knowledge' },
      },
    },
  ]))
end

{
  channel_right: 'Right Channel',
  channel_left: 'Left Channel',
  channel_center: 'Central Channel',
  kundalini: 'Kundalini',
}.each do |role, name|
  subtle_system_node = SubtleSystemNode.find_or_initialize_by(role: role)
  subtle_system_node.update!({
    role: role,
    name: name,
    excerpt: sentences(2),
    published_at: DateTime.now,
  })

  subtle_system_node.update!(content: content([
    {
      type: :paragraph,
      data: {
        text: 'Coming soon',
      },
    },
  ]))
end

puts ' -- Finished Subtle System Seeds -- '
# rubocop:enable Layout/IndentArray
