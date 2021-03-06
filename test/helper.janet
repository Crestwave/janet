# Helper code for running tests

(var num-tests-passed 0)
(var num-tests-run 0)
(var suite-num 0)
(var numchecks 0)

(defn assert [x e]
 (++ num-tests-run)
 (when x (++ num-tests-passed))
 (if x
   (do
     (when (= numchecks 25)
       (set numchecks 0)
       (print))
     (++ numchecks)
     (file/write stdout "\e[32m✔\e[0m"))
   (do
     (file/write stdout "\n\e[31m✘\e[0m  ")
     (set numchecks 0)
     (print e)))
 x)

(defmacro assert-error
  [msg & forms]
  (def errsym (keyword (gensym)))
  ~(assert (= ,errsym (try (do ,;forms) ([_] ,errsym))) ,msg))

(defmacro assert-no-error
  [msg & forms]
  (def errsym (keyword (gensym)))
  ~(assert (not= ,errsym (try (do ,;forms) ([_] ,errsym))) ,msg))

(defn start-suite [x]
 (set suite-num x)
 (print "\nRunning test suite " x " tests...\n  "))

(defn end-suite []
 (print "\n\nTest suite " suite-num " finished.")
 (print num-tests-passed " of " num-tests-run " tests passed.\n")
 (if (not= num-tests-passed num-tests-run) (os/exit 1)))
