# Contributing 101

👋🏻 Heyo! Thanks for helping us out with contributing to Commander! We really appericate it.

This document (CONTRIBUTING.md) includes guidelines, coding styleguides, resources and documentations related to contributing to Commander. Most of the content here are not fully required nor enforced strictly. If you happen to find one of them being misleading, or is not optimal enough. Feel free to propose changes by creating a pull request.

## Table of Contents
- [Code of Conduct](https://github.com/va1kio/commander/blob/main/CODE_OF_CONDUCT.md)
- [Contributing](#Contributing)
  * [Reporting a bug](#Reporting-a-bug)
  * [Patching a bug](#Patching-a-bug)
  * [Suggesting new features](#Suggesting-new-features)
  * [Others](#Others)
- [Coding convention](#Coding-convention)
- [Resources](#Resources)
  * [Documentation](https://commander-4.vercel.app)
  
## Contributing
### Reporting a bug
If you happened to discover a bug in Commander, please create a new issue in this repository, and include as many details as possible. We've created a template for creating issue, so if you happen to do not know what to include, you can simply answer the questions in the template.

#### Before submitting a bug report
- Consider doing a debug first, the problem you are encountering may not be caused by Commander, but caused by a third party package that is outdated, or simply a change to the codebase that you or someone unofficial has done.
- Check whether you are up-to-date, our latest version may have solved the problem you are encountering.
- Perform a search to see whether the problem has already been reported. If it has and is still open, add a comment to the existing issue instead of opening a new one.
- Consider reading the FAQs in our community server, your problem may not be a bug but an intentional feature that you've ignored.

#### Writing a good bug report
When writing a bug report, it is recommended to keep everything clear and easy to understand, so that our maintainers can easily understand the situation you are having right now. While our template has included starter questions for you to fill in. Readability may decrease when using an improper way to describe the situation, here is a list of guidelines when writing a bug report:

- Use a clear and descriptive title for the issue to identify the problem
- Include the steps to reproduce the problem with as many details as possible. For example, start by explaining how did you install Commander (Via require loader, or via source). While listing steps, do not repeat what you did to reproduce the problem but to explain how you did it.
- Provide specific examples to demonstrate the steps. Our maintainers may not be able to reproduce your problem with the steps only, if you happen to have a code snippet that will reproduce the problem. Please provide the snippet inside the issue and use [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
- Describe the behavior after following steps and point out what exactly is the problem with that behavior
- Include screenshots, animated GIFs or videos which show you following the described steps and clearly demostrated the problem. If you happen to use the keyboard while following the steps, please make sure you have enabled the keystroke recording option in your screen recorder (Example: Camtasia). To record a video or take a screenshot, you can use the `Win+G` key in Windows, and `Command+Shift+5` in macOS.
- If the problem is related to performance overhead, or memory leaks, please include a microprofiler log in your issue.

### Patching a bug
If you have managed to patch a bug you've discovered or reported in the issues list, please create a new pull request and follow the guidelines. We've created a template for you to fill in.

- Use a clear and simple title to identify your changes (Example: Patched 4 monkeys jumping around)
- Include the issue in your pull request, if the bug you have patched was previously reported
- Do **not** obfuscate code, this will lead to a denial of your pull request.

### Suggesting new features
- Check out our release note — you might discover that your suggested feature is already available.
- Check if there's already a package which contains your suggested feature
- Perform a search to see whether your suggested feature has already been suggested by others. If it has, add a comment to the existing issue instead of opening a new one.

### Others
#### Submitting pull request for cosmetic, formatting changes
Do **not** submit a pull request for cosmetic or code formatting changes, instead, create a new issue.

#### Proposing changes to the documentation
Our documentaton uses a different [repository](https://github.com/va1kio/commander-site). Before submitting a pull request, check whether your changes will not cause any sort of errors. We uses VuePress for documentation.

#### Something else
If none of your contribution falls under this document, please create an issue first.

## Coding convention
We uses Roblox's Lua Styleguide, visit it at [here](https://roblox.github.io/lua-style-guide/)

## Resources
* [Documentation](https://commander-4.vercel.app)
