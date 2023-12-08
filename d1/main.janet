(def consts {"threeight" 38 "zerone" 01 "oneight" 18 "twone" 21 "fiveight" 58
             "sevenine" 79 "eightwo" 82 "eighthree" 83 "nineight" 98 "zero" 0
             "one" 1 "two" 2 "three" 3 "four" 4 "five" 5 "six" 6 "seven" 7
             "eight" 8 "nine" 9})
(def longest-first (sorted (keys consts) (fn [a b] (> (length a) (length b)))))
(defn first-and-last [s] (-> (string (string/slice s 0 1) (string/slice s -2))
                             scan-number))
(def p1 (peg/compile ~(/ (% (some (+ (number :d) :a))) ,first-and-last)))
(def p2 (peg/compile ~(/ (% (some (+ (/ (<- (+ ,;longest-first)) ,consts)
                                     (number :d) :a))) ,first-and-last)))
(def input (seq [line :in (file/lines stdin)] line))
(print (+ ;(map (fn [line] (0 (peg/match p1 line))) input)))
(print (+ ;(map (fn [line] (0 (peg/match p2 line))) input)))
