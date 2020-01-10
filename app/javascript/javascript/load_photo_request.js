const helpRequestProblemInput = document.getElementById('help_request_problem_picture');
const helpRequestProblemElement = document.getElementById('photo_file_picture');


helpRequestProblemInput && helpRequestProblemInput.addEventListener('change', event =>{
  const file = event.target.files[0];
  const reader = new FileReader();
  reader.onloadend = () => {
    helpRequestProblemElement.style.backgroundImage = `url("${reader.result}")`;
  };

  if (file){
    reader.readAsDataURL(file);
  }
})
