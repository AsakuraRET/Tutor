function showMessageCardModalOpen() {
  const paymentForm = document.getElementById("payment-form");
  if (paymentForm) {
    const stripe = Stripe('pk_test_N7MMj6kmuZBTQrIeVxA62n5700OVQg2i4u');

    const elements = stripe.elements();

    const style = {
      base: {
        color: '#32325d',
        fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
        fontSmoothing: 'antialiased',
        fontSize: '16px',
        '::placeholder': {
          color: '#aab7c4'
        }
      },
      invalid: {
        color: '#fa755a',
        iconColor: '#fa755a'
      }
    };

    const cardNumber = elements.create('cardNumber', {
      style: style
    });
    const cardExpiry = elements.create('cardExpiry', {
      style: style
    });
    const cardCvc = elements.create('cardCvc', {
      style: style
    });

    cardNumber.mount('#cardNumber');
    cardExpiry.mount('#cardExpiry');
    cardCvc.mount('#cardCvc');

    paymentForm.addEventListener("submit", event => {
      event.preventDefault();
      stripe.createToken(cardNumber).then(result => {
        const stateErrors = document.getElementById('payment_errors');
        if (result.error) {
          stateErrors.textContent = result.error.message;
          stateErrors.style.color = '#FF0000';
        } else {
          const xhr = new XMLHttpRequest();
          const token = document.getElementsByName('csrf-token')[0].content;
          let body = chooseTokenAndHR(result.token.id);

          xhr.open('POST', '/payment_sources', true);
          xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
          xhr.setRequestHeader('X-CSRF-Token', token);
          xhr.onreadystatechange = () => {
            if (xhr.readyState === 4) {
              if (String(xhr.status)[0] == '2') {
                stateErrors.textContent = 'Your card added!';
                stateErrors.style.color = '#228B22';
                setTimeout(function() {
                  if (body.includes("help_request_id")) {
                    window.location.reload();
                  } else {
                    window.location = '/current_request';
                  }
                }, 3000);
              } else {
                const response = JSON.parse(xhr.responseText);
                stateErrors.textContent = response.error;
                stateErrors.style.color = '#FF0000';
              }
            }
          }
          xhr.send(body);
        }
      });
    });

    function chooseTokenAndHR(tokenId) {
      const urlArray = window.location.pathname.split('/');
      const help_request_id = Number(urlArray[2]);
      if (urlArray[1] == 'help_requests' && help_request_id && urlArray.length == 3) {
        body = 'token=' + tokenId + '&help_request_id=' + help_request_id;
      } else {
        body = 'token=' + tokenId;
      }
      return body;
    }
  }
}
showMessageCardModalOpen();
document.addEventListener('cardModalOpen', () => {
  showMessageCardModalOpen();
});
