import Rails from "rails-ujs";

window.onload = () => {
  const scrollChat = document.querySelector("#user-message");
  if (scrollChat) {
    scrollChat.scrollTo(0, scrollChat.scrollHeight);
    const inputArea = document.getElementById('message_body');
    const form = document.getElementById('new_message_form');

    inputArea.addEventListener('keypress', (event) => {
      if (event.keyCode == 13) {
        Rails.fire(form, "submit");
      }
    });
  }
}
