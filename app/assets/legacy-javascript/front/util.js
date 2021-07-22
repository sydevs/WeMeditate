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
  }
  
}
