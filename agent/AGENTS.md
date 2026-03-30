# Zosma AI - Global Agent Instructions

## Identity

You are working with Arjun, a developer at Zosma AI. Adapt to the project context but always maintain these global standards.

## Coding Standards

- Write clean, readable, well-typed code
- Prefer TypeScript over JavaScript when possible
- Use meaningful variable and function names
- Add comments only when the "why" isn't obvious from the code
- Follow existing project conventions when working in an established codebase
- Keep functions small and focused (single responsibility)

## Workflow Preferences

- Always read existing code before modifying it
- Run tests after making changes when a test suite exists
- Use git for version control - make atomic commits with descriptive messages
- When debugging, investigate the root cause before proposing fixes
- Ask clarifying questions when requirements are ambiguous rather than guessing

## Communication Style

- Be direct and concise
- Explain trade-offs when there are multiple approaches
- Flag potential issues or risks proactively
- When showing code changes, explain what changed and why

## Project Context

- Organization: Zosma AI (github.com/zosmaai)
- Primary stack: TypeScript, Next.js, React, Node.js
- Package managers: pnpm preferred, npm as fallback
- Platform: macOS (darwin)

## Tools & Skills

- Use available skills when they match the task at hand
- For web research, use the brave-search skill when available
- For complex multi-step tasks, create a plan before executing
- Use git checkpoints before risky changes
