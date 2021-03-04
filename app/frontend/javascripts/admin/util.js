/** UTILITY FUNCTIONS
 * This file contains standalone utility functions. Usually these functions have been copied from the internet.
 */

// Generates a string of 16 random characters to be used as a unique identifier.
export function generateId() {
  // Math.random should be unique because of its seeding algorithm.
  // Convert it to base 36 (numbers + letters), and grab the first 16 characters after the decimal.
  return Math.random().toString(36).substr(2, 18)
}

export function make(tagName, classNames = null, attributes = {}, parent = null) {
  let el = document.createElement(tagName)

  if ( Array.isArray(classNames) ) {
    el.classList.add(...classNames)
  } else if ( classNames ) {
    el.classList.add(classNames)
  }

  for (let attrName in attributes) {
    el[attrName] = attributes[attrName]
  }

  if (parent) {
    parent.appendChild(el)
  }

  return el
}