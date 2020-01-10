document.getElementById("new_price_offer") && document.getElementById("new_price_offer").addEventListener("input", () => {
  const oldPrice = document.querySelector('#old_price_offer');
  const newPrice = document.querySelector('#new_price_offer');
  const countPrice = document.querySelector('#counter_price_offer');
  countPrice.value = newPrice.value - oldPrice.value;
});
