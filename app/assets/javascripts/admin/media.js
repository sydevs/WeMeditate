
var Media = {
  // These variable will be set on load.
  uploader: null,

  load: function() {
    console.log('loading Media.js')
    Media.initialize_uploader()
  },

  initialize_uploader: function() {
    let element = document.getElementById("uploader")

    if (element) {
      Media.uploader = new qq.FineUploader({
        element: element,
        //autoUpload: false,
        request: {
          endpoint: element.dataset.endpoint,
          params: {
            authenticity_token: element.dataset.authenticityToken
          }
        },
        deleteFile: {
          enabled: true,
          endpoint: element.dataset.endpoint,
          params: {
            authenticity_token: element.dataset.authenticityToken
          }
        },
        validation: {
          acceptFiles: element.dataset.types,
        },
        callbacks: {
          onComplete: Media._on_upload_complete,
          onDeleteComplete: Media._on_upload_delete,
        },
      })

      Media.uploader.addInitialFiles(JSON.parse(element.dataset.files))
    }
  },

  get_option_html: function(uuid, name, url) {
    return '<div class="item file-'+uuid+'" data-value="'+uuid+'">'
        + '<span class="description">'
          + '<a href="'+url+'" target="_blank">'
            + 'View'
            + '<i class="external square alternate icon"></i>'
          + '</a>'
        + '</span>'
        + '<span class="text">'+name+'</span>'
      + '</div>'
  },

  _on_upload_complete: function(id, name, response, xhr) {
    let data = JSON.parse(xhr.response)
    $('.attachment.selection > .menu').append(Media.get_option_html(data['uuid'], name, data['src']))
  },

  _on_upload_delete: function(id, xhr, isError) {
    let uuid = JSON.parse(xhr.response)['uuid']
    let $dropdown = $('.attachment.selection.dropdown')
    $dropdown.find('.item.file-'+uuid).remove()

    $dropdown.each(function() {
      if ($(this).dropdown('get value') == uuid) {
        $(this).dropdown('clear')
      }
    })
  },
}

$(document).on('turbolinks:load', function() { Media.load() })
