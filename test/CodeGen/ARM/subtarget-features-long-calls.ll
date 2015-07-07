; RUN: llc -march arm -mcpu cortex-a8 -relocation-model=static %s -o - | FileCheck -check-prefix=NO-OPTION %s
; RUN: llc -march arm -mcpu cortex-a8 -relocation-model=static %s -o - -mattr=+long-calls | FileCheck -check-prefix=LONGCALL %s
; RUN: llc -march arm -mcpu cortex-a8 -relocation-model=static %s -o - -mattr=-long-calls | FileCheck -check-prefix=NO-LONGCALL %s
; RUN: llc -march arm -mcpu cortex-a8 -relocation-model=static %s -o - -O0 | FileCheck -check-prefix=NO-OPTION %s
; RUN: llc -march arm -mcpu cortex-a8 -relocation-model=static %s -o - -O0 -mattr=+long-calls | FileCheck -check-prefix=LONGCALL %s
; RUN: llc -march arm -mcpu cortex-a8 -relocation-model=static %s -o - -O0 -mattr=-long-calls | FileCheck -check-prefix=NO-LONGCALL %s

; NO-OPTION-LABEL: {{_?}}caller0
; NO-OPTION: blx {{r[0-9]+}}

; LONGCALL-LABEL: {{_?}}caller0
; LONGCALL: blx {{r[0-9]+}}

; NO-LONGCALL-LABEL: {{_?}}caller0
; NO-LONGCALL: bl {{_?}}callee0

define i32 @caller0() #0 {
entry:
  tail call void @callee0()
  ret i32 0
}

; NO-OPTION-LABEL: {{_?}}caller1
; NO-OPTION: bl {{_?}}callee0

; LONGCALL-LABEL: {{_?}}caller1
; LONGCALL: blx {{r[0-9]+}}

; NO-LONGCALL-LABEL: {{_?}}caller1
; NO-LONGCALL: bl {{_?}}callee0

define i32 @caller1() {
entry:
  tail call void @callee0()
  ret i32 0
}

declare void @callee0()

attributes #0 = { "target-features"="+long-calls" }
