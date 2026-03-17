// proposta.js

// Function to handle global navigation and display modes
function goToPageMode(mode) {
    let pathname = window.location.pathname;
    let isFonctionnellePage = pathname.endsWith('_f.html');

    // Determine the base filename regardless of which page we are on
    let basePathname = isFonctionnellePage
        ? pathname.substring(0, pathname.length - 7) + '.html'
        : pathname;

    let fonctionnellePathname = basePathname.substring(0, basePathname.length - 5) + '_f.html';

    if (mode === 'fonctionnelle') {
        if (!isFonctionnellePage) {
            window.location.assign(fonctionnellePathname + window.location.search + window.location.hash);
        }
    } else {
        // For 'edition' or 'preliminaire'
        if (isFonctionnellePage) {
            // we need to go back to the base page, but we also want to trigger the specific mode.
            // A simple way is to pass it via hash or sessionStorage, but here we can just pass a URL parameter
            window.location.assign(basePathname + "?mode=" + mode + window.location.hash);
        } else {
            // We are already on the right page, just change the visual mode
            handleInternalDisplayMode('edition', mode);
        }
    }
}

// Check on load if we arrived with a specific mode requested in URL parameters
document.addEventListener("DOMContentLoaded", () => {
    const urlParams = new URLSearchParams(window.location.search);
    const requestedMode = urlParams.get('mode');

    // Only apply if we are on the base page (not _f) and a mode was requested
    if (requestedMode && !window.location.pathname.endsWith('_f.html')) {
        handleInternalDisplayMode('edition', requestedMode);
    } else if (window.location.pathname.endsWith('_f.html')) {
        // If we load the _f page directly, set its button as active
        updateActiveButton('fonctionnelle');
    } else {
        // Default base page load
        updateActiveButton('normal');
    }
});

// Set active button style
function updateActiveButton(mode) {
    const buttons = document.querySelectorAll('.button button');
    buttons.forEach(btn => btn.classList.remove('active-mode'));

    // Find matching button text
    buttons.forEach(btn => {
        let text = btn.innerText.toLowerCase().trim();
        // Handle the user's specific text labels: Edition, Pre, Fonctionnelle
        if (text === 'edition' && mode === 'normal') btn.classList.add('active-mode');
        // also support the exact label "Référence" if it's there
        if (text === 'référence' && mode === 'normal') btn.classList.add('active-mode');
        
        if (text === 'pre' && mode === 'preliminaire') btn.classList.add('active-mode');
        if (text === 'préliminaire' && mode === 'preliminaire') btn.classList.add('active-mode');
        
        if (text === 'fonctionnelle' && mode === 'fonctionnelle') btn.classList.add('active-mode');
    });
}

// Backwards compatibility for the user's manual showDiv calls
// The user changed the HTML to call showDiv('edition'), showDiv('pre'), showDiv('fonctionnelle')
window.showDiv = function(idOrMode) {
    if (idOrMode === 'edition') {
        goToPageMode('normal');
    } else if (idOrMode === 'pre' || idOrMode === 'preliminaire') {
        goToPageMode('preliminaire');
    } else if (idOrMode === 'fonctionnelle') {
        goToPageMode('fonctionnelle');
    } else {
        // Fallback to internal mode handler
        handleInternalDisplayMode(idOrMode, 'normal');
    }
};

