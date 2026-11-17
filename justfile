set shell := ["bash", "-euo", "pipefail", "-c"]

# Lists the commands.
default:
    @just --list

# Checks owned source/profile contracts and workflows without builds or network.
check:
    just --fmt --check
    bash scripts/check-repo-consistency.sh
    bash scripts/audit-codex-agents.sh
    python3 -m json.tool tools/ci-tools.json > /dev/null
    actionlint
    zizmor --offline --no-progress .github/workflows/ci.yml .github/workflows/security.yml
    gitleaks git --no-banner --redact --log-opts=--all .

# Formats the command file.
fix:
    just --fmt

# Builds the real portable bundle without installing or launching it.
build:
    bash scripts/build-release-bundle.sh

# Checks all source contracts and builds the real portable bundle.
verify: check build
