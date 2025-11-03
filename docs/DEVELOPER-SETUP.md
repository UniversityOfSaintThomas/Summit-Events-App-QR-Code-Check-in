# Developer Setup Guide - CumulusCI

## Overview

This project uses **CumulusCI (cci)** for development, testing, and deployment. CumulusCI handles dependency management, automatically installing the **Summit Events App** as a dependency before deploying this check-in component.

**Repository:** [https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in)

**Releases:** [https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in/releases)

## What is CumulusCI?

CumulusCI is a command-line tool and automation framework for building and deploying Salesforce applications. It provides:
- ✅ Automated dependency management
- ✅ Scratch org creation and configuration
- ✅ Standardized development workflows
- ✅ Automated testing
- ✅ CI/CD pipeline integration

**Documentation:** https://cumulusci.readthedocs.io/en/stable/

---

## Prerequisites

Before you begin, install:

### 1. Python 3.8 or higher
```bash
python --version
```

### 2. CumulusCI
```bash
pip install cumulusci
```

### 3. Salesforce CLI (sf)
```bash
# Windows (using npm)
npm install -g @salesforce/cli

# Verify installation
sf --version
```

### 4. Git
```bash
git --version
```

---

git clone https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in.git
cd Summit-Events-App-QR-Code-Check-in
### Step 1: Clone the Repository
```bash
git clone <repository-url>
cd Summit-Evetns-App-Checkin
```

### Step 2: Verify CumulusCI Configuration
```bash
cci project info
```

You should see:
- Project name: Summit-Evetns-App-Checkin
- Package name: Summit-Evetns-App-Checkin
- Dependencies: Summit Events App from GitHub

### Step 3: Connect Your Dev Hub
```bash
# Connect to Dev Hub (if not already connected)
cci org connect --org dev_hub

# Or use default Dev Hub from Salesforce CLI
cci org default dev_hub <your-devhub-alias>
```

---

## Development Workflow

### Create a Scratch Org

CumulusCI automatically:
1. Creates a scratch org
2. Installs the Summit Events App dependency
3. Deploys this check-in component
4. Configures permissions and sample data

```bash
# Create a new dev scratch org
cci flow run dev_org --org dev

# This runs the 'dev_org' flow which:
# - Creates scratch org
# - Installs Summit Events App
# - Deploys check-in component
# - Sets up permissions
# - Loads sample data
```

### Use an Existing Scratch Org

```bash
# List all orgs
cci org list

# Set default org
cci org default dev

# Open org in browser
cci org browser
```

### Deploy Changes

After making code changes:

```bash
# Deploy all changes
cci task run deploy --org dev

# Or deploy specific metadata
cci task run deploy --path force-app/main/default/lwc/summitEventsQrCheckin --org dev
```

### Run Tests

```bash
# Run all Apex tests
cci task run run_tests --org dev

# Run with specific code coverage requirement (default is 75%)
cci task run run_tests --required_org_code_coverage_percent 75 --org dev
```

---

## CumulusCI Flows

This project includes several pre-configured flows:

### dev_org Flow
Creates a complete development environment:
```bash
cci flow run dev_org --org dev
```

**What it does:**
1. Creates scratch org
2. Installs Summit Events App dependency
3. Deploys check-in component
4. Deploys permission sets
5. Configures Experience Cloud site
6. Loads sample event data
7. Sets namespace checkbox
8. Assigns guest user permissions

### config_dev Flow
Configures an existing org with sample data:
```bash
cci flow run config_dev --org dev
```

**What it does:**
1. Deploys Summit Events App permission sets
2. Deploys site configuration
3. Deploys site settings
4. Deploys guest user permissions
5. Loads sample data
6. Sets namespace checkbox
7. Assigns custom guest permissions

### ci_feature Flow
Runs continuous integration tests:
```bash
cci flow run ci_feature --org feature
```

**What it does:**
1. Creates feature scratch org
2. Runs all Apex tests
3. Validates code coverage (75% required)
4. Deletes scratch org

---

## Custom CumulusCI Tasks

### check_namespace_box
Enables the managed package flag in Summit Events Settings:
```bash
cci task run check_namespace_box --org dev
```

### create_fake_school_data
Generates sample Account records (schools) for testing:
```bash
cci task run create_fake_school_data --org dev
```

