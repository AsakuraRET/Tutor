if (document.getElementById("show_payment_section_button")) {
  document.getElementById("show_payment_section_button").onclick = () => {
    document.getElementById("payment_form_first_block").style.display = "none";
    document.getElementById("payment_form_second_block").style.display = "block";
  }
}
