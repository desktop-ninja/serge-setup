#!/usr/bin/env node

const { execSync } = require('child_process');
const { readFileSync, watch } = require('fs');
const { join } = require('path');

const POLL_MS = 1000;
const SHORTCUTS_PATH = join(__dirname, 'shortcuts.json');

// ANSI helpers
const RESET = '\x1b[0m';
const BOLD = '\x1b[1m';
const DIM = '\x1b[2m';
const CYAN = '\x1b[36m';
const YELLOW = '\x1b[33m';
const GREEN = '\x1b[32m';
const WHITE = '\x1b[37m';

function loadShortcuts() {
  return JSON.parse(readFileSync(SHORTCUTS_PATH, 'utf8'));
}

function getFrontmostApp() {
  try {
    return execSync(
      `osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true'`,
      { encoding: 'utf8', timeout: 3000 }
    ).trim();
  } catch {
    return null;
  }
}

function renderCategory(category, entries) {
  const lines = [];
  lines.push(`  ${BOLD}${CYAN}${category}${RESET}`);
  const maxKey = Math.max(...entries.map(([k]) => k.length));
  const padded = Math.min(maxKey + 2, 30);
  for (const [key, action] of entries) {
    lines.push(`  ${YELLOW}${key.padEnd(padded)}${RESET}${WHITE}${action}${RESET}`);
  }
  return lines;
}

// Strip ANSI codes to get visible length
function visibleLength(str) {
  return str.replace(/\x1b\[[0-9;]*m/g, '').length;
}

function render(appName, shortcuts) {
  if (!shortcuts[appName]) {
    return [
      `${BOLD}${YELLOW}  No shortcuts for: ${WHITE}${appName}${RESET}`,
      '',
      `${DIM}  Add an entry to shortcuts.json to see shortcuts here.${RESET}`,
    ].join('\n');
  }

  const categories = Object.entries(shortcuts[appName]);
  const termWidth = process.stdout.columns || 120;
  const colWidth = Math.floor(termWidth / 2) - 1;
  const gutter = '  ';

  // Render each category into blocks of lines
  const blocks = categories.map(([cat, entries]) => renderCategory(cat, entries));

  // Split blocks into two columns by filling left first
  const leftBlocks = [];
  const rightBlocks = [];
  let leftHeight = 0;
  let rightHeight = 0;
  for (const block of blocks) {
    const h = block.length + 1; // +1 for blank line between blocks
    if (leftHeight <= rightHeight) {
      leftBlocks.push(block);
      leftHeight += h;
    } else {
      rightBlocks.push(block);
      rightHeight += h;
    }
  }

  // Flatten blocks into column lines with blank separators
  const flatten = (blks) => {
    const lines = [];
    for (const b of blks) {
      if (lines.length > 0) lines.push('');
      lines.push(...b);
    }
    return lines;
  };

  const leftLines = flatten(leftBlocks);
  const rightLines = flatten(rightBlocks);
  const maxRows = Math.max(leftLines.length, rightLines.length);

  const output = [];
  output.push(`${BOLD}${GREEN}  ${appName}${RESET}`);
  output.push(`${DIM}  ${'─'.repeat(Math.min(termWidth - 4, 100))}${RESET}`);
  output.push('');

  for (let i = 0; i < maxRows; i++) {
    const left = leftLines[i] || '';
    const right = rightLines[i] || '';
    const pad = colWidth - visibleLength(left);
    output.push(left + ' '.repeat(Math.max(pad, 0)) + gutter + right);
  }

  return output.join('\n');
}

function main() {
  let lastApp = null;
  let shortcuts = loadShortcuts();

  function redraw() {
    const app = lastApp || getFrontmostApp();
    if (!app) return;
    try { shortcuts = loadShortcuts(); } catch {}
    process.stdout.write('\x1b[2J\x1b[H');
    console.log(render(app, shortcuts));
  }

  function poll() {
    const app = getFrontmostApp();
    if (app && app !== lastApp) {
      lastApp = app;
      redraw();
    }
  }

  // Watch shortcuts.json for changes — re-render on edit
  watch(SHORTCUTS_PATH, { persistent: false }, () => redraw());

  poll();
  setInterval(poll, POLL_MS);
}

main();