### deploy_custom_guest_permission_set
Assigns the custom permission set to the Experience Cloud guest user:
```bash
cci task run deploy_custom_guest_permission_set --org dev
```

---

## Dependencies

This project depends on the **Summit Events App**, which is automatically installed by CumulusCI.

### Dependency Configuration
From `cumulusci.yml`:
```yaml
dependencies:
  - github: 'https://github.com/SFDO-Community/Summit-Events-App.git'
```

CumulusCI automatically:
1. Downloads the latest version from GitHub
2. Deploys it to your scratch org
3. Configures it before deploying your check-in component

### Accessing Dependency Tasks
You can run tasks from the Summit Events App dependency:
```bash
# List available dependency tasks
cci task list

# Run dependency tasks (prefixed with 'sea:')
cci task run sea:deploy_permission_set --org dev
cci task run sea:load_sample_data --org dev
```

---

## Project Structure

```
Summit-Evetns-App-Checkin/
├── cumulusci.yml              # CumulusCI configuration
├── force-app/                 # Source code
│   └── main/
│       └── default/
│           ├── classes/       # Apex classes
│           ├── lwc/           # Lightning Web Components
│           ├── permissionsets/
│           └── staticresources/
├── datasets/                  # Sample data
│   └── snowfackery/
│       └── school_recipe.yml
├── robot/                     # Robot Framework tests
│   └── Summit-Evetns-App-Checkin/
├── docs/                      # Documentation
├── config/                    # Scratch org configs
│   └── project-scratch-def.json
└── orgs/                      # Org-specific configs
    ├── dev.json
    ├── feature.json
    └── beta.json
```

---

## Common Workflows

### Start Fresh Development
```bash
# Create new scratch org with everything configured
cci flow run dev_org --org dev

# Open the org
cci org browser --org dev
```

### Make Code Changes
```bash
# 1. Edit files in force-app/main/default/

# 2. Deploy changes
cci task run deploy --org dev

# 3. Test in browser
cci org browser --org dev

# 4. Run tests
cci task run run_tests --org dev
```

### Test Lightning Web Security
```bash
# 1. Create scratch org
cci flow run dev_org --org dev

# 2. Enable LWS via Setup UI or Apex
cci org browser --org dev
# Navigate to Setup → Session Settings → Enable LWS

# 3. Test camera scanning
# Navigate to check-in component and test camera
```

### Clean Up Scratch Orgs
```bash
# List all orgs
cci org list

# Delete specific org
cci org scratch_delete dev

# Remove org from CumulusCI
cci org remove dev
```

---

## Troubleshooting

### "No default org set"
```bash
cci org default dev
```

### "Dependency installation failed"
Check GitHub connectivity:
```bash
# Verify you can access Summit Events App repo
# Check cumulusci.yml dependencies section
cci project info
```

### "Code coverage below 75%"
```bash
# Run tests to see which classes need more coverage
cci task run run_tests --org dev

# Check test results
cat test_results.xml
```

### "Permission set not found"
```bash
# Re-run config flow
cci flow run config_dev --org dev
```

### "Component not visible in Experience Cloud"
1. Ensure LWS is enabled if using camera
2. Check component visibility settings
3. Verify guest user permissions:
```bash
cci task run deploy_custom_guest_permission_set --org dev
```

---

## Continuous Integration

### GitHub Actions Integration

CumulusCI works seamlessly with GitHub Actions:

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.9'
      
      - name: Install CumulusCI
        run: pip install cumulusci
      
      - name: Authenticate to Dev Hub
        run: |
          echo $SFDX_AUTH_URL > sfdx_auth
          cci org import dev_hub sfdx_auth
        env:
          SFDX_AUTH_URL: ${{ secrets.SFDX_AUTH_URL }}
      
      - name: Run CI Flow
        run: cci flow run ci_feature --org feature
```

### Pre-Commit Hooks

Set up pre-commit hooks to run tests before commits:

```bash
# Install pre-commit
pip install pre-commit

# Create .pre-commit-config.yaml
cat > .pre-commit-config.yaml << EOF
repos:
  - repo: local
    hooks:
      - id: cci-test
        name: Run CumulusCI Tests
        entry: cci task run run_tests
        language: system
        pass_filenames: false
EOF

# Install hooks
pre-commit install
```

---

## Package Development

### Create a Beta Package

```bash
# Create a beta package version
cci flow run release_beta --org packaging

