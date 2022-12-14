;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --gsi      -all -S -o - | filecheck %s --check-prefix CHECK
;; RUN: foreach %s %t wasm-opt --nominal --gsi -tnh -all -S -o - | filecheck %s --check-prefix TNHPN

(module
  ;; CHECK:      (type $A (struct (field (mut i32))))
  (type $A (struct (field (mut i32))))

  ;; CHECK:      (type $ref|$A|_ref?|$A|_ref|any|_anyref_ref|eq|_eqref_=>_none (func (param (ref $A) (ref null $A) (ref any) anyref (ref eq) eqref)))

  ;; CHECK:      (global $A (ref $A) (struct.new $A
  ;; CHECK-NEXT:  (i32.const 1337)
  ;; CHECK-NEXT: ))
  (global $A (ref $A) (struct.new $A
    (i32.const 1337)
  ))

  ;; CHECK:      (func $func (type $ref|$A|_ref?|$A|_ref|any|_anyref_ref|eq|_eqref_=>_none) (param $A (ref $A)) (param $A-null (ref null $A)) (param $any (ref any)) (param $any-null anyref) (param $eq (ref eq)) (param $eq-null eqref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (global.get $A)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (select (result (ref null $A))
  ;; CHECK-NEXT:    (ref.null none)
  ;; CHECK-NEXT:    (global.get $A)
  ;; CHECK-NEXT:    (ref.is_null
  ;; CHECK-NEXT:     (local.get $A-null)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast $A
  ;; CHECK-NEXT:    (local.get $any)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast null $A
  ;; CHECK-NEXT:    (local.get $any-null)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (if (result (ref $A))
  ;; CHECK-NEXT:    (ref.eq
  ;; CHECK-NEXT:     (local.get $eq)
  ;; CHECK-NEXT:     (global.get $A)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (global.get $A)
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.cast null $A
  ;; CHECK-NEXT:    (local.get $eq-null)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $func
    (param $A (ref $A)) (param $A-null (ref null $A))
    (param $any (ref any)) (param $any-null (ref null any))
    (param $eq (ref eq)) (param $eq-null (ref null eq))

    ;; The only thing of type $A is the global, so we can use that information
    ;; to simplify some of these operations.

    ;; Input isn't null, and is of type $A, so it must be the global.
    (drop
      (ref.cast_static $A
        (local.get $A)
      )
    )
    ;; Input is either null or the global.    
    (drop
      (ref.cast_static $A
        (local.get $A-null)
      )
    )

    ;; Input is of type any, not even eq, so we can't do anything to these two.
    (drop
      (ref.cast_static $A
        (local.get $any)
      )
    )
    (drop
      (ref.cast_static $A
        (local.get $any-null)
      )
    )

    ;; Input is of type eq, so we can compare it to the global at least.
    (drop
      (ref.cast_static $A
        (local.get $eq)
      )
    )
    ;; Atm we do not optimize the case that needs both a type check and a null
    ;; check.
    (drop
      (ref.cast_static $A
        (local.get $eq-null)
      )
    )
  )
)
