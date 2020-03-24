/* global */
/* exported CountdownTimer */

class CountdownTimer {

  constructor(element) {
    this.container = element
    this.targetDate = Date.parse(element.dataset.time)
    this.days = element.querySelector('.js-countdown-days')
    this.hours = element.querySelector('.js-countdown-hours')
    this.minutes = element.querySelector('.js-countdown-minutes')
    this.seconds = element.querySelector('.js-countdown-seconds')
    
    this.interval = setInterval(() => this.update(), 1000)
  }

  update() {
    const now = new Date().getTime()
    const t = this.targetDate - now
    const days = Math.floor(t / (1000 * 60 * 60 * 24))
    const hours = Math.floor((t % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    const minutes = Math.floor((t % (1000 * 60 * 60)) / (1000 * 60))
    const seconds = Math.floor((t % (1000 * 60)) / 1000)

    this.days.innerText = days < 10 ? `0${days}` : days
    this.hours.innerText = hours < 10 ? `0${hours}` : hours
    this.minutes.innerText = minutes < 10 ? `0${minutes}` : minutes  
    this.seconds.innerText = seconds < 10 ? `0${seconds}` : seconds
    
    if (days == 0 && this.days.dataset.value != 0) {
      this.days.setAttribute('data-value', 0)
    }

    if (t < 0) {
      window.location.reload()
      clearInterval(this.interval)
    }
  }

}
