document.addEventListener("DOMContentLoaded", function () {
  const emojis = ["🍁", "🍂", "🍃"];
  const interval = 800;

  function createLeaf() {
    const leaf = document.createElement("div");
    leaf.className = "leaf-emoji";
    leaf.innerText = emojis[Math.floor(Math.random() * emojis.length)];

    leaf.style.left = Math.random() * window.innerWidth + "px";
    leaf.style.fontSize = (20 + Math.random() * 20) + "px";
    const duration = 10 + Math.random() * 4;
    leaf.style.animationDuration = duration + "s";

    document.body.appendChild(leaf);

    leaf.addEventListener("animationend", () => {
      leaf.remove();
    });
  }

  setInterval(createLeaf, interval);
});
