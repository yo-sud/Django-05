document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById('movieSearch');
  if (!input) return;
  input.addEventListener('input', () => {
    const q = input.value.trim().toLowerCase();
    document.querySelectorAll('[data-search]').forEach((el) => {
      const text = (el.getAttribute('data-search') || '').toLowerCase();
      el.style.display = !q || text.includes(q) ? '' : 'none';
    });
  });
});
