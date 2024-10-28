Array.from(document.getElementsByClassName("copy-link")).forEach((l) => {
  if (navigator.clipboard) {
    l.addEventListener("click", async (e) => {
      e.preventDefault();
      await navigator.clipboard.writeText(e.target.dataset.clip);
      e.target.dataset.tooltip = "copied";
    });
    l.addEventListener(
      "mouseleave",
      (e) => (e.target.dataset.tooltip = "click to copy"),
    );
    l.dataset.tooltip = "click to copy";
  }
});
