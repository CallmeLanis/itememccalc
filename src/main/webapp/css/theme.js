/* theme.js — loaded by every page, handles dark/light toggle */
(function () {
    'use strict';

    var STORAGE_KEY = 'emc-theme';
    var CYCLE       = ['dark', 'light'];
    var META = {
        dark:  { label: 'Dark',  icon: '\uD83C\uDF11' },   /* 🌑 */
        light: { label: 'Light', icon: '\u2600\uFE0F'  }   /* ☀️ */
    };

    function applyTheme(theme) {
        if (!META[theme]) theme = 'dark';
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem(STORAGE_KEY, theme);
        var lbl  = document.getElementById('themeLabel');
        var icon = document.getElementById('themeIcon');
        if (lbl)  lbl.textContent  = META[theme].label;
        if (icon) icon.textContent = META[theme].icon;
    }

    /* Expose globally so onclick="cycleTheme()" works inline */
    window.cycleTheme = function () {
        var cur = document.documentElement.getAttribute('data-theme') || 'dark';
        var idx = CYCLE.indexOf(cur);
        applyTheme(CYCLE[(idx + 1) % CYCLE.length]);
    };

    /* Apply stored theme as early as possible (called from head too) */
    window._applyStoredTheme = function () {
        var stored = localStorage.getItem(STORAGE_KEY);
        if (stored === 'anime') stored = 'dark';   /* migrate old value */
        applyTheme(stored || 'dark');
    };

    /* Run on DOMContentLoaded to refresh icon/label text after HTML renders */
    document.addEventListener('DOMContentLoaded', function () {
        window._applyStoredTheme();
    });
})();
