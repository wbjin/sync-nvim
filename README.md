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
:SyncSetLocal
```
will prompt you with
```lua
path: 
```
which should be an absolute path to the directory to source from.

#### Set destination ssh
```lua
:SyncSetDest
```
will prompt you with
```lua
ssh: 
```
which should be the destination machine

#### Set destination directory path
```lua
:SyncSetDestPath
```
will prompt you with
```lua
path: 
```
which should be the path to directory on the remote to send to. Don't enter anything if destination directory is the remote's root directory.

#### Set all
```lua
:SyncSetAll
```
will allow you to set everything at once.

#### Sync
```lua
:Sync
```
will call rsync and sync the remote with the local path provided

```lua
<leader>rs
```
is the default mapping for calling Sync

