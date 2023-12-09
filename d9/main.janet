(def parse ~{:main (some (* :num (? " "))) :num (number (* (? "-") :d+))})
(defn diffs [xs] (seq [[i n] :in (pairs xs) :when (> i 0)] (- n (xs (- i 1)))))
(defn solve [xs] (if (every? (map |(= $ 0) xs)) [0 0]
                   (let [[l r] (solve (diffs xs))]
                     [(- (first xs) l) (+ (last xs) r)])))
(let [results (seq [l :in (file/lines stdin)] (solve (peg/match parse l)))]
  (pp [(+ ;(map last results)) (+ ;(map first results))]))
