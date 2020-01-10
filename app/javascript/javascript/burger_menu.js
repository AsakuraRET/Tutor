const button = document.querySelector('.burger-menu');
const menu = document.querySelector('.phone-menu');

button.addEventListener('click', (event) => {
  button.classList.toggle('burger-menu-active');
  menu.classList.toggle('phone-menu-active');
});
