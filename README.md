# xdg-redirect

`xdg-redirect` is an Emacs Lisp package to redirect variables (normally package
file or directories) to directories comforming to the XDG Base Directory specification.

## Installation

Add this drectory to your `load-path` and load the package:

```elisp
(add-to-list 'load-path "/path/to/xdg-redirect")
(require 'xdg-redirect)
```

## Usage

### Archive path redirection

Use the location functions to redirect the creation of archives by emacs
packages.


```elisp
(setq custom-file (locate-user-emacs-config-file "custom.el"))
```

### Redirecting of variables containing file paths

Use the redirection macro to redirect a project file to one of the XDG
specialised directories.  For instance, to redirect project-list-file under
’~/.local/share/’ use:

```elisp
(xdg-redirect-to-emacs-data project-list-file)
```

This will return nothing, so you do not need to assign a returning value to
the original variable.

## Licence

GPLV3+
