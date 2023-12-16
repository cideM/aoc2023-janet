(def parse-grid ~{:main :grid :grid (* (group (some :row)) (? "\n"))
                  :row (* (group (some (<- (+ "." "|" "/" `\` "-")))) "\n")})

(defn in-grid? [grid [x y]]
  (every? [(>= y 0) (< y (length grid)) (>= x 0) (< x (length (0 grid)))]))

(def right [1 0]) (def up [0 -1]) (def left [-1 0]) (def down [0 1])

(def changes {"." {up [up] left [left] right [right] down [down]}
              "|" {left [down up] right [down up] up [up] down [down]}
              "-" {left [left] right [right] up [left right] down [left right]}
              `\` {right [down] left [up] up [left] down [right]}
              `/` {up [right] left [down] right [up] down [left]}})

(defn simulate [g beam]
  (def seen @{}) (def visited @{}) (def q @[beam])
  (loop [cur :iterate (get q 0)
         :while (> (length q) 0)
         :after (array/remove q 0)
         :when (and (not (seen cur)) (in-grid? g (cur :pos)))
         :let [{:pos [x y] :vec vec} cur
               tile ((g y) x)
               next (->> (get-in changes [tile vec])
                         (map |(let [[dx dy] $]
                                 {:pos [(+ x dx) (+ y dy)] :vec $})))]]
    (put visited (cur :pos) true) (put seen cur true)
    (each new-beam next (array/push q new-beam)))
  (length visited))

(def grid (0 (peg/match parse-grid (file/read stdin :all))))

(pp (simulate grid {:pos [0 0] :vec [1 0]}))

(def max-x (- (length (0 grid)) 1)) (def max-y (- (length grid) 1))
(def edge-beams
  (array/concat
    (mapcat |[{:pos [$ 0] :vec up}
              {:pos [$ max-x] :vec up}] (range (length (0 grid))))
    (mapcat |[{:pos [0 $] :vec right}
              {:pos [max-x $] :vec left}] (range (length grid)))))

(pp (max ;(seq [beam :in edge-beams] (simulate grid beam))))
