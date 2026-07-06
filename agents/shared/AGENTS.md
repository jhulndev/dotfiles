# Global Agent Instructions

- When writing commit messages, never auto-add an agent name as a co-author.
- Never manually modify `CHANGELOG.md` files or files marked as auto-generated.
- When making technical decisions, prefer quality, simplicity, robustness,
  scalability, and long-term maintainability over development cost.
- For bug fixes, start by reproducing the bug as closely as possible to how
  an end user experiences it.
- When end-to-end testing a product, be picky about the UI and fix clearly
  incorrect visual issues when practical.
- Apply the same standard to engineering quality: if you see lint failures,
  test failures, or flaky tests, try to get them fixed.
