/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import "../stylesheets/aplication.scss";
import "../stylesheets/reg.scss";
import "../stylesheets/home_page.scss";
import "../stylesheets/current_request.scss";
import "../stylesheets/request.scss";
import "../stylesheets/list.scss";
import "../stylesheets/form_show.scss";
import "../stylesheets/account.scss";
import "../stylesheets/headlines.scss";
import "../stylesheets/model_window.scss";
import "../stylesheets/form_chats_page.scss";
import "../stylesheets/payment_sources.scss";
import "../stylesheets/subjects_filter.scss";
import "../stylesheets/payment_information.scss";
import "../stylesheets/table_admin.scss";
import "../stylesheets/admin.scss";

import "../javascript/hide_menu.js";
import "../javascript/burger_menu.js";
import "../javascript/help_request_payment_section_show.js";
import "../javascript/load_photo_request.js";
import "../javascript/counter_offer.js";
import "../javascript/scroll_chats.js";
import "../javascript/payment_sources.js";
import "../javascript/filter_subject.js";
import "../javascript/validate_price.js";
import "../javascript/tips_value.js";

import "../images/arrow_left.svg";
import "../images/tutoru.svg";
import "../images/dance_people.svg";
import "../images/Skype.svg";
import "../images/WhatsApp.svg";
import "../images/Facebook.svg";
import "../images/Google.svg";
import "../images/ok.svg";
import "../images/telegram.svg";
import "../images/question_mark.svg";
import "../images/Trash_can.svg";
import "../images/exel.svg";

import Rails from "rails-ujs";

Rails.start();
