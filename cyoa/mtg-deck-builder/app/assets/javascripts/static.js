function setupLogoClickHandler (logo_selector) {
  $(logo_selector).on("click", function (event) {
    document.location.href = "/";
  });
}

$(document).ready(function () {
  setupLogoClickHandler("#logo");
});
