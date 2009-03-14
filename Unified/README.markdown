# Unified Build Tools

The Unified Tools are an abstraction layer over some common project tasks such as building or cleaning. It's designed so that Labs projects build with the same command regardless of what build system they're using internally. This might help eg automating builds, or switching build systems without rewriting other build scripts (so long that the new build system is supported by the Tools and the other build script was using $TOOLS/Unified/Build to build an app).

The Unified Tools consist of a number of commands (scripts) which accept standard flags. The meaning of these flags is mapped over the particular kind ("style", in Unified Tools parlance) of the project in an appropriate way. Extra flags may be available, depending on the project style; the standard flags are however always supported by all known styles.

## Standard Commands and Flags

### Build Styles

The standard commands refer to "build styles". A build style is a possible variant in the way the artifacts are built or behave; it is identified by a name (for example, "Debug" or "Release"). The names are up to the particular project style to specify.

Two kinds of build styles are provided by all project styles: a set of "debug" and a set of "release" styles. "Debug" styles produce items suitable for testing and diagnostics, while "release" styles produce items suitable for distribution to end users.

### `Build`

The `Build` command generates a project's artifacts starting from its source code. Its syntax is:

	$TOOLS/Unified/Build [<project root> [--flag [--flag...]]]
	
If no argument is specified, it is treated as a shorthand for `$TOOLS/Unified/Build . --all`. The `<project root>` is the root directory of the project to be built, and the following common flags are accepted:
	
* `--fast`, `-f`: Tries to build the artifacts as fast as possible, maybe sacrificing correctness. Usually, this means that existing build products and intermediate files will be reused without being cleaned if the build system thinks they're up-to-date. The default is to perform a build without sacrificing correctness in any way.

* `--style STYLE`, `-s STYLE`: Adds the specified build style to the ones being built. If more than one style is specified, then the build will produce artifacts in all of the given styles. (See below for more information about styles.)

* `--debug`, `-d`: Adds the 'debug' styles to the list of those being built. (These artifacts are usually suitable for testing or diagnostics.) Can be combined with `--style` or `--release` flags.

* `--release`, `-r`: Adds the 'release' styles to the list of those being built. (These artifacts are usually suitable for end users.) Can be combined with `--style` or `--debug` flags.

* `--all`, `-a`: Builds all common styles (which depend upon the project style). Supersedes all preceding `--style`, `--debug` or `--release` flags.

* `--local`, `-l`: Imports local settings. You can insert a script in `$TOOLS/Unified/$PROJECT_STYLE/BuildOptions-Local.bash` that will be executed if this flag is given. This is useful to provide "local" settings that do not apply to the project and may vary from build station to build station (eg those that specify local paths).

### `Clean`

The `Clean` commands deletes the artifacts produced by the `Build` command. Its syntax is:

	$TOOLS/Unified/Clean [<project root> [--flag [--flag...]]]
	
If no argument is specified, it is treated as a shorthand for `$TOOLS/Unified/Clean . --all`. The `Clean` command accepts the `--style`, `--debug`, `--release` and `--all` flags as the `Build` command, which cause it to remove only the artifacts pertaining to the given styles.

## Available Project Styles

### `Xcode`

The `Xcode` project style builds and cleans applications through the `xcodebuild` command-line tool. It expects the following:

 * The project root is the source root for the project and contains a single `*.xcodeproj` bundle.
 * The project has a target named the same as the `xcodeproj` bundle, which will be the one that will be built. (To build other targets, make them dependencies ofthis target.)

#### Build Styles

Build styles in Xcode-style projects correspond to Xcode build configurations found in the project. Adding a build style will build the project with that configuration.

* `--default` build style: builds the `Debug` configuration.
* `--release` build style: builds the `Release` configuration.

#### Fast Builds

Fast builds for Xcode-style projects do not clean the project before building. Regular builds will clean the project and build it immediately afterwards for each configuration.

#### Additional `Build` Flags

The following flags are understood by `Build` while operating upon an Xcode-style project:

* `--xcode-setting NAME=VALUE`: Passes a build setting to `xcodebuild`. This setting will be passed for all build styles. (Use multiple `Build` invocations if you want to pass different settings to different styles.)

### `iPhone`

The `iPhone` project style is a variant of the `Xcode` project style, which builds iPhone applications from Xcode project files through the `xcodebuild` command-line tool. It has the same expectations as the `Xcode` style above.

#### Build Styles

The build styles work just like in the `Xcode` project style, except that "Debug", "Ad Hoc" and "App Store" configurations are treated especially. Also:

* `--debug` built style: builds the `Debug` configuration.
* `--release` build style: builds the `Ad Hoc` and `App Store` configurations.

Some extra flags only affect the above build styles. See below for more information.

#### Fast Builds

Just like for Xcode-style projects, iPhone-style projects do not clean the project before building. Regular builds will clean the project and build it immediately afterwards for each configuration.

#### Additional `Build` Flags

The following flags are understood by `Build` while operating upon an iPhone-style project:

* `--xcode-setting NAME=VALUE`: Passes a build setting to `xcodebuild`. This setting will be passed for all build styles, just like in Xcode-style projects.

* `--iphone-development-identity CERTIFICATE`: Uses this certificate name as the code signing identity when building with the `Debug` configuration.

* `--iphone-distribution-identity CERTIFICATE`: Uses this certificate name as the code signing identity when building with the `App Store` and `Ad Hoc` configurations.

* `--iphone-development-profile UUID`: Uses this provisioning profile when building with the `Debug` configuration.

* `--iphone-app-store-profile UUID`: Uses this provisioning profile when building with the `App Store` configuration.

* `--iphone-ad-hoc-profile UUID`: Uses this provisioning profile when building with the `Ad Hoc` configuration.

* `--iphone-ad-hoc`: builds the `Ad Hoc` configuration.

* `--iphone-app-store`: builds the `App Store` configuration.

To specify a profile, you need its UUID. Xcode and the iPhone Configuration Utility rename a profile to its UUID when copying it to the Library folder. You can examine the contents of a profile with a UUID name to find out what profile it is.
