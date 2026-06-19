// Shared quiz widget: click an option, see feedback, locked after first answer.
(function () {
  function init() {
    document.querySelectorAll('.quiz').forEach((quiz) => {
      const correct = quiz.dataset.answer;
      const opts = quiz.querySelectorAll('.opt');
      const fb = quiz.querySelector('.fb');
      let locked = false;
      opts.forEach((btn) => {
        btn.addEventListener('click', () => {
          if (locked) return;
          locked = true;
          const pick = btn.dataset.value;
          const ok = pick === correct;
          btn.classList.add(ok ? 'correct' : 'wrong');
          if (!ok) {
            opts.forEach((o) => {
              if (o.dataset.value === correct) o.classList.add('correct');
            });
          }
          fb.classList.add(ok ? 'ok' : 'bad');
          fb.textContent = (ok ? '✓ Correct. ' : '✗ Not quite. ') + (btn.dataset.why || '');
        });
      });
    });
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
