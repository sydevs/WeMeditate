/* global dataLayer */
/* exported Util */

const Util = {

  pickRandom: function(array) {
    return array[Math.floor(Math.random() * array.length)]
  },

  sendAnalyticsEvent(name, attributes) {
    attributes.event = name
    console.log('Analytics Event', attributes) // eslint-disable-line no-console
    if (typeof dataLayer !== 'undefined') dataLayer.push(attributes)
  },

  share(shareData) {
    navigator.share(shareData)
        .then(() => console.log('Successful share'))    // eslint-disable-line no-console
        .catch((error) => console.error('Error sharing...', error))   // eslint-disable-line no-console
  },

  shareFallback(shareData, shareBtns) {
    for (let i = 0; i < shareBtns.length; i++) {
      const button = shareBtns[i]
      let href = button.href
      href = href.replace('{url}', encodeURIComponent(shareData.url))
      href = href.replace('{title}', encodeURIComponent(shareData.title))
      href = href.replace('{text}', encodeURIComponent(shareData.text))
      href = href.replace('{provider}', encodeURIComponent(window.location.hostname))
      button.href = href
    }
  }
  
}
