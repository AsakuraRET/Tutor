window.addEventListener("scroll",() => {
  if (document.body.scrollTop > 0 || document.documentElement.scrollTop > 0) {
    document.querySelector("header").style.background = "#fff";
  } else {
    document.querySelector("header").style.background = "transparent";
  }
});
