import readingTime from 'reading-time'
import { translate } from '../util'

export default class ReadingTime {

  constructor(element) {
    const rawText = document.querySelector('main').innerText
    const duration = Math.round(readingTime(rawText).minutes)
    element.innerText = translate().reading_time.replace('%minutes%', duration)
  }

}
