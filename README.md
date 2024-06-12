# Sync-nvim

## What Is Sync?

`sync.nvim` is a plugin for making syncing with remote instances easier using `rsync`.

### Installation
Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "wbjin/sync-nvim",
    config = function()
        require("sync").setup()
    end,
}
```

### Usage

#### Set local directory to source from
```lua
:SyncInit
```
will make a config file in .nvim/config.lua in the root directory of your project
```lua
return {
  dest_path = ".",
  local_path = "",
  remote = "",
  includes = {"LICENSE", "lua/sync/init.lua"},
}
```
The default destination path is the root of your remote and the default local path is the root of your project.

#### Sync
```lua
:Sync
```
will call rsync and sync the remote with the local path provided

```lua
<leader>rs
```
is the default mapping for calling Sync

### SyncInit
```lua
:SyncInclude
```
will call rsync only for the files and directories specified in the `includes` list and sync the remote with the local path provided



