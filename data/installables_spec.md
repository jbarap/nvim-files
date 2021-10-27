# Installation spec

## Limitations

System installed executables need to be installed manually. This is to avoid any unwanted
side-effects due to `sudo` permissions required to install these packages.

Required:
- curl
- git
- pip3
- go
- npm

Optional, but recommended:
- ripgrep: https://github.com/BurntSushi/ripgrep
  `brew install ripgrep`, `choco install ripgrep`, or `sudo apt-get install ripgrep`
- fd: https://github.com/sharkdp/fd
  `apt install fd-find`, `brew install fd`, `choco install fd`


## installables.json

The `installables.json` file contains instructions and paths for installing executables.

The main keys are:
- installables: Contains every installable and the instructions.
- paths: Installation path for each medium.
- requirements: Previous executables that should be available in PATH before running the installer.


## Installables

Each installable is identified with a name and can contain the following keys:
- cmd: The command used to invoke this installable from the command line.
- install_method: The installation method that will be used.
- hooks: Scripts to be executed as `./script_name.extention`, each script must be executable.

Parameterized values:
- Any value in `installables.json` can contain parameters.
- A value that contains parameters can be defined by a table with the key `with_params`.
- The `with_params` key can then have a string with the special sequence of `{some-param}`
- The only parameter supported currently is the `os_param`.
  - Values for each os are specified in the key `os_param` within that same table.
- An example of a value with parameters is:
```json
{
    "with_params": "this/is/a/parameterized/path/{os_param}",
    "os_param": {
        "windows": "win_something",
        "linux": "lin_something",
        "mac": "mac_something"
    }
}
```


### Install methods 

Keys:
- name (required)
- version (optional, latest if ommitted)

Methods:
- go: use go package manager
  - name: name of the package
  - version: package version

- pip: use pip package manager
  - name: name of the package
  - version: package version

- npm: use npm package manager
  - name: name of the package
  - version: package version

- github_repo: clone a github repository
  - name: name of the repo in the form {author}/{repo_name}
  - version: commit hash to be cloned

- github_releases: download a github release Asset
  - name: name of the repo in the form {author}/{repo_name}/{release_pattern}
  - version: tag to be downloaded

Note: for all methods we need to specify the binary location. For example, for pip it's
going to be something like path/to/env/bin/executable


### Hooks

- before_download
- after_download
- before_install
- after_install


### For curl

github_releases:

- `curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/denoland/deno/releases/latest`
- parse through the json's "assets" key if it gets a valid response
- filter based on the "name" key
- check "content_type" to see if it's a zip or exe
- get the download link with "browser_download_url"
- `curl -LO https://github.com/denoland/deno/releases/download/v1.15.3/deno-x86_64-unknown-linux-gnu.zip`
- unzip if necessary
- chmod if necessary
- cleanup if necessary


sumneko lua hack (as per nvim-lsp-installer):

- Download the github release file at: https://github.com/sumneko/vscode-lua/releases
- Unzip the file `unzip something.vsix` into its own directory (because it contains a few things)
- The executable is at: `some_dir/extensions/server/bin/{Linux/macOS/Windows}/lua-language-server`
- So, lspconfig's cmd should be (I think I should .resolve() this path):
`some_dir/extensions/server/bin/Linux/lua-language-server -E some_dir/extensions/server/main.lua`




## Maybe?

- Translate installables.json into a lua file
  - My guess is that if we have to read the file every time that nvim is started in every
    place where paths and cmds are needed, the startup time is going to suffer a lot.
  - A proposal is to translate the file into a .lua file every time it changes, so we can just `require` at
    any point, that way it's going to be compiled and cached.
  - This would really be an ideal solution, but if it proves to be difficult, we can just
    pseudo-hardcode paths and executable names into nvim's config
  - installables.json has some logic in it (such as optional os_params), maybe during
    translation we can simplify this to an os-specific table that is much easier to use
    by lua, without needing to apply any logic

- Update versions
  - Have a function that will update installables to the latest version

- Manage versions
  - Structure the whole project so that each executable version has its own directory
  - Maybe control which versions are currently being used by nvim by having a "current_versions"
    key in the json file.
    - This implies getting the version of each package downloaded
      - Of github it will probably be easy
  - Have an "update" function that will overwrite the current version directories
    - Parameters of which installable(s) you would like to update
    - Maybe show diff commits like packer?


curl -L url --output name
