;;; xdg-redirect.el --- Redirect Emacs files to XDG directories  -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Francisco Miguel Colaço

;; Author: Francisco Miguel Colaço <francisco.colaco@gmail.com>
;; Maintainer: Francisco Miguel Colaço <francisco.colaco@gmail.com>
;; Version: 1.0.0
;; Package-Requires: ((emacs "27.1"))
;; URL: https://github.com/franciscocolaco/xdg-redirect
;; Keywords: convenience, files

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides utilities and macros to redirect Emacs package files
;; to XDG Base Directory specification paths (~/.local/share, ~/.cache, etc.).
;;
;; Usage:
;;
;; Obtain paths in XDG directories:
;;   (xdg-redirect-locate-cache-file "pkg-name/cache")
;;
;; Redirect variable values to XDG paths:
;;   (xdg-redirect-to-emacs-data some-package-data-file)

;;; Code:

(require 'xdg)

(defgroup xdg-redirect ()
  "Redirect Emacs files to XDG directories."
  :group 'convenience
  :prefix "xdg-redirect-")

(defcustom xdg-redirect-dirs-data-home
  (xdg-data-home)
  "The XDG data home directory."
  :type 'directory
  :group 'xdg-redirect)

(defcustom xdg-redirect-dirs-cache-home
  (xdg-cache-home)
  "The XDG cache home directory."
  :type 'directory
  :group 'xdg-redirect)

(defcustom xdg-redirect-dirs-config-home
  (xdg-config-home)
  "The XDG config home directory."
  :type 'directory
  :group 'xdg-redirect)

(defcustom xdg-redirect-dirs-runtime-home
  (or (getenv "XDG_RUNTIME_DIR")
      (expand-file-name ".run" (getenv "HOME")))
  "The XDG runtime home directory."
  :type 'directory
  :group 'xdg-redirect)

(defcustom xdg-redirect-directory-prefix "emacs"
  "Prefix directory name under XDG base paths."
  :type 'string
  :group 'xdg-redirect)

(defcustom xdg-redirect-data-directory
  (expand-file-name xdg-redirect-directory-prefix xdg-redirect-dirs-data-home)
  "The directory where Emacs packages store data files."
  :type 'directory
  :group 'xdg-redirect)

(defcustom xdg-redirect-config-directory
  (expand-file-name xdg-redirect-directory-prefix xdg-redirect-dirs-config-home)
  "The directory where Emacs packages store configuration files."
  :type 'directory
  :group 'xdg-redirect)

(defcustom xdg-redirect-cache-directory
  (expand-file-name xdg-redirect-directory-prefix xdg-redirect-dirs-cache-home)
  "The directory where Emacs packages store cache files."
  :type 'directory
  :group 'xdg-redirect)

(defcustom xdg-redirect-runtime-directory
  (expand-file-name xdg-redirect-directory-prefix xdg-redirect-dirs-runtime-home)
  "The directory where Emacs packages store runtime files."
  :type 'directory
  :group 'xdg-redirect)

;;;###autoload
(defun xdg-redirect-set-directory-prefix (prefix &optional update-dirs)
  "Set the PREFIX for XDG Emacs subdirectories.
If UPDATE-DIRS is non-nil, update active user directory variables."
  (setq xdg-redirect-directory-prefix prefix)
  (when update-dirs
    (setq xdg-redirect-data-directory (expand-file-name prefix xdg-redirect-dirs-data-home)
          xdg-redirect-config-directory (expand-file-name prefix xdg-redirect-dirs-config-home)
          xdg-redirect-cache-directory (expand-file-name prefix xdg-redirect-dirs-cache-home)
          xdg-redirect-runtime-directory (expand-file-name prefix xdg-redirect-dirs-runtime-home))))

;;;###autoload
(defun xdg-redirect-locate-file (filename &optional dir)
  "Locate FILENAME in DIR, defaulting to `xdg-redirect-data-directory'."
  (declare (side-effect-free t))
  (expand-file-name filename (or dir xdg-redirect-data-directory)))

;;;###autoload
(defun xdg-redirect-locate-cache-file (filename)
  "Locate FILENAME in `xdg-redirect-cache-directory'."
  (declare (side-effect-free t))
  (xdg-redirect-locate-file filename xdg-redirect-cache-directory))

;;;###autoload
(defun xdg-redirect-locate-data-file (filename)
  "Locate FILENAME in `xdg-redirect-data-directory'."
  (declare (side-effect-free t))
  (xdg-redirect-locate-file filename xdg-redirect-data-directory))

;;;###autoload
(defun xdg-redirect-locate-config-file (filename)
  "Locate FILENAME in `xdg-redirect-config-directory'."
  (declare (side-effect-free t))
  (xdg-redirect-locate-file filename xdg-redirect-config-directory))

;;;###autoload
(defun xdg-redirect-locate-runtime-file (filename)
  "Locate FILENAME in `xdg-redirect-runtime-directory'."
  (declare (side-effect-free t))
  (xdg-redirect-locate-file filename xdg-redirect-runtime-directory))

(defun xdg-redirect--get-user-dir (user-dir-type)
  "Return target directory for USER-DIR-TYPE symbol."
  (declare (side-effect-free t))
  (pcase user-dir-type
    ('data xdg-redirect-data-directory)
    ('cache xdg-redirect-cache-directory)
    ('config xdg-redirect-config-directory)
    ('runtime xdg-redirect-runtime-directory)
    (_ (error "Invalid user directory type: %s" user-dir-type))))

;;;###autoload
(defun xdg-redirect-file (user-dir-type file)
  "Redirect FILE path relative to USER-DIR-TYPE XDG location."
  (declare (side-effect-free t))
  (let* ((user-dir (xdg-redirect--get-user-dir user-dir-type))
         (abs-user-dir (expand-file-name user-dir))
         (abs-file (expand-file-name file)))
    (cond
     ((string-prefix-p abs-user-dir abs-file) file)
     ((string-prefix-p user-emacs-directory abs-file)
      (let ((rel-path (substring abs-file (length (expand-file-name user-emacs-directory)))))
        (expand-file-name rel-path abs-user-dir)))
     (t (expand-file-name file abs-user-dir)))))

;;;###autoload
(defmacro xdg-redirect (user-dir-type symbol)
  "Redirect variable SYMBOL path to USER-DIR-TYPE XDG location."
  (declare (indent 1))
  `(setq ,symbol (xdg-redirect-file ,user-dir-type ,symbol)))

;;;###autoload
(defmacro xdg-redirect-to-emacs-cache (symbol)
  "Redirect SYMBOL file path to `xdg-redirect-cache-directory'."
  `(xdg-redirect 'cache ,symbol))

;;;###autoload
(defmacro xdg-redirect-to-emacs-data (symbol)
  "Redirect SYMBOL file path to `xdg-redirect-data-directory'."
  `(xdg-redirect 'data ,symbol))

;;;###autoload
(defmacro xdg-redirect-to-emacs-config (symbol)
  "Redirect SYMBOL file path to `xdg-redirect-config-directory'."
  `(xdg-redirect 'config ,symbol))

;;;###autoload
(defmacro xdg-redirect-to-emacs-runtime (symbol)
  "Redirect SYMBOL file path to `xdg-redirect-runtime-directory'."
  `(xdg-redirect 'runtime ,symbol))

;; Convenience aliases
(defalias 'locate-user-emacs-cache-file #'xdg-redirect-locate-cache-file)
(defalias 'locate-user-emacs-data-file #'xdg-redirect-locate-data-file)
(defalias 'locate-user-emacs-config-file #'xdg-redirect-locate-config-file)
(defalias 'locate-user-emacs-runtime-file #'xdg-redirect-locate-runtime-file)

(provide 'xdg-redirect)
;;; xdg-redirect.el ends here
