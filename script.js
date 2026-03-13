function showDiv(divId) {
     // List all your div IDs here
     var allDivs = ['edition', 'editorial', 'edition', 'biblio', 'apparat'];
     // Hide all divs
     allDivs.forEach(function(id) {
        document.getElementById(id).style.display = 'none';
    });
     // Show the selected div
    document.getElementById(divId).style.display = 'block';
}
     
const coll = document.getElementsByClassName("collapsible");
for (let i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function() {
        this.classList.toggle("active");
        const content = this.nextElementSibling;
        if (content.style.maxHeight) {
            content.style.maxHeight = null;
        } else {
            content.style.maxHeight = content.scrollHeight + "px";
        }
    });
}


document.addEventListener("DOMContentLoaded", () => {

  document.querySelectorAll("[data-url]").forEach(link => {

    link.addEventListener("click", async (e) => {
      e.preventDefault();

      const [url, hash] = link.dataset.url.split("#");

      const response = await fetch(url);
      const text = await response.text();

      const temp = document.createElement("div");
      temp.innerHTML = text;

      const startElement = temp.querySelector("#" + hash);

      if (!startElement) {
        console.error("Start element not found");
        return;
      }

      let outputHTML = "";
      let currentRow = startElement.closest("tr");

      while (currentRow) {

        const tdWithId = currentRow.querySelector("td[id]");
        
        // stop if this row contains another id (but not the first one)
        if (currentRow !== startElement.closest("tr") && tdWithId) {
          break;
        }

        outputHTML += currentRow.outerHTML;
        currentRow = currentRow.nextElementSibling;
      }

      const rightDiv = document.querySelector(".apparat");

    // Inject content
    rightDiv.innerHTML = "<table>" + outputHTML + "</table>";

    // Wait for the browser to render the new content
    setTimeout(() => {

    const firstRow = rightDiv.querySelector("tr");
    if (!firstRow) return;

    const leftContainer = document.querySelector(".edition");

    // How far the clicked term is from the top of its scroll container
    const leftOffset =
        link.offsetTop - leftContainer.scrollTop;

    // Scroll the right container so the first row appears
    // at that same vertical offset
    rightDiv.scrollTo({
        top: firstRow.offsetTop - leftOffset,
        behavior: "smooth"
    });

    }, 0);
    });
  });
});
