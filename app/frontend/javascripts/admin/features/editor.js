import EditorJS from '@editorjs/editorjs'
import { afterPendingUploads, hasPendingUploads } from './uploader'
import { debounce } from '../util'

import ParagraphTool from '../editor-blocks/paragraph-tool'
import ListTool from '../editor-blocks/list-tool'
import TextboxTool from '../editor-blocks/textbox-tool'
import ActionTool from '../editor-blocks/action-tool'
import MediaTool from '../editor-blocks/media-tool'
import WhitespaceTool from '../editor-blocks/whitespace-tool'
import LayoutTool from '../editor-blocks/layout-tool'
import CatalogTool from '../editor-blocks/catalog-tool'
import LegacyVimeoTool from '../editor-blocks/legacy/vimeo-tool'

import CitationTool from '../editor-inline-tools/citation-tool'

/** Content Editor
 * We use the editorjs (https://editorjs.io) to provide a block-based content editor for our CMS.
 * This is a fairly complex system which uses all the files in the 'cdx-editor' subfolder.
 */

let form, editorInstance, editorInput, contentEditor

const editorParameters = {
  autofocus: true,
  onChange: debounce(() => autoSave()),
  placeholder: 'Let`s write an awesome story!',
  inlineToolbar: ['link', 'bold', 'italic', 'citation'],
  tools: {
    paragraph: {
      class: ParagraphTool,
      inlineToolbar: true,
    },
    list: {
      class: ListTool,
      inlineToolbar: true,
    },
    media: MediaTool,
    action: ActionTool,
    textbox: {
      class: TextboxTool,
      inlineToolbar: true,
    },
    layout: {
      class: LayoutTool,
      inlineToolbar: true,
    },
    catalog: CatalogTool,
    whitespace: WhitespaceTool,
    vimeo: LegacyVimeoTool,
    citation: CitationTool,
  },
  defaultBlock: 'paragraph',
}

export default function load() {
  console.log('loading Editor.js') // eslint-disable-line no-console
  form = document.getElementById('editor-form')

  contentEditor = document.getElementById('content-editor')

  // Only intialize if the content editor actually exists on this page.
  if (!form || !contentEditor) {
    return
  }

  form.onsubmit = onSubmit
  editorInput = form.querySelector('#content-input')

  if (contentEditor.dataset.loadAutosave) {
    let localStorageData = localStorage.getItem(contentEditor.dataset.autosaveKey)
    editorParameters.data = processDataForLoad(localStorageData)
  } else if (contentEditor.dataset.content) {
    editorParameters.data = processDataForLoad(contentEditor.dataset.content)
  }

  editorParameters.holder = contentEditor
  editorInstance = new EditorJS(editorParameters)

  if (!contentEditor.dataset.loadAutosave) {
    let localStorageData = localStorage.getItem(contentEditor.dataset.autosaveKey)
    if (localStorageData) {
      let autosaver = document.getElementById('autosaver')
      autosaver.style = null
      autosaver.querySelector('em').innerText = localStorage.getItem(contentEditor.dataset.autosaveKey + '.date')
    }
  }
}

// Returns the block which currently has focus in the editor.
export function getCurrentEditorBlock() {
  return editorInstance.blocks.getBlockByIndex(editorInstance.blocks.getCurrentBlockIndex())
}

export function setContent(jsonData) {
  editorInstance.render(jsonData)
}

function onSubmit(event) {
  if (hasPendingUploads()) {
    afterPendingUploads(() => form.submit())
    event.stopPropagation()
    event.preventDefault()
    return false
  } else {
    // Retrieve the editor data, then store it in the input before the editor form is submitted.
    editorInstance.save().then(outputData => {
      console.log('Article data: ', outputData) // eslint-disable-line no-console
      editorInput.value = processDataForSave(outputData)
      localStorage.removeItem(contentEditor.dataset.autosaveKey)
      localStorage.removeItem(contentEditor.dataset.autosaveKey + '.date')
    }).catch((error) => {
      console.error('Editor saving failed: ', error) // eslint-disable-line no-console
      event.preventDefault()
    })
  }
}

// Do any extra processing on the JSON data which is given to us by the editor
function processDataForSave(data) {
  // Consolidate all the media file ids for easy reference
  let mediaFiles = []
  for (let index = 0; index < data.length; index++) {
    const block = data[index]
    if (block.data.mediaFiles) mediaFiles = mediaFiles.concat(block.data.mediaFiles)
    delete block.data.mediaFiles
  }

  data.markupVersion = 3
  data.mediaFiles = mediaFiles
  return JSON.stringify(data)
}

// Do any extra processing on the JSON data before we load it into the editor
function processDataForLoad(data) {
  return JSON.parse(data)
}

async function autoSave() {
  // Retrieve the editor data, then store it in the input before the editor form is submitted.
  editorInstance.save().then(outputData => {
    console.log('Autosave: ', outputData) // eslint-disable-line no-console
    let data = processDataForSave(outputData)
    localStorage.setItem(contentEditor.dataset.autosaveKey, data)
    localStorage.setItem(contentEditor.dataset.autosaveKey + '.date', new Date().toLocaleDateString('en-GB', { year: 'numeric', month: 'short', day: 'numeric' }))
    editorInput.value = data
  }).catch((error) => {
    console.error('Editor saving failed: ', error) // eslint-disable-line no-console
  })
}
