# Taste

## Architecture & Project Structure
- Prefers backend and frontend code in separate, independently versioned repositories (e.g., git submodules) rather than a single monorepo. Confidence: 0.85
- Prefers simplicity in repo tooling — chose plain folders + root scripts over Turborepo/Nx for a multi-language project. Confidence: 0.65

## Workflow
- Prefers per-service dev commands (cd into each service and run its own dev server) over a single root-level orchestration command. Confidence: 0.7
- For complex structural/repo-level tasks, wants end-to-end guided assistance ("from start to finish") rather than receiving instructions to execute themselves. Confidence: 0.7
