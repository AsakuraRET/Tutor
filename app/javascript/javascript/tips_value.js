function disabledCards() {
  let allCards = document.querySelectorAll('.all-cards');
  for (let i = 0; i < allCards.length; i++) {
    allCards[i].addEventListener('click', function() {
      allCards[i].classList.add("disabled_buttons");
    })
  }
}
disabledCards();
document.addEventListener('disable', () => {
  disabledCards();
});

const tips = document.querySelector("#help_request_tips");
const card = document.querySelectorAll(".card-wrapper");
for (let i = 0; i < card.length; i++) {
  card[i].addEventListener("click", function() {
    this.href += '&tips='+tips.value;
  })
}
