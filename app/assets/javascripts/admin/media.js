
var Media = {
  // These variable will be set on load.
  modal: null,
  list: null,
  uploader: null,
  template: null,
  input: null,
  allow_multiple_selection: null,

  load() {
    console.log('loading Media.js')
    Media.library = $('#media-files-library').modal()

    Media.list = $('#media-files')
    Media.template = $('#media-file-template').remove().attr('id', '')
    Media.init_uploader()

    Media.library.on('click', '.media-image', Media._on_select_media)
    Media.library.on('click', '.positive.button', Media._on_approve_selection)
    Media.library.on('click', '.negative.button', Media._on_cancel_selection)
    $('.ui.media.input > .handle').click(Media._on_select_input)
  },

  init_uploader() {
    let $uploader = $('#uploader')
    let endpoint = $uploader.data('endpoint')
    let csrf_token = $uploader.data('csrf_token')
    let note = $uploader.data('note')

    Media.uploader = Uppy.Core({
      //debug: true,
      autoProceed: false,
      restrictions: {
        //maxFileSize: 10000000,
        allowedFileTypes: ['image/*', 'video/*']
      }
    }).use(Uppy.Dashboard, {
      trigger: '#upload',
      showProgressDetails: true,
      closeAfterFinish: true,
      note: note,
      height: 470,
      metaFields: [
        { id: 'name', name: 'Name', placeholder: 'file name' },
        //{ id: 'caption', name: 'Caption', placeholder: 'describe what the image is about' },
      ],
    })
    .use(Uppy.Webcam, { target: Uppy.Dashboard })
    .use(Uppy.XHRUpload, {
      fieldName: 'file',
      headers: {
        'X-CSRF-Token': csrf_token,
      },
      endpoint: endpoint,
    })
    //.use(Uppy.Tus, { endpoint: 'https://master.tus.io/files/' })
    .on('upload-success', (file, media_file) => {
      let $media = Media.template.clone()
      console.log('uploaded', file, 'with', media_file)
      $media.addClass('media-type-'+media_file.category)
      $media.data('value', media_file.id)
      $media.find('.media-image').attr('href', file.preview)
      $media.find('.media-link').attr('href', file.preview)
      $media.find('.media-name').text(file.meta.name)

      if (media_file.category == 'image') {
        $media.find('.media-image').css('background-image', 'url('+file.preview+')')
      }

      Media.list.prepend($media)
    })
  },

  _on_select_input(event) {
    console.log('on select input')
    let $input = $(event.currentTarget).parent()
    Media.input = $input
    Media.allow_multiple_selection = $input.data('multiple') == true
    Media.list.removeClass('media-filter-'+Media.type)
    Media.type = $input.data('type')
    Media.list.addClass('media-filter-'+Media.type)

    if (Media.library.hasClass('uninitialized')) {
      $.get(Media.library.data('index'), (response) => {
        eval(response)
        Media.library.removeClass('uninitialized')
        Media.filter_for_input($input)
      })

      Media.list.children().hide()
    } else {
      Media.filter_for_input($input)
    }

    Media.library.find('.header-text').text($input.find('input[type=text]').attr('placeholder'))
    Media.library.modal('show')
  },

  filter_for_input($input) {
    Media.list.find('.active.media').removeClass('active')

    $input.children('input[type=hidden]').each((index, element) => {
      if (element.value) {
        let $media = Media.list.find('.media[data-value='+element.value+']').addClass('active')
        if (index == 0 && $media.length > 0) {
          Media.library.find('.positive.button').removeClass('disabled')
          $media[0].scrollIntoView()
        }
      }
    })
  },

  _on_select_media(event) {
    let $media = $(event.currentTarget).closest('.media')
    let active = $media.toggleClass('active')

    if (!Media.allow_multiple_selection) {
      Media.list.find('.active.media').removeClass('active')
      $media.toggleClass('active', active)
    }

    if (active) {
      Media.library.find('.positive.button').removeClass('disabled')
    } else if (Media.list.find('.active.media').length == 0) {
      Media.library.find('.positive.button').addClass('disabled')
    }

    return false
  },

  _on_approve_selection() {
    let $selection = Media.list.find('.active.media').removeClass('active')

    if (Media.allow_multiple_selection) {
      let $fields = Media.input.children('input[type=hidden]').remove()

      $selection.each((_, media) => {
        $fields.first().clone().val(media.dataset.value).appendTo(Media.input)
      })

      Media.input.find('input[type=text]').val($selection.length + ' files') // TODO: Translate this, and make it use proper pluralization
    } else {
      let href = $selection.find('.media-link').attr('href')
      Media.input.find('.ui.image').attr('href', href)
      Media.input.find('img').attr('src', href)
      Media.input.find('a.ui.button').attr('href', href).show()
      Media.input.find('input[type=text]').val($selection.find('.media-name').text())
      Media.input.children('input[type=hidden]').val($selection.data('value'))
    }

    Media._on_cancel_selection()
  },

  _on_cancel_selection() {
    Media.input = null
    Media.allow_multiple_selection = null
    Media.library.modal('hide')
  },
}

$(document).on('turbolinks:load', () => { Media.load() })
