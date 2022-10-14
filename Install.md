---
title: "Install Doom"
date: 2022-10-05
modified: 2022-10-05
draft: true
---

# Install Guide

Run the following commands inside an admin terminal.

```ps1
# Step 1: Install Doom
$doomRoot="$HOME\AppData\Roaming\.emacs.d"
git clone --depth 1 https://github.com/doomemacs/doomemacs "$doomRoot"
Invoke-Expression "$doomRoot\bin\doom install"
```

```ps1
# Step 2: Sync your config
New-Item -Type SymbolicLink -Target "$HOME\Workspace\.config\.doom.d" -Path "$HOME\AppData\Roaming\.doom.d"
Invoke-Expression "$doomRoot\bin\doom sync"

```
