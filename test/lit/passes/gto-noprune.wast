;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt %s -all --gto         -S --closed-world -o - | filecheck %s --check-prefix PRUNING
;; RUN: wasm-opt %s -all --gto-noprune -S --closed-world -o - | filecheck %s --check-prefix NOPRUNE

;; The struct here has two fields that can become immutable, and one of them
;; can be pruned. In --gto-noprune we will not prune. In both of them we will
;; turn the field(s) to be immutable.

(module
  ;; PRUNE:      (rec
  ;; PRUNE-NEXT:  (type $struct (struct (field funcref)))
  ;; NOPRN:      (rec
  ;; NOPRN-NEXT:  (type $struct (struct (field funcref) (field funcref)))
  ;; PRUNING:      (rec
  ;; PRUNING-NEXT:  (type $struct (struct (field funcref)))
  ;; NOPRUNE:      (rec
  ;; NOPRUNE-NEXT:  (type $struct (struct (field funcref) (field funcref)))
  (type $struct (struct (field (mut funcref)) (field (mut funcref))))

  ;; PRUNE:       (type $ref|$struct|_=>_none (func (param (ref $struct))))

  ;; PRUNE:      (func $func (type $ref|$struct|_=>_none) (param $x (ref $struct))
  ;; PRUNE-NEXT:  (drop
  ;; PRUNE-NEXT:   (struct.new $struct
  ;; PRUNE-NEXT:    (ref.null nofunc)
  ;; PRUNE-NEXT:   )
  ;; PRUNE-NEXT:  )
  ;; PRUNE-NEXT:  (drop
  ;; PRUNE-NEXT:   (struct.get $struct 0
  ;; PRUNE-NEXT:    (local.get $x)
  ;; PRUNE-NEXT:   )
  ;; PRUNE-NEXT:  )
  ;; PRUNE-NEXT: )
  ;; NOPRN:       (type $ref|$struct|_=>_none (func (param (ref $struct))))

  ;; NOPRN:      (func $func (type $ref|$struct|_=>_none) (param $x (ref $struct))
  ;; NOPRN-NEXT:  (drop
  ;; NOPRN-NEXT:   (struct.new $struct
  ;; NOPRN-NEXT:    (ref.null nofunc)
  ;; NOPRN-NEXT:    (ref.null nofunc)
  ;; NOPRN-NEXT:   )
  ;; NOPRN-NEXT:  )
  ;; NOPRN-NEXT:  (drop
  ;; NOPRN-NEXT:   (struct.get $struct 0
  ;; NOPRN-NEXT:    (local.get $x)
  ;; NOPRN-NEXT:   )
  ;; NOPRN-NEXT:  )
  ;; NOPRN-NEXT: )
  ;; PRUNING:       (type $ref|$struct|_=>_none (func (param (ref $struct))))

  ;; PRUNING:      (func $func (type $ref|$struct|_=>_none) (param $x (ref $struct))
  ;; PRUNING-NEXT:  (drop
  ;; PRUNING-NEXT:   (struct.new $struct
  ;; PRUNING-NEXT:    (ref.null nofunc)
  ;; PRUNING-NEXT:   )
  ;; PRUNING-NEXT:  )
  ;; PRUNING-NEXT:  (drop
  ;; PRUNING-NEXT:   (struct.get $struct 0
  ;; PRUNING-NEXT:    (local.get $x)
  ;; PRUNING-NEXT:   )
  ;; PRUNING-NEXT:  )
  ;; PRUNING-NEXT: )
  ;; NOPRUNE:       (type $ref|$struct|_=>_none (func (param (ref $struct))))

  ;; NOPRUNE:      (func $func (type $ref|$struct|_=>_none) (param $x (ref $struct))
  ;; NOPRUNE-NEXT:  (drop
  ;; NOPRUNE-NEXT:   (struct.new $struct
  ;; NOPRUNE-NEXT:    (ref.null nofunc)
  ;; NOPRUNE-NEXT:    (ref.null nofunc)
  ;; NOPRUNE-NEXT:   )
  ;; NOPRUNE-NEXT:  )
  ;; NOPRUNE-NEXT:  (drop
  ;; NOPRUNE-NEXT:   (struct.get $struct 0
  ;; NOPRUNE-NEXT:    (local.get $x)
  ;; NOPRUNE-NEXT:   )
  ;; NOPRUNE-NEXT:  )
  ;; NOPRUNE-NEXT: )
  (func $func (param $x (ref $struct))
    ;; No writes to either field aside from the struct.new, so they can both be
    ;; immutable.
    (drop
      (struct.new $struct
        (ref.null func)
        (ref.null func)
      )
    )
    ;; Read the first field, but not the second, so the second can be pruned in
    ;; principle.
    (drop
      (struct.get $struct 0
        (local.get $x)
      )
    )
  )
)
