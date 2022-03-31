
export function pickRandom(array) {
  return array[Math.floor(Math.random() * array.length)]
}

export function sendAnalyticsEvent(name, attributes) {
  attributes.event = name
  console.log('Analytics Event', attributes) // eslint-disable-line no-console
  if (typeof window.dataLayer !== 'undefined') window.dataLayer.push(attributes)
}

export function getOrientation() {
  return window.innerWidth > window.innerHeight ? 'horizontal' : 'vertical'
}

export function isMobileDevice() {
  return navigator.userAgent.match(/Android/i)
      || navigator.userAgent.match(/webOS/i)
      || navigator.userAgent.match(/iPhone/i)
      || navigator.userAgent.match(/iPad/i)
      || navigator.userAgent.match(/iPod/i)
      || navigator.userAgent.match(/BlackBerry/i)
      || navigator.userAgent.match(/Windows Phone/i)
}

export function isTouchDevice() {
  return ('ontouchstart' in window) || (navigator.MaxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0)
}

export function shuffleArray(orderedArray) {
  let array = [...orderedArray]
  for (let i = array.length - 1; i > 0; i--) {
    let j = Math.floor(Math.random() * (i + 1))
    let temp = array[i]
    array[i] = array[j]
    array[j] = temp
  }

  return array
}

export function show(element, type = 'block') {
  element.style.display = type
}

export function hide(element) {
  element.style.display = 'none'
}

export function toggle(element, visible, type = 'block') {
  element.style.display = visible ? type : 'none'
}

export function hasCommonItems(array1, array2) {
  for (let i = 0; i < array1.length; i++) {
    for (let j = 0; j < array2.length; j++) {
      if (array1[i] == array2[j]) {
        return true
      }
    }
  }

  return false
}
