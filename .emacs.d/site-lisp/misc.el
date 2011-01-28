(require 'url)

(defun my-browse-url (url)
  (interactive "sBrowse: ")
  (browse-url (concat "http://" url)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Commenting code from http://www.tenfoot.org.uk/emacs/snippets.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar comment-insert-block-on-empty-line nil
  "Whether to insert block comments on empty lines in comment-insert")

(defun comment-insert ()
  "Insert a new comment on current line"
  (interactive)
  (let ((empty-line (save-excursion (beginning-of-line) (looking-at "\\s-*$"))))
    (if (and (not (equal (point) (point-at-bol)))
             (save-excursion (backward-char) (looking-at "\\S-")))
        ;; insert space if immediately preceding char not whitespace
        (insert " "))
    (insert comment-start)
    (if (and empty-line comment-insert-block-on-empty-line)
        (comment-indent-new-line))
    (save-excursion
      (if (and empty-line comment-insert-block-on-empty-line)
          (insert-and-inherit ?\n))
      (insert comment-end)
      (indent-for-tab-command))
    (indent-for-tab-command)))


(defun comment-line-or-region (&optional comment-eol)
  "comment the region if active otherwise comment the current line"
  (interactive "P")
  (if mark-active
      ;; comment selection
      (comment-region (point) (mark))
    (if (or comment-eol
            (save-excursion (beginning-of-line) (looking-at "\\s-*$")))
        ;; insert comment at end of line
        (comment-insert)
      ;; comment whole line
      (comment-region (point-at-bol) (point-at-eol)))))

(defun uncomment-line-or-region ()
  "uncomment the region if active otherwise comment the current line"
  (interactive)
  (if mark-active
      (uncomment-region (point) (mark))
    (uncomment-region (point-at-bol) (point-at-eol))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; end-commenting code.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun block-site (site)
  "Blocks a site"
  (interactive "sPlease enter the site to block: ")
  (save-excursion
	(if (equal system-type 'windows-nt)
		(find-file "C:\\Windows\\system32\\drivers\\etc\\hosts")
	  (find-file "/sudo::/etc/hosts"))
	(if (eq (search-forward site nil t) nil)
		(progn
		  (goto-char (point-max))
		  (insert (concat "127.0.0.1\t\t" site))
		  (newline)
		  (insert (concat "127.0.0.1\t\twww." site))
		  (newline)
		  (save-buffer))
	  (print (concat "Site " site  " is already in hosts file")))
	(kill-buffer)))


(defun show-in-explorer ()
  "Show the parent directory of the current buffer in windows explorer"
  (interactive)
  (shell-command (concat "explorer.exe " (replace-regexp-in-string "/" "\\\\" (replace-regexp-in-string (buffer-name) "" (buffer-file-name))))))

	   
;; (replace-regexp-in-string ";" "" (replace-regexp-in-string "\\." "/" (cadr (split-string "import a.b.c;"))))
(defun switch-to-h-file ()
  "switch to corresponding .h/.cpp file"
  (interactive)
   (let	((filename (reverse (string-to-list (buffer-file-name)))))
	 (if (= (car filename) 112)
		 (find-file (concat (reverse (cons 104 (cdddr filename)))))
	   (if (= (car filename) 104)
		   (find-file (concat (reverse (append '(112 112 99) (cdr filename)))))
		 '()))))
   

(defun foldr (fn seed args)
  (if (equal args '()) 
	  seed
	(foldr fn (funcall fn (car args) seed) (cdr args))))


(defun get-arg-list (str)
  (let ((ls (foldr (lambda (x res)
		   (if (= x 59) 
			   (cons (+ 1 (car res)) res)
			 res)) 
		 (list 0) (string-to-list str))))
	(foldr (lambda (x res)
			 (concat (number-to-string x) "," res)) (number-to-string (car ls)) (cdr ls))))

;Generates well rendered diagrams from ascii art.
(setq ditaa-cmd "java -jar C:/apps/ditaa.jar -E")
(defun ditaa-generate ()
  (interactive)
  (shell-command
    (concat ditaa-cmd " " buffer-file-name)))

(defun grep-it (pattern)
  (interactive "sGrep for: ")
  (grep (concat " -nH -e " pattern "*"))) 

(defun recursive-grep (pattern)
  (interactive "sRecursive Grep for: ")
  (rgrep (concat "-nH -e " pattern " *")))

(defun indent-buffer ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil))

 
(defun char-lowercasep (c)
  (and (< c 123) (> c 96)))

(defun char-capitalp (c)
  (and (< c 91) (> c 64)))
	  
(defun decapitalize (str)
  "Opposite of capitalize function. If the first char is capital case, it will be converted to lower case."
  (let ((ls (string-to-list str)))
	(if (char-capitalp (car ls))
		(concat (cons (+ (car ls) 32) (cdr ls)))
	  str)))

(defun decamelify-char (c)
  (if (char-capitalp c)
	  (concat "_" (char-to-string c))
	(if (char-lowercasep c)
		(char-to-string (- c 32))
	  (char-to-string c))))

(defun decamelify-label (str)
  (apply #'concat (mapcar #'decamelify-char (string-to-list (decapitalize str)))))

(defun decamelify-labels  ()
  "Decamelify all labels(string which end with colon)"
  (interactive)
  (let (cb label)
  (with-current-buffer cb
	(setq label (search-forward ":"))) 
	  label))

(defun jad ()
  "Run java disassembler on the current buffer"
  (shell-command jad (buffer-file-name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Close all emacs buffers ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;;;;;;;;;;;;;;;;;;;;;;;;
;; Xahs documentation ;;
;;;;;;;;;;;;;;;;;;;;;;;;
(setq xah-doc-location "C:/Docume~1/QA_Testing/Desktop/xah_emacs_tutorial/")

(defun xah-grep (xah-search)
  "Search for a key word in xah's documentation"
  (interactive "sxah-search:")
  (let ((results (concat temporary-file-directory "xah_results.html")))
	(start-file-process-shell-command  "Xah Grep" "Xah results" 
									   (concat "find "  xah-doc-location "| xargs grep -nHe " xah-search  " > " results))
	(pop-to-buffer "Xah results")
	(browse-url (concat "file:///" results))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; enough beauty, use chrome ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun browse-url-chrome(url &optional new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (let ((out-buf "*Messages*"))
	(start-process "chrome" out-buf "C:/Documents and Settings/QA_Testing/Local Settings/Application Data/Google/Chrome/Application/chrome.exe" url)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The beautiful Conkeror browser ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun browse-url-conkeror-browser (url &optional new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (let ((out-buf "*Messages*"))
	(start-process "conkeror" out-buf "C:/apps/xulrunner/conkeror.bat" url)
	(pop-to-buffer out-buf)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO: Implement clean function to delete all ~ and # files in the current dir ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun clean '())


;;;;;;;;;;;;;;
;; winmerge ;;
;;;;;;;;;;;;;;
(defun wdiff (buffer1 buffer2)
  (interactive "sbuffer1:\nsbuffer2:")
  (let ((tempdir "C:/WINDOWS/Temp/")
		(winmerge "C:/Program Files/WinMerge/WinMergeU.exe"))
	(let ((buf1 (get-buffer-create buffer1))
		  (buf2 (get-buffer-create buffer2))
		  (tempfile1 (buffer-file-name (get-buffer-create buffer1)))
		  (tempfile2 (buffer-file-name (get-buffer-create buffer2))))
	  (start-process "winmerge" nil winmerge tempfile1 tempfile2))))

;(setq browse-url-browser-function 'browse-url-conkeror-browser)
(setq browse-url-browser-function 'browse-url-chrome)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File name indexing															    ;;
;; The idea is to have a alphabetically sorted index read into memory persistently  ;;
;; as a list, and is resident in memory until emacs is active					    ;;
;; which can quickly locate the file's path										    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;A temp function used only with indexing,it compares two strings
;by the first word only
(defun string-less (a b)
  (string< (car (split-string a)) (car (split-string b))))

(defun gen-index()
  (interactive)
  (shell-command (concat "gen-index.bat " replay-root  " &")))

;; Grep syntax 
;; find C:/projects/replay_git | grep -E -v "\.class|\.svn|\.hg|\.git|Debug|Release|Master|bin" | grep -E "\.java|\.c|\.xml|\.properties" > C:/projects/replay_git/index

;; (defun gen-index (path)
;;   "Creates a file index with fullpaths for all the files"
;;   (defun list-files (dirname)
;; 	(defun sfxadder (sfxlist cmd) 
;; 	  (foldr (lambda(sfx) 
;; 			   (concat (cond (((equal system-type "darwin") "\\.")
;; 							  (t "."))) sfx)) 
;; 			   cmd
;; 			   sfxlist))
;; 	(let* ((ignore-suffix '("svn" "class" "hg" "Debug" "Release" "Master" "bin"))
;; 		   (include-suffix '("c" "h" "java" "xml" "properties"))
;; 		   (command (concat "find " 
;; 							dirname 
;; 							(sfxadder ignore-suffix " | grep -E -v ")
;; 							(sfxadder include-suffix " | grep -E ")
;; 							)))
;; 	  (with-temp-buffer
;; 		(shell-command  command (current-buffer))
;; 		(buffer-string))))
;;   (let ((index 
;; 		 (foldr (lambda (x str) (concat str (decapitalize (car (last (split-string x "/")))) "\t" x "\n"))
;; 				""   
;; 				(sort (split-string (list-files path) "\n") 'string-less)))
;; 		(target-file (concat path "/.emacs_index")))
;; 	(save-excursion
;; 	  (if (file-exists-p target-file)
;; 		  (delete-file target-file))
;; 	  (set-buffer (find-file target-file))
;; 	  (insert index)
;; 	  (save-buffer target-file)
;; 	  (kill-buffer)
;; 	  index)))

;; (defun set-current-index (path)
;;   "Read index from path and store it in memory as current-index"
;;   (let ((index-path (concat path "/.emacs_index")))
;; 	(setq current-index (let ((index
;; 							   (save-excursion
;; 								 (set-buffer (find-file index-path))
;; 								 (buffer-string))))
;; 						  (apply 'vector (split-string index "\n"))))))


;; ;Do a binary search on current-index and open the file by its path
;; (defun open-indexed-file (file)
;;   (interactive "sfilename:")
;;   "Open a file whose path is in the current index"
;;   (defun binary-search (key vec)
;; 	(defun helper (start end)
;; 	  (let ((mid (/ (+ start end) 2)))
;; 		(let ((key2 (car (split-string (aref vec mid)))))
;; 		  (cond ((string= key key2) (aref vec mid))
;; 				((= start end) nil)
;; 				((string< key key2) (helper start mid))
;; 				(t (helper mid end))))))
;; 	(helper 0 (length vec)))
;;   (let ((path (binary-search (decapitalize file) current-index)))
;; 	(if (equal path nil) nil
;; 	  (find-file (cadr (split-string path "\t"))))))


;(list-files "C:/projects/replay_polaris")
;(gen-index "/Users/ravi/Documents/test")
;(find-file "/Users/ravi/Documents/test/.emacs_index")
;(set-current-index "/Users/ravi/Documents/test")
;(open-indexed-file "VM_Assembler.java")


(defun open-fileline ()
  "Open a file from the path in the region"
  (interactive)
  (let ((filename (buffer-substring (line-beginning-position) (line-end-position))))
	(find-file filename)))
