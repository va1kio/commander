⚠️ Under construction!
All source code hosted under this repository is under a large recode, if you plan to install Commander for your game, find the Releases section for the latest source code, or use the loader.

# Commander

[![CI](https://github.com/7kayoh/commander/actions/workflows/deploy.yml/badge.svg)](https://github.com/7kayoh/commander/actions/workflows/deploy.yml)

I liked the idea of Commander, but I never liked how I coded it, with that I am hugely unmotivated to code for Commander, and more errors and typos started to come out. While I've archived this project previously, I feel like I can at least improve the codebase one more time, and call it as the final release, I guess? Honestly, really depends.

Commander is an open sourced and community driven administration panel for your Roblox games' needs. Created and designed to be extremely flexible and customisable.

![commander banner](https://cdn.discordapp.com/attachments/813583766039560206/831496945604100136/Banner.png)

Visit our [documentation](https://commander-4.vercel.app) to learn more. If you have any questions about Commander, feel free to submit a new issue, or visit our Discord community at [here](https://7kayoh.github.io/commander-site/goto#discord).

## Documentation

If you want to learn more about Commander in the development side, visit our [documentation](https://commander-4.vercel.app), which includes API reference for packages and the UI library, tutorials on making packages, installing packages, installing themes and more. You can find the source code of the documentation [here](https://github.com/7kayoh/commander-site/tree/master/docs-src/v1)

## Installing

There's a few ways to install Commander. If you prefer working with the source code, consider using [Rojo](#Rojo). If you only want to install Commander, use the [loader](#Loader).

### Rojo

If you are syncing with Rojo, download the newest source code inside the Releases section, and then run the following command in your terminal application (Assume you are inside the folder of the source code)
```
rojo build -o "release.rbxlx"
```
And then, open `release.rbxlx` in Roblox Studio and start the Rojo server.
```
rojo serve
```

### Loader

For your convenience, we've also released Commander as a loader, which allows Commander to be always up-to-date and easier to manage. You can find the download link [here](https://www.roblox.com/library/6648688759/). Place the loader inside `ServerScriptService` for high maintainability and maximum security.

## Contributing

Commander adheres the Contributor Covenant [code of conduct](./CODE_OF_CONDUCT.md). By contributing, you are expected to uphold this project. Report any inappropriate behavior in our Discord server.

If you are creating your first time issue or pull request to this repository, consider reading our [contributing guidelines](./CONTRIBUTING.md).

Before starting to contribute, please clone this repository with command `git clone https://github.com/va1kio/commander.git` and install Commander with the [Rojo](#Rojo) method, which will allow you to do testing.

Once you have finished making changes to the codebase, please group changes and stage them one by one with a clear and descriptive commit message, and create a pull request.

## Credits

Commander is built with open sourced libraries and codes, a list of them can be found here:
- [Promise](https://github.com/evaera/roblox-lua-promise)
- [MockDataStore](https://github.com/buildthomas/MockDataStoreService)
- [Matcher](https://github.com/rgieseke/textredux/blob/main/util/matcher.lua)
- [Snapdragon](https://github.com/roblox-aurora/rbx-snapdragon)

## License
[MIT](./LICENSE)
