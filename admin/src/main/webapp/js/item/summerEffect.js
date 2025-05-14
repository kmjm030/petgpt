document.addEventListener("DOMContentLoaded", () => {
  startEmojiRain();
});

function startEmojiRain() {
  const emojis = ['🌊', '🐳' , '💧'];
  const count = 15;

  for (let i = 0; i < count; i++) {
    const emoji = document.createElement('div');
    emoji.classList.add('falling-emoji');
    emoji.textContent = emojis[Math.floor(Math.random() * emojis.length)];
    emoji.style.left = `${Math.random() * 100}vw`;
    emoji.style.animationDelay = `${Math.random() * 5}s`;
    emoji.style.fontSize = `${Math.random() * 24 + 16}px`;
    document.body.appendChild(emoji);
  }
}
