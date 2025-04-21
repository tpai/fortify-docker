# Fortify Docker

A Docker-based setup for running Fortify security scans on code repositories.

## Prerequisites

- Docker
- Fortify software (`Fortify_SCA_23.1.0_linux_x64.run`, `Fortify_Apps_and_Tools_23.1.0_linux_x64.run`)
- Fortify license file (`fortify.license`)

## Features

- Automated repository cloning
- Containerized Fortify scanning environment
- Customizable scan filtering via bypass.txt

## Usage

1. Configure your repository settings in `scan.sh`:
   ```bash
   repo=your-repo-url
   branch=your-target-branch
   target=your-scan-target-directory
   ```

2. Run the scan:
   ```bash
   ./scan.sh
   ```

The script will:
1. Clone the target repository
2. Create a Fortify container
3. Create scan mission and run the security scan
4. Generate an HTML report
5. Open the report automatically
6. Clean up the container

## Create Scan Mission

Scanning different types of projects:

### TypeScript/JavaScript
```bash
sourceanalyzer -b web \
  -exclude "/scan/web/internal" \
  -exclude "/scan/web/**/*.test.*" \
  -Dcom.fortify.sca.Phase0HigherOrder.Languages=javascript,typescript \
  /scan/web
```

### Python
```bash
sourceanalyzer -b backend \
  -python-version 3 \
  -python-path /usr/bin/python3 \
  /scan/backend
```

### Go
```bash
sourceanalyzer -b backend \
  -exclude "/scan/backend/web/swagger-ui/" \
  -exclude "/scan/backend/docs/" \
  -exclude "/scan/backend/deployments/" \
  -exclude "/scan/backend/vendor/" \
  -goroot /usr/local/go \
  -gopath /scan/backend \
  /scan/backend
```
