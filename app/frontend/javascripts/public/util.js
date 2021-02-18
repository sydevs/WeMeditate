
export function pickRandom(array) {
  return array[Math.floor(Math.random() * array.length)]
}

export function sendAnalyticsEvent(name, attributes) {
  attributes.event = name
  console.log('Analytics Event', attributes) // eslint-disable-line no-console
  if (typeof window.dataLayer !== 'undefined') window.dataLayer.push(attributes)
}