# Install in test org
cci task run install_package_version --version <version-id> --org test
```

### Create a Release Package

```bash
# Create production package version
cci flow run release_production --org packaging

# Promote package
cci task run promote_package_version --version <version-id>
```

---

## Lightning Web Security Setup via CumulusCI

Since camera scanning requires LWS, you can automate LWS enablement:

### Option 1: Manual Setup (Recommended)
1. Create scratch org: `cci flow run dev_org --org dev`
2. Open org: `cci org browser --org dev`
3. Navigate to Setup → Session Settings
4. Enable Lightning Web Security
5. Test camera scanning

### Option 2: Automate with Custom Task (Advanced)

Add to `cumulusci.yml`:
```yaml
tasks:
  enable_lws:
    description: "Enable Lightning Web Security"
    class_path: cumulusci.tasks.sfdx.SFDXOrgTask
    options:
      command: 'force:data:record:update'
      extra: '--sobjecttype SessionSettings --values "EnableLightningWebSecurity=true EnableLWSInExperienceBuilder=true" --use-tooling-api'
```

Then run:
```bash
cci task run enable_lws --org dev
```

---

## Best Practices

### 1. Always Use Fresh Scratch Orgs for Testing
```bash
# Create new org for each feature
cci flow run dev_org --org feature-camera-fix
```

### 2. Commit cumulusci.yml Changes
Always commit changes to `cumulusci.yml` when you add new tasks or flows.

### 3. Document Custom Tasks
Add descriptions to custom tasks in `cumulusci.yml`:
```yaml
tasks:
  my_custom_task:
    description: "What this task does"
    class_path: ...
```

### 4. Use Org Configs for Different Environments
- `orgs/dev.json` - Development settings
- `orgs/feature.json` - Feature testing
- `orgs/beta.json` - Beta testing

### 5. Keep Dependencies Updated
```bash
# Check for dependency updates
cci project info
```

---

## Resources

### CumulusCI Documentation
- **Main Docs:** https://cumulusci.readthedocs.io/en/stable/
- **Tutorial:** https://cumulusci.readthedocs.io/en/stable/tutorial.html
- **Task Reference:** https://cumulusci.readthedocs.io/en/stable/tasks.html
- **Flow Reference:** https://cumulusci.readthedocs.io/en/stable/flows.html

### Summit Events App
- **GitHub:** https://github.com/SFDO-Community/Summit-Events-App
- **Documentation:** Check repo README

### Project Documentation
- [LWS Enablement Guide](./LWS-ENABLEMENT-GUIDE.md)
- [Quick Start Guide](./QUICK-START.md)
- [Architecture](./ARCHITECTURE.md)
- [User Guide](./USER-GUIDE.md)

---

## Getting Help

### CumulusCI Issues
```bash
# Get help on any command
cci --help
cci task info <task-name>
cci flow info <flow-name>

# Check configuration
cci project info
cci org info dev
```

### Common Commands Reference
```bash
# Org Management
cci org list                           # List all orgs
cci org info dev                       # Show org details
cci org browser dev                    # Open org in browser
cci org default dev                    # Set default org
cci org scratch dev new_dev           # Create new scratch org
cci org scratch_delete dev            # Delete scratch org

# Development
cci flow run dev_org --org dev        # Create dev environment
cci task run deploy --org dev         # Deploy changes
cci task run run_tests --org dev      # Run tests

# Debugging
cci task run execute_anon --apex "System.debug('test');" --org dev
cci task run retrieve_unpackaged --org dev

# Dependencies
cci project info                       # Show project & dependencies
```

---

## Quick Reference Card

**Most Common Commands:**
```bash
# Setup
pip install cumulusci
cci org connect --org dev_hub

# Daily Development
cci flow run dev_org --org dev        # New scratch org
cci org browser dev                    # Open org
cci task run deploy --org dev         # Deploy changes
cci task run run_tests --org dev      # Run tests

# Cleanup
cci org scratch_delete dev            # Delete scratch org
```

**First Time Setup:**
1. Install Python, CumulusCI, Salesforce CLI
2. Clone repository
3. Connect Dev Hub: `cci org connect --org dev_hub`
4. Create scratch org: `cci flow run dev_org --org dev`
5. Open org: `cci org browser dev`
6. Enable LWS in Setup → Session Settings
7. Test camera scanning!

---

For questions or issues, see the [main documentation](./README.md) or open an issue on GitHub.

