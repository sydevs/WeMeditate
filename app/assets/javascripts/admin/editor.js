/** Content Editor
 * We use the codex editor (https://editorjs.io) to provide a block-based content editor for our CMS.
 * This is a fairly complex system which uses all the files in the 'cdx-editor' subfolder.
 */

const Editor = {
  pendingUploads: 0,
  uploadEndpoint: null,
  triangle_path: null,

  instance: null,
  uploadLoader: null,
  form: null,
  input: null,

  // Configuration options for the cdx editor
  options: {
    holder: 'content-editor',
    tools: {
      paragraph: ParagraphTool,
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
    initialBlock: 'paragraph',
    autofocus: true,
  },

  load() {
    console.log('loading Editor.js')
    Editor.form = document.getElementById('editor-form')
    Editor.uploadLoader = document.getElementById('upload-loader')
    const contentEditor = document.getElementById('content-editor')

    // Only intialize if the content editor actually exists on this page.
    if (Editor.form && contentEditor) {
      SplashEditor.load()

      Editor.form.onsubmit = Editor._onSubmit
      Editor.triangle_path = contentEditor.dataset.triangle
      Editor.uploadEndpoint = contentEditor.dataset.upload
      Editor.input = Editor.form.querySelector('#content-input')

      if (contentEditor.dataset.content) {
        Editor.options.data = Editor.processDataForLoad(contentEditor.dataset.content)
      }

      // Initialize the CodeX Editor (aka EditorJS)
      Editor.instance = new EditorJS(Editor.options)
    }
  },

  // This sends a file to our server's upload endpoint
  upload(file, callback) {
    Editor.adjustPendingUploads(+1)

    const data = new FormData()
    data.append('file', file)

    $.ajax({
      url: Editor.uploadEndpoint,
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

  // Requests vimeo metadata from our server's vimeo data endpoint
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

  // Allows us to disable saving until all uploads have finished.
  adjustPendingUploads(adjustment) {
    Editor.pendingUploads += adjustment
    if (Editor.pendingUploads > 0) {
      Editor.uploadLoader.querySelector('span').innerText = translate['waiting_for_upload'].replace('%{count}', Editor.pendingUploads)
      Editor.form.classList.add('disabled')
      Editor.form.setAttribute('disabled', true)
      $(Editor.form).find('button[type=submit]').attr('disabled', true)
    } else {
      Editor.form.classList.remove('disabled')
      Editor.form.removeAttribute('disabled')
      $(Editor.form).find('button[type=submit]').attr('disabled', false)
    }

    $(Editor.uploadLoader).toggle(Editor.pendingUploads > 0)
  },

  // Do any extra processing on the JSON data which is given to us by the editor
  processDataForSave(data) {
    if (SplashEditor.isActive) {
      // If this page has a splash editor, then we need to add that data to the editor data before it gets saved.
      data.blocks.unshift(SplashEditor.getData())
    }

    // Consolidate all the media file ids for easy reference
    const media_files = []
    for (let index = 0; index < data.length; index++) {
      const block = outputData[index]
      if (block.data.media_files) media_files = media_files.concat(block.data.media_files)
      delete block.data.media_files
    }

    data.media_files = media_files
    return JSON.stringify(data)
  },

  // Do any extra processing on the JSON data before we load it into the editor
  processDataForLoad(data) {
    data = JSON.parse(data)

    if (data.blocks && data.blocks.length > 0 && data.blocks[0].type === 'splash') {
      // Remove the splash data before sending it to editorjs
      const splashData = data.blocks.shift()
      SplashEditor.setData(splashData)
    }

    return data
  },

  _onSubmit(event) {
    // Prevent the editor form from being submitted if we have pending uploads.
    if (Editor.pendingUploads > 0) {
      event.preventDefault()
      return false
    }

    // Retrieve the editor data, then store it in the input before the editor form is submitted.
    Editor.instance.save().then(outputData => {
      console.log('Article data: ', outputData)
      Editor.input.value = Editor.processDataForSave(outputData)
    }).catch((error) => {
      console.error('Editor saving failed: ', error)
      event.preventDefault()
    })
  },

  // Returns the block which currently has focus in the editor.
  getCurrentBlock() {
    return this.instance.blocks.getBlockByIndex(this.instance.blocks.getCurrentBlockIndex())
  }
}

$(document).on('turbolinks:load', () => { Editor.load() })
