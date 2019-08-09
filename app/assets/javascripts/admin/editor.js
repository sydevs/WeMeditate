
const Editor = {
  pending_uploads: 0,
  upload_endpoint: null,
  triangle_path: null,

  instance: null,
  upload_loader: null,
  form: null,
  input: null,

  options: {
    holder: 'content-editor',
    tools: {
      header: HeaderTool,
      list: ListTool,
      quote: QuoteTool,
      action: ActionTool,
      image: ImageTool,
      video: VideoTool,
      form: FormTool,
      textbox: TextboxTool,
      catalog: CatalogTool,
      structured: StructuredTool,
    },
    autofocus: true,
  },

  load() {
    console.log('loading Editor.js')
    let editor = document.getElementById('content-editor')
    let form = document.getElementById('editor-form')

    if (form && editor) {
      SplashEditor.load()

      form.onsubmit = Editor._onSubmit
      Editor.triangle_path = editor.dataset.triangle
      Editor.upload_endpoint = editor.dataset.upload
      Editor.upload_loader = document.getElementById('upload-loader')
      Editor.form = form
      Editor.input = form.querySelector('#content-input')

      if (editor.dataset.content) {
        Editor.options.data = Editor.processDataForLoad(editor.dataset.content)
      }

      Editor.instance = new EditorJS(Editor.options)
    }
  },

  upload(file, callback) {
    Editor.adjustPendingUploads(+1)

    console.log('uploading', file.name, 'to', Editor.upload_endpoint)
    const data = new FormData()
    data.append('file', file)

    $.ajax({
      url: Editor.upload_endpoint,
      type: 'POST',
      processData: false,
      contentType: false,
      dataType: 'json',
      data: data,
      success: function(result) {
        Editor.adjustPendingUploads(-1)
        callback(result)
      },
    })
  },

  retrieveVimeoVideo(vimeo_id, callback) {
    Editor.adjustPendingUploads(+1)

    $.ajax({
      url: `/en/vimeo_data?vimeo_id=${vimeo_id}`,
      type: 'GET',
      dataType: 'json',
      success: function(result) {
        Editor.adjustPendingUploads(-1)
        callback(result)
      },
    })
  },

  adjustPendingUploads(adjustment) {
    Editor.pending_uploads += adjustment
    if (Editor.pending_uploads > 0) {
      Editor.upload_loader.querySelector('span').innerText = translate['waiting_for_upload'].replace('%{count}', Editor.pending_uploads)
      Editor.form.classList.add('disabled')
      Editor.form.setAttribute('disabled', true)
      $(Editor.form).find('button[type=submit]').attr('disabled', true)
    } else {
      Editor.form.classList.remove('disabled')
      Editor.form.removeAttribute('disabled')
      $(Editor.form).find('button[type=submit]').attr('disabled', false)
    }

    $(Editor.upload_loader).toggle(Editor.pending_uploads > 0)
  },

  processDataForSave(data) {
    if (SplashEditor.isActive) {
      data.blocks = data.blocks.unshift(SplashEditor.getData())
    }

    // Consolidate the media file references
    const media_files = []
    for (let index = 0; index < data.length; index++) {
      const block = outputData[index]
      if (block.data.media_files) media_files = media_files.concat(block.data.media_files)
      delete block.data.media_files
    }

    data.media_files = media_files
    return JSON.stringify(data)
  },

  processDataForLoad(data) {
    data = JSON.parse(data)

    if (data.blocks && data.blocks.length > 0 && data.blocks[0].type === 'splash') {
      const splashData = data.blocks.shift() // Remove the splash data before sending it to editorjs
      SplashEditor.setData(splashData)
    }

    return data
  },

  _onSubmit(event) {
    if (Editor.pending_uploads > 0) {
      event.preventDefault()
      return false
    }

    Editor.instance.save().then(outputData => {
      console.log('Article data: ', outputData)
      Editor.input.value = Editor.processDataForSave(outputData)
    }).catch((error) => {
      console.error('Editor saving failed: ', error)
      event.preventDefault()
    })
  },

  getCurrentBlock() {
    return this.instance.blocks.getBlockByIndex(this.instance.blocks.getCurrentBlockIndex())
  }
}

$(document).on('turbolinks:load', () => { Editor.load() })
