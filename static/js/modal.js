// https://github.com/whatwg/html/issues/3567
// this is a really shitty back because whatwg refuses to add a modal attribute
// im holding out hope that they eventually do, but its been talked about since
// 2019 and it hasnt happened yet lmao
document.querySelectorAll('dialog[open][modal]').forEach(el => {
  // reopen the non-modal as modal, the way whatwg intended
  el.close()
  el.showModal()
})

document.querySelectorAll('dialog[modal]').forEach(el => {
  // no esc close, require acknowledgement
  el.addEventListener('cancel', (event) => {
    event.preventDefault()
  })
})

document.querySelectorAll('dialog[modal][remember]').forEach(el => {
  if (localStorage.getItem(el.getAttribute('remember'))) {
    el.close()
  }
})

document.querySelectorAll('dialog[modal][remember]').forEach(el => {
  el.addEventListener('close', _event => {
    if (el.returnValue) {
      localStorage.setItem(el.getAttribute('remember'), true)
    }
  })
})

