import $ from 'jquery'

let uploads = {}
let pendingUploads = 0
let failedUploads = []
let uploadEndpoint
let loaderElement
let modal

export default function load() {
  console.log('loading Uploader.js') // eslint-disable-line no-console

  const uploaderContainer = document.getElementById('uploader')
  if (uploaderContainer) {
    uploadEndpoint = uploaderContainer.dataset.endpoint
    loaderElement = document.getElementById('uploader-loader')
    modal = document.getElementById('uploader-modal')
  }
}

export function hasPendingUploads() {
  return pendingUploads > 0
}

export function afterPendingUploads(onCompletion) {
  $(modal).modal({ onApprove: () => onCompletion })
}

// This sends a file to our server's upload endpoint
export function uploadFile(file, success, failure) {
  console.log('upload file')
  adjustPendingUploads(+1)

  const data = new FormData()
  data.append('file', file)

  $.ajax({
    url: uploadEndpoint,
    type: 'POST',
    processData: false,
    contentType: false,
    dataType: 'json',
    data: data,
    success: function(result) {
      adjustPendingUploads(-1)
      success(result)
    },
    error: function(result) {
      failedUploads.push(result)
      adjustPendingUploads(-1)
      failure(result)
    },
  })
}

function adjustPendingUploads(adjustment) {
  pendingUploads += adjustment

  if (pendingUploads > 0) {
    loaderElement.querySelector('span').innerText = window.translate.waiting_for_upload.replace('%{count}', pendingUploads)
  }

  $(loaderElement).toggle(pendingUploads > 0)
}
