
class SubtleSystem {

  constructor(element) {
    const nodesContainer = element.querySelector('#hover_chakras')
    this.activeNode = null
    this.container = element

    for (let index = 0; index < nodesContainer.childElementCount; index++) {
      const node = nodesContainer.children[index]
      node.addEventListener('mouseover', event => this.onNodeMouseover(event.currentTarget))
      node.addEventListener('mouseout', event => this.onNodeMouseout(event.currentTarget))
      node.addEventListener('click', event => this.onNodeClick(event.currentTarget))
    }

    this.activeTab = element.querySelector('.subtle-system__toggle__item--active')
    element.querySelector('.subtle-system__toggle').addEventListener('click', event => this.onSelectTab(event.target))
  }

  onSelectTab(element) {
    if (element.dataset.tab != this.activeTab.dataset.tab) {
      this.activeTab.classList.remove('subtle-system__toggle__item--active')
      this.container.classList.remove(`subtle-system--${this.activeTab.dataset.tab}`)
      this.activeTab = element
      this.container.classList.add(`subtle-system--${element.dataset.tab}`)
      this.activeTab.classList.add('subtle-system__toggle__item--active')
    }
  }

  onNodeMouseover(node) {
    const targetActiveNode = node.id

    if (targetActiveNode != this.activeNode) {
      // Some of the nodes are contained within other notes, so for some nodes,
      // we use a timer to make sure that the person really wants to select the node they are hovering on.
      let time = 0

      if ((this.activeNode == 'chakra_2' || this.activeNode == 'chakra_3') && targetActiveNode == 'chakra_3b') {
        time = 300
      } else if (this.activeNode == 'chakra_3b' && (targetActiveNode == 'chakra_2' || targetActiveNode == 'chakra_3')) {
        time = 300
      }

      this.timeout = setTimeout(() => {
        // Select the new node, and deselect the old one.
        this.container.classList.add('subtle-system--no-animation')

        if (this.activeNode) {
          const activeNodeSelector = this.activeNode.replace(/_/g, '-')
          this.container.querySelector(`#${this.activeNode}`).classList.remove('active')
          this.container.querySelector(`.subtle-system__item--${activeNodeSelector}`).classList.remove('subtle-system__item--active')
        }

        const targetNodeSelector = targetActiveNode.replace(/_/g, '-')
        console.log('select', `.${targetNodeSelector}`)
        this.container.querySelector(`#${targetActiveNode}`).classList.add('active')
        this.container.querySelector(`.subtle-system__item--${targetNodeSelector}`).classList.add('subtle-system__item--active')
        this.activeNode = targetActiveNode
      }, time)
    }
  }

  // nodeed when the user stops hovering over a particular chakra/channel.
  onNodeMouseout(node) {
    // Clear the timeout because we don't want to select this node after all.
    clearTimeout(this.timeout)
    this.timeout = null
  }

  onNodeClick(node) {
    // If we are on mobile, scroll down to the description of the node we just selected.
    /*if (window.innerWidth <= 768) {
      var position = $(this.container).offset().bottom - 100
      Application.header.scroll.animateScroll(position, 4000, { speed: 4000, updateURL: false })
    }*/
  }

}
