# Global rules

## Git

* No attribution/credits in commits, pushes, or PRs.
* Commit messages: one-line conventional commits only, lowercase + imperative, no body/trailers.

## Code

* Make the smallest correct change and avoid unrelated refactors.
* Avoid comments unless absolutely necessary.
* When needed, comments must be one line and explain the reason as clearly and concisely as possible.
* Prefer explicit, minimal, maintainable code over clever abstractions.

## Writing

* Write comments, commit messages, docs and replies in plain, human-readable sentences.
* Never use semicolons in prose. Split into two sentences or use "because", "so" or "and" instead.
* Bad: `// retry on 429; the api rate limits bursts`
* Good: `// retry on 429 because the api rate limits bursts`

## Package manager

* Always use `pnpm`, never `npm` or others.
