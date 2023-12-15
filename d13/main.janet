(def parse-grid ~{:main (some :grid)
                  :grid (* (group (some :line)) (? "\n"))
                  :line (* (group (some (<- (+ "#" ".")))) "\n")})

(defn zip [a b] (seq [i :in (range (min (length a) (length b)))] [(a i) (b i)]))

(defn diff-seqs [a b] (-> (map |(= ;$) (zip a b)) frequencies false (or 0)))

(defn rotate-right [grid]
  (var g @[]) (loop [row :in grid [x cell] :pairs row]
                (match (get g x)
                  nil (put g x @[cell])
                  _ (array/insert (get g x) 0 cell)))
  g)

(defn find-mirrors [grid]
  (seq [y :in (range (length grid)) :let [above-y (reverse (slice grid 0 y))
                                          below-y (slice grid y)]]
    {:row y :diffs (->> (zip above-y below-y) (map |(diff-seqs ;$)) sum)}))

(defn summarize [grids limit]
  (sum (seq [g :in grids m :in (find-mirrors g) :when (= (m :diffs) limit)]
         (m :row))))

(def grids (peg/match parse-grid (file/read stdin :all)))

(pp (+ (summarize (map rotate-right grids) 0) (* 100 (summarize grids 0))))
(pp (+ (summarize (map rotate-right grids) 1) (* 100 (summarize grids 1))))
