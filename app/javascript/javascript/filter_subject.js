import Rails from "rails-ujs";

const subjectsSelect = document.getElementById("select_for_subject");
const filterBlock = document.getElementById("filter_form");
const selectedSubjectContainer = document.getElementById('selected_subjects_container');
const alreadySelectedSubjects = [];
const alreadySelecectedIDS = [];
const subjectIdList = document.getElementById('subject_id');
const searchForm = document.getElementById('seach_request_form');
const searchFormByTime = document.getElementById('list_filter_by_time');

if (subjectsSelect) {
  subjectsSelect.addEventListener("change", () => {

  const selectedSubject = subjectsSelect.options[subjectsSelect.selectedIndex].text;
  if (subjectsSelect.options[subjectsSelect.selectedIndex].text !== 'Select Subject') {
    if (!alreadySelectedSubjects.includes(selectedSubject)) {
      alreadySelectedSubjects.push(selectedSubject);
      alreadySelecectedIDS.push(subjectsSelect.value)
      const subjectWrapper = document.createElement('span');

      const subjectName = document.createElement('span');
      subjectName.setAttribute('class', 'selectedSubject');
      subjectName.innerHTML = selectedSubject;
      subjectWrapper.appendChild(subjectName);

      const deleteSubject = document.createElement('span');
      deleteSubject.setAttribute('class', 'close');
      subjectName.appendChild(deleteSubject);

      deleteSubject.addEventListener("click", () => {
        selectedSubjectContainer.removeChild(subjectWrapper);
        const indexOfSubject = alreadySelectedSubjects.indexOf(selectedSubject);
        alreadySelectedSubjects.splice(indexOfSubject, 1);
        alreadySelecectedIDS.splice(indexOfSubject, 1);
        subjectIdList.value = alreadySelecectedIDS.join(",");
        Rails.fire(searchForm, "submit");
      });

      selectedSubjectContainer.appendChild(subjectWrapper);
      subjectIdList.value = alreadySelecectedIDS.join(",");
      Rails.fire(searchForm, "submit");
    }
    subjectsSelect.selectedIndex = 0;
  }
});
}

if (searchFormByTime) {
  searchFormByTime.addEventListener("change", () => {
    Rails.fire(searchForm, "submit");
  })
}
