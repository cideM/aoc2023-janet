(defn gcd [a b] (if (= b 0) a (gcd b (% a b))))
(defn lcm [m n] (if (and (not (= m 0)) (not (= n 0))) (/ (* m n) (gcd m n))))
(def last-char (peg/compile ~(* :a :a (<- :a))))
(def parse (peg/compile
             ~{:main (* :dirs "\n" "\n" (group (some (* :instruction "\n"))))
               :dirs (group (some (+ :right :left)))
               :right (* "R" (constant :right))
               :left (* "L" (constant :left))
               :node (% (some (<- :a)))
               :instruction (group (* :node " = (" :node ", " :node ")"))}))
(def [directions instructions] (peg/match parse (file/read stdin :all)))
(def graph (merge ;(map (fn [[n l r]] @{n {:left l :right r}}) instructions)))
(defn solve [key instruction-pointer]
  (let [dir ((% instruction-pointer (length directions)) directions)
        next-key ((graph key) dir)]
    (if (= "Z" (0 (peg/match last-char key)))
      0
      (+ 1 (solve next-key (+ 1 instruction-pointer))))))
(pp (solve "AAA" 0))
(pp (reduce2 lcm (seq [key :in (keys graph)
                       :when (= "A" (0 (peg/match last-char key)))]
                   (solve key 0))))
