import $ from 'jquery'
import { make } from '../util'
import { translate, locale } from '../../i18n'

export default class FinderModal {

  constructor(type, callback) {
    this.type = type
    this.modal = make('div', ['ui', 'tiny', 'modal'])
    $(this.modal).modal({ onApprove: () => callback(this.items) })

    make('div', 'header', { innerText: translate(`finder.title.${this.type}`) }, this.modal)
    const modalContent = make('div', ['content', 'finder'], {}, this.modal)
    modalContent.addEventListener('click', event => this._clickHandler(event))

    const searchInputWrapper = make('div', ['ui', 'fluid', 'icon', 'input'], {}, modalContent)
    this.searchInput = make('input', '', {
      placeholder: translate('placeholders.search'),
    }, searchInputWrapper)

    make('i', ['search', 'icon'], {}, searchInputWrapper)
    this.searchInput.addEventListener('keyup', event => this._onSearchChange(event))
    this.searchResultContainer = make('div', ['ui', 'list'], {}, modalContent)
    this.searchSelectionContainer = make('div', ['ui', 'list'], {}, modalContent)

    const modalFooter = make('div', 'actions', {}, this.modal)
    make('div', ['ui', 'cancel', 'button'], { innerText: translate('finder.cancel') }, modalFooter)
    make('div', ['ui', 'green', 'ok', 'button'], { innerHTML: `<i class="check icon"></i> ${translate('finder.select')}` }, modalFooter)
  }

  open(currentSelection = [], allowMultiple = true, category = null) {
    this.allowMultiple = allowMultiple
    this.category = category
    this.searchInput.value = ''
    this.searchResultContainer.innerHTML = ''
    this.searchSelectionContainer.innerHTML = ''
    this.items = currentSelection.slice() // clone array

    if (this.items.length) {
      this.items.forEach(item => {
        this.searchSelectionContainer.appendChild(this.renderItem(item))
      })
    }

    $(this.searchInput).focus()
    $(this.modal).modal('show')
  }

  renderItem(item, selected = true) {
    const container = make('div', 'item', { data: item })
    const state = selected ? 'check' : 'plus'
    const name = item.id ? `${item.name} (${item.id})` : item.name
    make('i', [state, 'circle', 'link', 'icon'], {}, container)
    make('div', 'content', { innerText: name }, container)
    return container
  }

  _clickHandler(event) {
    if (!event.target.classList.contains('link') || !event.target.classList.contains('icon')) {
      return
    }

    const icon = event.target
    const item = icon.parentNode

    if (icon.classList.contains('plus')) {
      // Add the item
      icon.classList.replace('plus', 'check')

      if (this.allowMultiple) {
        this.items.push(item.dataset)
        this.searchSelectionContainer.appendChild(item)
      } else {
        this.items = [item.dataset]
        this.searchSelectionContainer.innerHTML = ''
        this.searchSelectionContainer.appendChild(item)
      }
    } else {
      // Remove the item
      this.items = this.items.filter(i => {
        return i.id != item.dataset.id
      })
      item.remove()
    }
  }

  _onSearchChange(event) {
    if (this.timer) clearTimeout(this.timer)
    if (event.target.value.length < 3) {
      this.searchInput.parentNode.classList.remove('loading')
      return
    }

    this.searchInput.parentNode.classList.add('loading')
    this.timer = setTimeout(() => {
      let args = {
        category: this.category,
        query: event.target.value,
        exclude: this.items.map(item => item.id),
        callback: data => this._onSearchResult(data),
      }

      switch (this.type) {
      case 'wemeditate':
        searchWeMeditate(args)
        break
      case 'jwplayer':
        searchJWPlayer(args)
        break
      default:
        // eslint-disable-next-line no-console
        console.error('Unrecognized finder type', this.type)
        break
      }
    }, 1000)
  }

  _onSearchResult(data) {
    this.searchResultContainer.innerHTML = ''
      
    if (data.length) {
      data.forEach(item => {
        const el = this.renderItem(item, false)
        el.dataset.id = item.id
        this.searchResultContainer.appendChild(el)
      })
    } else {
      this.searchResultContainer.innerText = translate('search.no_results')
    }

    this.searchInput.parentNode.classList.remove('loading')
  }
}

function searchWeMeditate(args) {
  $.get(`/${locale()}/${args.category}.json`, {
    q: args.query,
    exclude: args.exclude.join(','),
  }, args.callback, 'json')
}

function searchJWPlayer(args) {
  const options = {
    method: 'GET',
    headers: {
      Accept: 'application/json',
      Authorization: 'vq7lTutjC6RFmEYCAnjU-WInYmxkWllXVlplVUl4VTA1UGVtaGFXbVZVYkZaWU4wdGgn'
    }
  }
  
  let search = `title: ${args.query}`
  if (args.exclude && args.exclude.length > 0) {
    search += ` AND id: NOT ( ${args.exclude.join(' OR ')} )`
  }

  fetch(`https://api.jwplayer.com/v2/sites/1jLTS9dm/media/?q=${search}`, options)
    .then(response => response.json())
    .then(response => {
      args.callback(response.media.map(item => {
        return { id: item.id, name: item.metadata.title, excerpt: item.metadata.description }
      }))
    })
    .catch(err => console.error(err)) // eslint-disable-line no-console
}