
class Grid {

  constructor(element) {
    this.container = element
    this.id = element.id
    this.allowMultiple = {}
    this.activeFilters = {}

    // Sets number of columns when screen width is above each breakpoint.
    const maxColumns = parseInt(element.dataset.maxColumns) || 4
    const breakAt = { 550: 2 }
    if (maxColumns > 2) breakAt[768] = 3
    if (maxColumns > 3) breakAt[1112] = 4

    this.macy = new Macy({
      container: this.container,
      trueOrder: true,
      mobileFirst: true,
      columns: 1,
      breakAt: breakAt,
      margin: 5,
    })

    this.container.addEventListener('contentchange', () => {
      this.macy.runOnImageLoad(() => {
        this.macy.recalculate(true, true)
      })
    })
  }

}
