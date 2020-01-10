let priceHelpRequest = document.querySelector('.validate_number');
let requestPriceButton = document.querySelector('.request_price_button');

if (priceHelpRequest) {
  priceHelpRequest.value = '';
  priceHelpRequest.addEventListener('input', function() {
    if (this.value == 0) {
      this.value = '';
    }
    if (requestPriceButton) {
      if (this.value) {
        requestPriceButton.style.pointerEvents = 'auto';
      } else {
        requestPriceButton.style.pointerEvents = 'none';
      }
    }
  })
  priceHelpRequest.addEventListener('keydown', function(e) {
    if (e.which == 190 || e.which == 69 || e.which == 189) {
      e.returnValue = false
    }
  })
}
