;;; xdg-redirect.el --- Redirect Emacs files to XDG directories  -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Francisco Miguel Colaço

;; Author: Francisco Miguel Colaço <francisco.colaco@gmail.com>
;; Maintainer: Francisco Miguel Colaço <francisco.colaco@gmail.com>
;; Version: 1.0.0
;; Package-Requires: ((emacs "27.1"))
;; URL: https://github.com/franciscocolaco/xdg-redirect
;; Keywords: convenience

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

;; This package provides the logic and macros for redirecting Emacs files
;; to XDG-compliant directories.  By using the redirection functions and
;; macros provided here, packages can be configured to store their
;; persistence files (like history, bookmarks, or caches) outside of the
;; main Emacs configuration folder, typically under ~/.local/share,
;; ~/.cache, or /run/user.
;;
;; Usage:
;;
;; To obtain a path inside one of the XDG directories, use the
;; `locate-user-emacs-*-file' functions:
;;
;;   (setq my-cache (locate-user-emacs-cache-file "pkg-name/cache"))
;;
;; To redirect an existing variable containing a file path to its
;; corresponding XDG directory, use the `xdg-redirect-to-emacs-*' macros:
;;
;;   (xdg-redirect-to-emacs-data some-package-data-file)

;;; Code:

(defgroup xdg-redirect ()
  "Redirect Emacs files to XDG directories."
  :group 'convenience)


(require 'xdg-redirect-dirs)


;;;###autoload
(defun xdg-redirect-locate-file (filename &optional dir)
  "Locate FILENAME in the XDG directories.

The directory defaults to `user-emacs-data-directory'."
  (declare (side-effect-free t))
  (expand-file-name filename (or dir user-emacs-data-directory)))


;;;###autoload
(defun locate-user-emacs-cache-file (filename)
  "Locate FILENAME in the User Emacs cache directory."
  (declare (side-effect-free t))
  (xdg-redirect-locate-file filename user-emacs-cache-directory))


;;;###autoload
(defun locate-user-emacs-data-file (filename)
  "Locate FILENAME in the User Emacs data directory."
  (declare (side-effect-free t))
  (xdg-redirect-locate-file filename user-emacs-data-directory))


;;;###autoload
(defun locate-user-emacs-config-file (filename)
  "Locate FILENAME in the User Emacs configuration directory."
  (declare (side-effect-free t))
  (xdg-redirect-locate-file filename user-emacs-config-directory))


;;;###autoload
(defun locate-user-emacs-runtime-file (filename)
  "Locate FILENAME in the User Emacs runtime directory."
  (declare (side-effect-free t))
  (xdg-redirect-locate-file filename user-emacs-runtime-directory))


(defun xdg-redirect--get-user-dir (user-dir-type)
  "Get the XDG directory of type USER-DIR-TYPE."
  (declare (side-effect-free t))
  (pcase user-dir-type
    ('data user-emacs-data-directory)
    ('cache user-emacs-cache-directory)
    ('config user-emacs-config-directory)
    ('runtime user-emacs-runtime-directory)
    (_ (error "Invalid user directory type: %s" user-dir-type))))


;;;###autoload
(defun xdg-redirect-file (user-dir-type file)
  "Redirect FILE to the XDG directory of type USER-DIR-TYPE."
  (declare (side-effect-free t))
  (let* ((user-dir (xdg-redirect--get-user-dir user-dir-type))
         (absolute-user-dir (expand-file-name user-dir))
         (absolute-file (expand-file-name file)))
    (cond
     ((string-prefix-p absolute-user-dir absolute-file) file)
     ((string-prefix-p user-emacs-directory absolute-file)
      (let ((relative-pathname (substring absolute-file (length (expand-file-name user-emacs-directory)))))
        (expand-file-name relative-pathname absolute-user-dir)))
     (t (expand-file-name file absolute-user-dir)))))


;;;###autoload
(defmacro xdg-redirect (user-dir-type symbol)
  "Redefine the file path in SYMBOL to the XDG dir of type USER-DIR-TYPE."
  (declare (indent 2))
  `(setf ,symbol (xdg-redirect-file ,user-dir-type ,symbol)))


;;;###autoload
(defmacro xdg-redirect-to-emacs-cache (symbol)
  "Redefine the file path in SYMBOL to the `user-emacs-cache-directory'."
  `(xdg-redirect 'cache ,symbol))


;;;###autoload
(defmacro xdg-redirect-to-emacs-data (symbol)
  "Redefine the file path in SYMBOL to `user-emacs-data-directory'."
  `(xdg-redirect 'data ,symbol))


;;;###autoload
(defmacro xdg-redirect-to-emacs-config (symbol)
  "Redefine the file path in SYMBOL to `user-emacs-config-directory'."
  `(xdg-redirect 'config ,symbol))


;;;###autoload
(defmacro xdg-redirect-to-emacs-runtime (symbol)
  "Redefine the file path in SYMBOL to `user-emacs-runtime-directory'."
  `(xdg-redirect 'runtime ,symbol))


(provide 'xdg-redirect)
;;; xdg-redirect.el ends here
