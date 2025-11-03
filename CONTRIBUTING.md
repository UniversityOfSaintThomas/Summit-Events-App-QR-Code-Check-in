# Contributing to Summit Events Check-In

Thank you for your interest in contributing! This document provides guidelines for contributing to the Summit Events Check-In component.

---

## Development Environment Setup

This project uses **CumulusCI** for development and dependency management. Follow the [Developer Setup Guide](docs/DEVELOPER-SETUP.md) to get started.

### Quick Start for Contributors

**Repository:** [https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in](https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in)

```bash
# 1. Fork and clone the repository
git clone https://github.com/UniversityOfSaintThomas/Summit-Events-App-QR-Code-Check-in.git
cd Summit-Events-App-QR-Code-Check-in

# 2. Install CumulusCI
pip install cumulusci

# 3. Connect your Dev Hub
cci org connect --org dev_hub

# 4. Create a development org
# This automatically installs Summit Events App dependency
cci flow run dev_org --org dev

# 5. Open the org
cci org browser dev
```

CumulusCI automatically handles:
- ✅ Installing Summit Events App dependency
- ✅ Deploying the check-in component
- ✅ Configuring permissions
- ✅ Loading sample data

---

## Making Changes

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes

Edit files in `force-app/main/default/`:
- Apex classes: `force-app/main/default/classes/`
- Lightning Web Components: `force-app/main/default/lwc/`
- Static resources: `force-app/main/default/staticresources/`

### 3. Deploy to Your Scratch Org

```bash
# Deploy all changes
cci task run deploy --org dev

# Or deploy specific path
cci task run deploy --path force-app/main/default/lwc/summitEventsQrCheckin --org dev
```

### 4. Test Your Changes

```bash
# Run Apex tests
cci task run run_tests --org dev

# Required: 75% code coverage minimum
```

### 5. Write/Update Tests

- Apex tests in `summitEventsCheckin_TEST.cls`
- Jest tests in `force-app/main/default/lwc/summitEventsQrCheckin/__tests__/`

### 6. Update Documentation

Update relevant documentation in `docs/`:
- User-facing changes: Update `USER-GUIDE.md`
- Technical changes: Update `ARCHITECTURE.md`
- New features: Update `README.md`
- Breaking changes: Create/update release notes

---

## Code Standards

