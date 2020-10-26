# Contributing to _BulletinBoard_

The following is a set of guidelines for contributing to _BulletinBoard_ on GitHub.

> Above all, thank you for your interest in the project and for taking the time to contribute! 👍

## I want to report a problem or ask a question

Before submitting a new GitHub issue, please make sure to

- Check out the [documentation](https://alexaubry.github.io/BulletinBoard).
- Read the usage guide on [the README](https://github.com/alexaubry/BulletinBoard/#usage).
- Search for [existing GitHub issues](https://github.com/alexaubry/BulletinBoard/issues).

If the above doesn't help, please [submit an issue](https://github.com/alexaubry/BulletinBoard/issues) on GitHub.

## I want to contribute to _BulletinBoard_

### Prerequisites

To develop _BulletinBoard_, you will need to use an Xcode version compatible with the Swift version specified in the [README](https://github.com/alexaubry/BulletinBoard/#requirements).

### Checking out the repository

We use gitflow for PRs. The `main` branch contains the state of the latest released version. `develop` contains the changes from the current unreleased state. You create your PRs againts the `develop` branch.

- Click the “Fork” button in the upper right corner of repo
- Clone your fork:
    - `git clone https://github.com/<YOUR_GITHUB_USERNAME>/BulletinBoard.git`
- Create a new branch to work on:
    - `git checkout -b <YOUR_BRANCH_NAME>`
    - A good name for a branch describes the thing you’ll be working on, e.g. `voice-over`, `fix-font-size`, etc.

That’s it! Now you’re ready to work on _BulletinBoard_. Open the `BulletinBoard.xcworkspace` workspace to start coding.

### Things to keep in mind

- Please do not change the minimum iOS version
- Always document new public methods and properties

### Testing your local changes

Before opening a pull request, please make sure your changes don't break things.

- The framework and example project should build without warnings
- The example project should run without issues.

### Submitting the PR

When the coding is done and you’ve finished testing your changes, you are ready to submit the PR to the [main repo](https://github.com/alexaubry/BulletinBoard), towards the `develop` branch. Some best practices are:

- Use a descriptive title
- Link the issues that are related to your PR in the body

After you open your PR, please update the CHANGELOG under the "Unreleased" tab with a link to your changes, under the appropriate section, and following this format:

```
- (Your changes, usually your PR title)
[#XXX](https://github.com/alexaubry/BulletinBoard/pulls/XXX)
```

The sections are:
- `### New Features`
- `### Changed Behavior`
- `### Fixes`

If you don't see the section under Unreleased, you can add it.

## Code of Conduct

Help us keep _BulletinBoard_ open and inclusive. Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.

_These contribution guidelines were adapted from [_fastlane_](https://github.com/fastlane/fastlane) guides._
