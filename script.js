// Lista de produtos
var list = [
  [
    "TL900",
    "TL1050",
    // "GM1050",
    // "GM800",
    // "GP400A",
    // "GP750",
    // "GS600",
    // "GM550",
    // "GM600",
    // "GM650",
    // "GM500",
  ],
];

// Função para criar item da lista
function item(name) {
  return `
      <li>
        <span>${name}</span>
        <div class="buttons">
          <a href="build/${name}" class="ver" target="_blank">Visualizar</a>
          <button onclick="download('${name}')">Download</button>
        </div>
      </li>
    `;
}

const mainContent = list.map((lote) => {
  return `
      <form>
        <fieldset>
          ${lote.map((name) => item(name)).join("")}
        </fieldset>
      </form>
    `;
});

function download(name) {
  const link = document.createElement("a");
  link.href = `build/${name}.zip`;
  link.download = name;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

document.querySelector("main").innerHTML = mainContent.join("");
