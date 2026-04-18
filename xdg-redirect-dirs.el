;;; xdg-redirect-dirs.el --- Directories to redirect files from Emacs packages  -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Francisco Miguel Colaço

;; Author: Francisco Miguel Colaço <francisco.colaco@gmail.com>
;; Version: 1.0.0
;; Package-Requires: ((emacs "27.1"))
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

;; This package defines the base directories used for redirecting Emacs files,
;; adhering to the XDG Base Directory Specification.  It establishes variables
;; for data, cache, configuration, and runtime directories, allowing for
;; a cleaner home directory and better organization of Emacs-related files.

;;; Code:


(defgroup xdg-redirect-dirs ()
  "Directories to redirect files from Emacs packages."
  :group 'xdg-redirect)


(defcustom xdg-dirs-data-home
  (or (getenv "XDG_DATA_HOME")
      (expand-file-name ".local/share" (getenv "HOME")))
  "The XDG data home directory.

In this directory, applications should store data files."
  :group 'xdg-redirect-dirs)


(defcustom xdg-dirs-cache-home
  (or (getenv "XDG_CACHE_HOME")
      (expand-file-name ".cache" (getenv "HOME")))
  "The XDG cache home directory.

In this directory, applications should store cache files."
  :group 'xdg-redirect-dirs
  :type 'directory
  :tag "XDG cache home directory")


(defcustom xdg-dirs-config-home
  user-emacs-directory
  "The XDG config home directory.

In this directory, applications should store configuration files."
  :group 'xdg-redirect-dirs
  :type 'directory
  :tag "XDG config home directory")


(defcustom xdg-dirs-runtime-home
  (or (getenv "XDG_RUNTIME_DIR")
      (expand-file-name ".run" (getenv "HOME")))
  "The XDG runtime home directory.

In this directory, applications should store runtime files."
  :group 'xdg-redirect-dirs
  :type 'directory
  :tag "XDG runtime home directory")


(defcustom user-emacs-directory-prefix "emacs"
  "The prefix to the directories."
  :group 'xdg-redirect-dirs
  :type 'directory
  :tag "Prefix for user directories.")


(defcustom user-emacs-data-directory
  (expand-file-name user-emacs-directory-prefix xdg-dirs-data-home)
  "The directory where Emacs packages should store data files."
  :group 'xdg-redirect-dirs
  :type 'directory
  :tag "User-Emacs data directory")


(defcustom user-emacs-config-directory
  (expand-file-name "config" xdg-dirs-config-home)
  "The directory where Emacs packages should store configuration files."
  :group 'xdg-redirect-dirs
  :type 'directory
  :tag "User Emacs config directory")


(defcustom user-emacs-cache-directory
  (expand-file-name user-emacs-directory-prefix xdg-dirs-cache-home)
  "The directory where Emacs packages should store cache files."
  :group 'xdg-redirect-dirs
  :type 'directory
  :tag "User Emacs cache directory")


(defcustom user-emacs-runtime-directory
  (expand-file-name user-emacs-directory-prefix xdg-dirs-runtime-home)
  "The directory where Emacs packages should store runtime files."
  :group 'xdg-redirect-dirs
  :type 'directory
  :tag "User Emacs runtime directory")


;;;###autoload
(defun user-emacs-set-directory-prefix (prefix &optional change-user-dirs)
  "Set the PREFIX for the user-emacs directory.

The prefix will also change the user-emacs directories if
CHANGE-USER-DIRS is non-nil.
"
  (setq user-emacs-directory-prefix prefix)
  (if (not (null change-user-dirs))
      (setq user-emacs-data-directory (expand-file-name user-emacs-directory-prefix xdg-dirs-data-home)
            user-emacs-cache-directory (expand-file-name user-emacs-directory-prefix xdg-dirs-cache-home)
            user-emacs-runtime-directory (expand-file-name user-emacs-directory-prefix xdg-dirs-runtime-home))))


(provide 'xdg-redirect-dirs)
;;; xdg-redirect-dirs.el ends here
