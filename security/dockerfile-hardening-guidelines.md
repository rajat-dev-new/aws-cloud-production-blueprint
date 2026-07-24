# Dockerfile Hardening & CVE Remediation Guidelines

1. **Use Minimal Distroless or Slim Base Images**
   - Prefer `python:3.12-slim` or `distroless` over full Ubuntu/Debian bases. Reduces attack surface by ~80%.
2. **Run as Non-Root User**
   - Always define `USER appuser` with specific UID/GID (e.g. `USER 10001:10001`).
3. **Multi-Stage Builds**
   - Separate build dependencies (gcc, headers, pip caches) from final execution layer.
4. **Automated Vulnerability Gate in CI**
   - Block image pushing if Trivy detects unpatched Critical CVEs (`--severity CRITICAL --exit-code 1`).
