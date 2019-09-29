
class ReadingTime {

  constructor(element) {
    const rawText = document.querySelector('main').innerText
    const duration = readingTime(rawText).approximate
    element.innerText = translate['reading_time'].replace('%minutes%', duration)
  }

}