### Apex
- Follow [Salesforce Apex Style Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- All public methods must have Javadoc comments
- Maintain 75%+ test coverage
- Use meaningful variable names
- Handle exceptions appropriately

### Lightning Web Components
- Follow [LWC Best Practices](https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.best_practices)
- Use semantic HTML
- Implement ARIA attributes for accessibility
- Use SLDS (Salesforce Lightning Design System)
- Minimize @api properties
- Document complex methods with JSDoc

### Testing
- **Apex:** Test both positive and negative scenarios
- **LWC:** Use Jest for unit tests
- **Integration:** Test with Summit Events App dependency
- Maintain or improve test coverage

---

## Dependency Management

### Summit Events App Dependency

This component depends on the [Summit Events App](https://github.com/SFDO-Community/Summit-Events-App). CumulusCI automatically manages this dependency.

**Defined in `cumulusci.yml`:**
```yaml
dependencies:
  - github: 'https://github.com/SFDO-Community/Summit-Events-App.git'
```

### Testing with Dependencies

Always test with the Summit Events App installed:

```bash
# CumulusCI handles this automatically
cci flow run dev_org --org dev

# To test with specific dependency version (if needed)
# Edit cumulusci.yml dependencies section
```

### If You Need to Update Dependencies

1. Update `cumulusci.yml`
2. Test in scratch org
3. Document changes in PR description

---

## Lightning Web Security (LWS)

The component supports both Locker Service and Lightning Web Security.

### Testing with LWS

```bash
# 1. Create scratch org
cci flow run dev_org --org dev

# 2. Enable LWS
cci org browser dev
# Setup → Session Settings → Enable LWS

# 3. Test camera scanning
# Component → Start Scanning Session → Scan with Camera
```

### Testing without LWS

```bash
# Create org (LWS disabled by default in scratch orgs)
cci flow run dev_org --org dev

# Test fallback methods:
# - Manual search should work
# - Error messages should be helpful
# - No broken functionality
```

---

## Pull Request Process

### 1. Before Submitting

- ✅ Code compiles without errors
- ✅ All tests pass (75%+ coverage)
- ✅ Documentation updated
- ✅ Tested in scratch org
- ✅ Tested with LWS enabled
- ✅ Tested with LWS disabled
- ✅ No console errors

### 2. PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested in scratch org with CumulusCI
- [ ] All Apex tests pass (75%+ coverage)
- [ ] Tested with LWS enabled
- [ ] Tested with LWS disabled
- [ ] Manual testing completed

## Dependencies
- [ ] No dependency changes
- [ ] Summit Events App dependency updated (explain why)
- [ ] New dependencies added (list them)

## Documentation
- [ ] User Guide updated
- [ ] Architecture doc updated
- [ ] README updated
- [ ] Release notes updated (if applicable)

## Screenshots (if UI changes)
[Add screenshots here]
```

### 3. Review Process

- Maintainers will review your PR
- Address review comments
- Keep PR focused (one feature/fix per PR)
- Squash commits before merge (if requested)

---

## Testing Requirements

### Apex Tests

```bash
# Run all tests
cci task run run_tests --org dev

# View coverage report
cat test_results.xml
```

**Requirements:**
- 75% minimum code coverage
- All tests must pass
- Test both success and error cases

### Jest Tests (LWC)

```bash
# Run Jest tests
npm test

# Or run specific test
npm test -- summitEventsQrCheckin
```

### Manual Testing Checklist

- [ ] Camera scanning (with LWS)
- [ ] Camera error message (without LWS)
- [ ] Manual search by first name
- [ ] Manual search by last name
- [ ] Manual search by email
- [ ] Pagination (if >5 results)
- [ ] Check-in confirmation
- [ ] Undo check-in
- [ ] Session start/stop/reset
- [ ] Counters update correctly
- [ ] Mobile app scanner (if possible)
- [ ] USB scanner input (if available)

---

## CumulusCI Workflow

### Common Development Tasks

```bash
# Create new scratch org
cci flow run dev_org --org dev

# Deploy changes
cci task run deploy --org dev

# Run tests
cci task run run_tests --org dev

# Open org
cci org browser dev

# View org info
cci org info dev

# Delete org
cci org scratch_delete dev
```

### Custom Tasks

The project includes custom CumulusCI tasks:

```bash
# Enable Summit Events namespace checkbox
cci task run check_namespace_box --org dev

# Create sample school data
cci task run create_fake_school_data --org dev

# Assign guest user permissions
cci task run deploy_custom_guest_permission_set --org dev
```

### Adding New Tasks

To add a custom task:

1. Edit `cumulusci.yml`
2. Add task definition under `tasks:`
3. Test the task
4. Document in PR

---

## Documentation Standards

### When to Update Documentation

- **User Guide:** Any change to UI or user workflow
- **Architecture:** Technical changes, new classes, new integrations
- **README:** New features, requirements changes
- **Developer Setup:** CumulusCI changes, new tasks/flows
- **LWS Guide:** Changes to camera functionality

### Documentation Format

- Use Markdown
- Include code examples where relevant
- Add screenshots for UI changes (in `docs/images/`)
- Use clear, concise language
- Include troubleshooting tips

---

## Release Process

Releases are managed by project maintainers.

### Version Numbering

- **Major:** Breaking changes (v1.0.0 → v2.0.0)
- **Minor:** New features (v1.0.0 → v1.1.0)
- **Patch:** Bug fixes (v1.0.0 → v1.0.1)

### Release Checklist (Maintainers)

- [ ] All tests pass
- [ ] Documentation updated
- [ ] Release notes created
- [ ] Package version created
- [ ] GitHub release created
- [ ] AppExchange listing updated (if applicable)

---

## Getting Help

### Questions About Development

- Check [Developer Setup Guide](docs/DEVELOPER-SETUP.md)
- Review [Architecture Documentation](docs/ARCHITECTURE.md)
- Check CumulusCI docs: https://cumulusci.readthedocs.io/

### Questions About Features

- Check [User Guide](docs/USER-GUIDE.md)
- Check [Quick Start Guide](docs/QUICK-START.md)
- Review existing issues on GitHub

### Reporting Bugs

Create an issue with:
- Clear description
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)
- Salesforce version
- LWS enabled/disabled
- Browser/device information

---

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other contributors

---

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (check LICENSE file).

---

## Thank You! 🎉

Your contributions make this project better for everyone. Thank you for taking the time to contribute!

For more information, see:
- [Developer Setup Guide](docs/DEVELOPER-SETUP.md)
- [Architecture Documentation](docs/ARCHITECTURE.md)
- [User Guide](docs/USER-GUIDE.md)
et 