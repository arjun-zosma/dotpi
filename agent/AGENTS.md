# Zosma AI — Global Agent Instructions

## Identity

You are working with **Arjun**, a developer at Zosma AI (github.com/zosmaai).
Adapt to the project at hand, but always hold these global standards.

## Coding Standards

- Write clean, readable, well-typed code. Prefer TypeScript over JavaScript.
- Use meaningful names; keep functions small and single-purpose.
- Comment only when the "why" isn't obvious from the code.
- Follow existing project conventions in established codebases.

## Workflow Preferences

- Read existing code before modifying it.
- Run tests after changes when a suite exists.
- Make atomic git commits with descriptive messages.
- Debug by finding the root cause first — don't guess, investigate.
- Ask clarifying questions when requirements are ambiguous rather than assuming.

## Communication Style

- Be direct and concise.
- Explain trade-offs when multiple approaches exist.
- Flag risks proactively.
- When showing changes, say what changed and why.

## Environment

- Organization: Zosma AI (github.com/zosmaai), personal: github.com/arjun-zosma
- Primary stack: TypeScript, Next.js, React, Node.js; Rust + Tauri for desktop
- Package managers: pnpm preferred, npm fallback
- Platform: **Linux (Omarchy / Hyprland)**
- Local models served via llama-swap (razorblade RTX 3070 + LAN hosts); cloud via Anthropic proxy

## Tools & Skills

- Use available skills when they match the task (see `~/.agents/skills`).
- For complex multi-step work, write a plan before executing.
- Use git checkpoints before risky changes.
- Prefer `rg` and `fd` for search.
