(def parse-grid ~{:main (some :grid)
                  :grid (* (group (some :line)) (? "\n"))
                  :line (* (group (some (<- (+ "#" ".")))) "\n")})

(defn zip [a b] (seq [i :range-to [0 (- (min (length a) (length b)) 1)]]
                  [(a i) (b i)]))

(defn diff-seqs [a b] (-> (map |(= ;$) (zip a b)) frequencies false (or 0)))

(defn rotate-right [grid]
  (var g @[])
  (loop [row :in grid
         [x cell] :pairs row]
    (if (not (get g x)) (put g x @[]))
    (array/insert (get g x) 0 cell))
  g)

(defn find-mirrors [grid]
  (seq [y :in (range (length grid))
        :let [above-y (reverse (slice grid 0 y))
              below-y (slice grid y)
              pairs (zip above-y below-y)
              diffs (sum (map |(diff-seqs ;$) pairs))]
        :when (and (> (length pairs) 0))]
    {:row y :diffs diffs}))

(defn summarize [grids diff-count]
  (sum (seq [g :in grids
             mirror :in (find-mirrors g)
             :when (= (mirror :diffs) diff-count)
             :let [row (mirror :row)]] row)))

(def grids (peg/match parse-grid (file/read stdin :all)))

(pp (+ (summarize (map rotate-right grids) 0) (* 100 (summarize grids 0))))
(pp (+ (summarize (map rotate-right grids) 1) (* 100 (summarize grids 1))))
