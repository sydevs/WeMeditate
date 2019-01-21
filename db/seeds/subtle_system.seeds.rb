
file_root = Rails.root.join('db/seeds/files')
puts ' -- Start Subtle System Seeds -- '

def attachment path, name, type, parent
  media_file = parent.media_files.find_or_initialize_by(name: name)
  media_file.update!({ name: name, category: type, file: Rails.root.join('db/seeds/files').join(path).open })
  media_file.id
end

# ===== CREATE TREATMENTS ===== #
treatments = []

[
  'Footsoak', 'Ice Pack', 'Candle Treatment', 'Forgiveness', 'Bija Mantras', 'Releasting Guilt'
].each_with_index do |name, index|
  treatment = Treatment.find_or_initialize_by(name: name)
  treatment.update!({
    name: name,
    order: index,
    excerpt: 'Suspendisse facilisis semper tempor. Phasellus eu sagittis justo. Cras felis ex, efficitur quis nisl eu, aliquam varius odio. Nam placerat nisl vitae suscipit bibendum. Etiam hendrerit odio lobortis massa molestie auctor sed id augue. Mauris in vestibulum sem. Integer fringilla nisl eget ipsum vestibulum ullamcorper quis et leo. Donec vestibulum quam a metus blandit, sit amet lacinia risus tincidunt.',
    content: '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vehicula accumsan urna, nec euismod lorem volutpat ut. Nullam iaculis, ligula eu fringilla laoreet, risus lacus sollicitudin libero, id laoreet turpis libero nec elit. Nullam sit amet tellus non elit tristique consectetur quis id purus. Cras rutrum rhoncus maximus. Vestibulum eleifend nunc sapien, at mollis tortor sagittis sed. Aenean hendrerit feugiat eros, a tempor lectus euismod nec. Suspendisse semper congue odio, laoreet euismod arcu ornare non. Nunc dictum faucibus urna ac mollis. Donec luctus sit amet velit at vulputate. Vestibulum interdum placerat metus, eget pellentesque dolor faucibus ac. Sed egestas nisl odio. Proin nisi mauris, sodales in lorem a, euismod mattis eros.</p><p>Vestibulum gravida luctus nibh, in cursus lorem consectetur vitae. Vivamus eget facilisis tortor. Integer ut congue tortor. Proin auctor enim ac tortor suscipit blandit. Fusce mi justo, fringilla non dolor at, accumsan consectetur elit. Donec suscipit elit sed eleifend dictum. Praesent eleifend sem et hendrerit pulvinar. Mauris mattis euismod eros, ut lacinia felis suscipit sit amet. Vivamus semper molestie vestibulum. Nulla bibendum fringilla dapibus. Integer maximus mauris quis eleifend ullamcorper. Nullam vel ligula mattis, consequat odio in, mollis lorem. Donec rhoncus sem sit amet quam tempor, ultricies ultricies lectus maximus. Nullam sagittis erat a feugiat sodales. Mauris euismod lorem ligula, sit amet tincidunt lorem pellentesque quis. Praesent quis ante malesuada, faucibus nunc nec, tincidunt diam.</p>',
    thumbnail: file_root.join("treatments/#{index + 2}.jpg").open,
    video: file_root.join('general/video.mp4').open,
  })

  treatments.push(treatment)

  puts "Created Treatment - #{name}"
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
    name: name,
    excerpt: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Alias quam, corporis quia exercitationem aspernatur numquam?',
  })

  overview_image_id = attachment("subtle_system_nodes/#{role.to_s.dasherize}.png", 'Chakra Overview.png', :image, subtle_system_node)

  [{
    content_type: :text,
    format: :columns,
    label: 'Chakra Overview',
    extra: {
      items: [{
        title: 'Left Aspect',
        text: '<p>The left Nabhi is responsible for the ability to concentrate attention, and therefore stay in thoughtlessness and meditate. Therefore, this is one of the most important chakras in our delicate system.</p><p>She is also responsible for material well-being and a sense of inner dignity.</p><p>On the physical plane, the right Nabi corresponds to the liver. It comes out of balance, or "overheats" when we think too much and do not give ourselves a break.</p>',
        image_id: role != :chakra_6 ? overview_image_id : attachment('subtle_system_nodes/chakra-6-left.png', 'Chakra Overview Left.png', :image, subtle_system_node),
      }, {
        title: 'Central Aspect',
        text: '<p>The central Nabhi is responsible for the ability to concentrate attention, and therefore stay in thoughtlessness and meditate. Therefore, this is one of the most important chakras in our delicate system.</p><p>She is also responsible for material well-being and a sense of inner dignity.</p><p>On the physical plane, the right Nabi corresponds to the liver. It comes out of balance, or "overheats" when we think too much and do not give ourselves a break.</p>',
        image_id: overview_image_id,
      }, {
        title: 'Right Aspect',
        text: '<p>The right Nabhi is responsible for the ability to concentrate attention, and therefore stay in thoughtlessness and meditate. Therefore, this is one of the most important chakras in our delicate system.</p><p>She is also responsible for material well-being and a sense of inner dignity.</p><p>On the physical plane, the right Nabi corresponds to the liver. It comes out of balance, or "overheats" when we think too much and do not give ourselves a break.</p>',
        image_id: role != :chakra_6 ? overview_image_id : attachment('subtle_system_nodes/chakra-6-right.png', 'Chakra Overview Right.png', :image, subtle_system_node),
      }]
    }
  }, {
    content_type: :text,
    format: :box_over_image,
    label: 'In Daily Life',
    title: "How to open #{name}?",
    text: '<p>It is important to try to show Nabhi quality in your life - it will automatically purify and make this chakra stronger, and meditations will become deeper. If we are calm and generous, we have order in affairs and at home, Nabi will be in good condition. On the contrary, if a person is dishonest with money, materialistic, or often fussing about small things, then Nabhi will be in imbalance.</p><p>Quality Nabi: peace, pure attention, generosity, the quality of an ideal housewife, attention to spiritual growth. What blocks: anxiety, greed, stress, materialism, fatty and heavy food.</p><p>To demonstrate the qualities of Nabis and balance this chakra can help simple methods of cleaning this chakra.</p>',
    extra: {
      image_id: attachment('subtle_system_nodes/background.jpg', 'Daily Life.jpg', :image, subtle_system_node),
      decorations: {
        enabled: ['sidetext', 'gradient'],
        options: {
          sidetext: ['top-left'],
          gradient: ['right', 'orange'],
        }
      }
    },
  }, {
    content_type: :special,
    format: :treatments,
    extra: {
      treatment_ids: treatments.sample(4).map(&:id),
      decorations: {
        enabled: ['sidetext'],
        options: {
          sidetext: ['top-left'],
        },
        sidetext: 'Methods of Cleaning',
      },
    },
  }, {
    content_type: :video,
    format: :single,
    title: 'The first method of meditation',
    extra: {
      image_id: attachment('subtle_system_nodes/video.jpg', 'Video.jpg', :image, subtle_system_node),
      video_id: attachment('general/video.mp4', 'Video.mp4', :video, subtle_system_node),
      decorations: {
        enabled: ['sidetext', 'gradient'],
        options: {
          sidetext: ['top-right'],
          gradient: ['left', 'orange'],
        },
        sidetext: 'Video',
      },
    },
  }, {
    content_type: :text,
    format: :ancient_wisdom,
    text: '<p><strong>Header 1</strong></p><p>Phasellus tempor sem ut libero consectetur feugiat. Nulla ultrices ut felis id consequat. Nam semper vel augue sit amet semper. Donec ut feugiat purus. Duis facilisis, tellus vel pretium auctor, mauris odio ultricies ligula, eu scelerisque lorem lectus in erat. Duis quam orci, tristique ut iaculis ac, lacinia sit amet sem. Integer vitae lacinia enim, ut egestas eros. Proin feugiat id tortor a pulvinar. Nunc at augue iaculis, facilisis ex eget, vulputate dui.</p><p><strong>Header 2</strong></p><p>Nullam at leo et lectus tristique ullamcorper. Morbi rhoncus dolor nec ornare dapibus. In lectus est, facilisis in sagittis eget, rutrum quis neque. Nam vitae ullamcorper lectus, et auctor justo. Mauris fringilla orci est, non facilisis urna euismod at. Cras lobortis tellus purus, id cursus purus rhoncus at. Donec scelerisque consectetur lacus, vitae ultricies lectus cursus quis. Ut quam est, dictum eu dapibus vitae, rhoncus eu nisi. Vivamus enim erat, sagittis a bibendum nec, varius non nulla. Sed suscipit quam vel ex suscipit, sollicitudin rutrum massa cursus. Phasellus malesuada mattis risus sit amet eleifend.</p>',
    extra: {
      decorations: {
        enabled: ['gradient'],
        options: {
          gradient: ['left', 'orange'],
        },
      },
    }
  }].each_with_index do |atts, index|
    section = subtle_system_node.sections.find_or_initialize_by(order: index)
    atts[:order] = index
    section.update!(atts)
  end
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
    excerpt: 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Alias quam, corporis quia exercitationem aspernatur numquam?',
  })

  [{
    content_type: :text,
    format: :just_text,
    text: 'Coming soon',
  }].each_with_index do |atts, index|
    section = subtle_system_node.sections.find_or_initialize_by(order: index)
    atts[:order] = index
    section.update!(atts)
  end
end

puts ' -- Finished Subtle System Seeds -- '