// Renamed core logic to avoid conflict with the user's global showDiv override
function handleInternalDisplayMode(divId, mode = 'normal') {
    const allDivs = ['edition', 'editorial', 'biblio', 'apparat'];
    const targetDiv = document.getElementById(divId);

    // Update button visual state
    updateActiveButton(mode);

    if (!targetDiv) return;

    allDivs.forEach(function (id) {
        const el = document.getElementById(id);
        if (el) {
            if (id !== divId) {
                el.style.display = 'none';
                el.classList.remove('fade-in');
            }
        }
    });

    targetDiv.style.display = 'block';

    // Trigger reflow for animation
    void targetDiv.offsetWidth;
    targetDiv.classList.add('fade-in');

    // Maintain side-by-side view for 'edition' and 'apparat' if possible
    if (divId === 'edition') {
        const apparat = document.getElementById('apparat');
        if (apparat) {
            apparat.style.display = 'block';
            apparat.classList.add('fade-in');
        }
    }

    // Handle text modes
    if (divId === 'edition') {
        const variants = targetDiv.querySelectorAll('.variant');

        variants.forEach(variant => {
            const var21 = variant.querySelector('.var21');
            const varp = variant.querySelector('.varp');

            if (var21 && varp) {
                if (mode === 'preliminaire') {
                    // Show varp content in the text, hide var21 content, disable tooltip functionality
                    var21.style.display = 'none';

                    // Display varp as normal text instead of absolute tooltip
                    varp.classList.add('mode-preliminaire');
                    variant.classList.add('mode-preliminaire-container');
                } else {
                    // Normal edition mode
                    var21.style.display = 'inline';

                    // Restore varp to be a tooltip
                    varp.classList.remove('mode-preliminaire');
                    variant.classList.remove('mode-preliminaire-container');
                }
            }
        });
    }
}

// Ensure the code runs after DOM is loaded
document.addEventListener("DOMContentLoaded", () => {

    // Modern collapsible logic
    const collapsibles = document.querySelectorAll(".collapsible");
    collapsibles.forEach(coll => {
        coll.addEventListener("click", function () {
            this.classList.toggle("active");
            const content = this.nextElementSibling;

            if (content.style.maxHeight) {
                // Closing
                content.style.maxHeight = null;
            } else {
                // Opening - calculate full height
                content.style.maxHeight = (content.scrollHeight + 48) + "px";
            }
        });
    });

    // Dynamic content fetching for data-url links
    document.querySelectorAll("[data-url]").forEach(link => {
        link.addEventListener("click", async (e) => {
            e.preventDefault();

            // Visual feedback on click
            link.style.opacity = '0.6';
            setTimeout(() => link.style.opacity = '1', 200);

            try {
                const [url, hash] = link.dataset.url.split("#");
                const response = await fetch(url);

                if (!response.ok) throw new Error("Network response was not ok");

                const text = await response.text();
                const temp = document.createElement("div");
                temp.innerHTML = text;

                const startElement = temp.querySelector("#" + hash);

                if (!startElement) {
                    console.error("Start element not found:", hash);
                    return;
                }

                let outputHTML = "";
                let currentRow = startElement.closest("tr");

                if (!currentRow && startElement.tagName.toLowerCase() === 'tr') {
                    currentRow = startElement;
                }

                while (currentRow) {
                    const tdWithId = currentRow.querySelector("td[id]");

                    // Stop if we hit the next term
                    if (currentRow !== startElement.closest("tr") && tdWithId) {
                        break;
                    }

                    outputHTML += currentRow.outerHTML;
                    currentRow = currentRow.nextElementSibling;
                }

                const rightDiv = document.querySelector(".apparat");

                if (rightDiv) {
                    // Update theme class based on the link's class list
                    rightDiv.className = "apparat"; // Reset classes
                    link.classList.forEach(cls => {
                        if (cls !== "active-link") { // ignore any active state classes if added later
                            rightDiv.classList.add("theme-" + cls);
                        }
                    });

                    rightDiv.innerHTML = "<div class='fade-in'><table>" + outputHTML + "</table></div>";

                    // Wait slightly for DOM to update
                    setTimeout(() => {
                        // Make links inside apparat open in new window
                        rightDiv.querySelectorAll("a").forEach(a => {
                            if (a.hasAttribute("href")) {
                                a.setAttribute("target", "_blank");
                            }
                        });

                        const firstRow = rightDiv.querySelector("tr");
                        if (!firstRow) return;

                        const leftContainer = document.querySelector(".edition");
                        if (leftContainer) {
                            // If .edition is scrollable or we scroll the window
                            rightDiv.scrollTo({
                                top: 0,
                                behavior: "smooth" // Scroll apparat to top of its content
                            });
                        }
                    }, 50);
                }
            } catch (error) {
                console.error("Error fetching content:", error);
            }
        });
    });
});
