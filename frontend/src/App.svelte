<script>
  const words = [
    "WHO",
    "ARE",
    "YOU",
    "WATCHING",
    "WINTER",
    "GUY"
  ];
</script>

<svelte:head>
  <title>Who Are You?</title>
</svelte:head>

<div class="container">
  <h1>WHO ARE YOU?</h1>

  <div class="words">
    {#each words as word}
      <span>{word}</span>
    {/each}
  </div>

  <p>Internal camera monitoring system.</p>
</div>

<style>
  :global(body) {
    margin: 0;
    background: #050505;
    color: white;
    font-family: sans-serif;
  }

  .container {
    min-height: 100vh;
    display: grid;
    place-content: center;
    text-align: center;
    gap: 2rem;
  }

  .words {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
    justify-content: center;
  }

  span {
    border: 1px solid #333;
    padding: 0.75rem;
  }
</style>