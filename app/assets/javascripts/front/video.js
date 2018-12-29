/** VIDEO
 * This file simply initializes inline video players, which are not handled in other JavaScript files.
 *
 * TODO: Evaluate whether this file is actually useful, or if this functionality should just be included elsewhere.
 */

const Video = {
  // Called when turbolinks loads the page
  load() {
    new Plyr('video.inline-player')
  }
}

$(document).on('turbolinks:load', () => { Video.load() })
