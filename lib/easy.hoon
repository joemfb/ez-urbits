::::    /hoon/easy/lib
  ::
/?    314
!:
::::    ~novlen-hanweb
  ::
|%
++  maybe-plural  (pair tape (unit tape))
++  dlists
  $:  intros/(list tape)
      ships/(set tape)
      verbs/(list maybe-plural)
      adjs/(list tape)
      nouns/(list maybe-plural)
      runes/(list maybe-plural)
      errs/(list tape)
  ==
++  rands
  $:  n/(trel @ @ @)
      a/(pair @ @)
      r/(pair @ @)
      en/@
      e/@
      i/@
      v/@
      s/@
  ==
--
|%
++  to-tang
  |=  l/(list tape)
  ^-  tang
  %+  turn  l
  |=(t/tape ^-(tank [%leaf t]))
::
++  get-json
  |=  {our/@p now/@da}
  :: .^(json %cx /=home/348/web/easy/json)
  .^  json
      %cx
      /(scot %p our)/home/(scot %da now)/web/easy/json
  ==
::
++  from-array
  |=  arr/json
  ^-  (list tape)
  ?>  ?=({$a *} arr)
  %+  turn  p.arr
  |=(s/* ?>(?=({$s *} s) (trip (@t +.s))))
::
++  from-nested-array
  |=  arr/json
  ^-  (list maybe-plural)
  ?>  ?=({$a *} arr)
  %+  turn  p.arr
  |=  x/json
  ^-  maybe-plural
  =+  l=(from-array x)
  ?>  ?=(^ l)
  :-  p=i.l
  q=?~(t.l ~ `(head t.l))
::
++  get-lists
  |=  dat/json
  ^-  dlists
  ?>  ?=({$o *} dat)
  =+  i=(from-array (need (~(get by p.dat) 'intros')))
  =+  s=(silt (from-array (need (~(get by p.dat) 'ships'))))
  =+  v=(from-nested-array (need (~(get by p.dat) 'verbs')))
  =+  a=(from-array (need (~(get by p.dat) 'adjectives')))
  =+  n=(from-nested-array (need (~(get by p.dat) 'nouns')))
  =+  r=(from-nested-array (need (~(get by p.dat) 'runes')))
  =+  e=(from-array (need (~(get by p.dat) 'errors')))
  [intros=i ships=s verbs=v adjs=a nouns=n runes=r errs=e]
::
++  get-rands
  |=  {eny/@uvI l/dlists}
  ^-  rands
  =+  ln=(lent nouns.l)
  =+  la=(lent adjs.l)
  =+  lr=(lent runes.l)
  =+  rng=~(. og eny)
  =^  n1  rng  (rads:rng ln)
  =^  n2  rng  (rads:rng ln)
  =^  n3  rng  (rads:rng ln)
  =^  a1  rng  (rads:rng la)
  =^  a2  rng  (rads:rng la)
  =^  r1  rng  (rads:rng lr)
  =^  r2  rng  (rads:rng lr)
  =^  en  rng  (rads:rng (lent errs.l))
  =^  e  rng  (rads:rng 10)
  =^  i  rng  (rads:rng (lent intros.l))
  =^  v  rng  (rads:rng (lent verbs.l))
  =^  s  rng  (rads:rng (lent (~(tap in ships.l))))
  :*
    n=((trel @ @ @) [n1 n2 n3])
    a=((pair @ @) [a1 a2])
    r=((pair @ @) [r1 r2])
    en=en
    e=e
    i=i
    v=v
    s=s
  ==
::
++  article
  |=  word/tape
  ^-  tape
  ?~  (find ~[(head word)] "aeiouh")
    "a"
  "an"
::
++  plural-if
  |=  {c/? w/maybe-plural}
  ^-  tape
  ?.  c  p.w
  ?^  q.w  u.q.w
  =+  r=(flop p.w)
  ?:  ?|  =('s' (head r))
          =("hs" (swag [0 2] r))
      ==
    (weld p.w "es")
  (weld p.w "s")
::
++  strike-if
  |=  {c/? t/tape}
  ^-  tape
  ?.  c  t
  :: %-  zing  %+  turn  t
  :: |=  x/@
  :: (tape (limo [x 204 182 ~]))
  %-  tufa
  %-  zing  %+  turn
    (tuba t)
  |=  a/@c
  ^-  (list @c)
  %-  limo
  ?:(=(32 `@`a) ~[a] ~[a `@c`822])
::
++  pair-runes
  |=  {r/(pair @ @) l/(list maybe-plural)}
  =+  r1=(snag p.r l)
  =+  r2=(snag q.r l)
  ^-  (pair tape tape)
  :-  p=(weld p.r1 p.r2)
  q=(weld (need q.r1) (need q.r2))
::
++  easy
  |=  {eny/@uvI l/dlists}
  ^-  (list tape)
  =+  r=(get-rands eny l)
  =+  intro=(snag i.r intros.l)
  =+  third=?=(^ (find "Hoon" intro))
  =+  verb=(plural-if third (snag v.r verbs.l))
  =+  adj1=(snag p.a.r adjs.l)
  =+  adj2=(snag q.a.r adjs.l)
  =+  noun1=(head (snag p.n.r nouns.l))
  =+  noun2=(head (snag q.n.r nouns.l))
  =+  noun3=(plural-if & (snag r.n.r nouns.l))
  =+  rune=(pair-runes r.r runes.l)
  =+  prod=(plural-if third "produce" ~)
  =+  ship=(snag s.r (~(tap in ships.l)))
  =+  err=(gth e.r 6)
  =+  err-name=(snag en.r errs.l)
  %-  limo
  :*
    %+  strike-if  err
      %+  welp
      "Urbit is easy! {intro} {verb} {(article noun1)} "
      "{noun1} with {(article adj1)} {adj1} {noun2},"
    ;:  welp
      (strike-if err "using the {p.rune} ")
      "({q.rune}) "
      (strike-if err "twig, ")
      ?:  err
        "OH NO! that crashed with {err-name}"
      "and {prod} {adj2} {noun3}"
    ==
    ?:  err  ~
    (welp (reap 8 ' ') "for {ship}")
    ~
  ==
--
