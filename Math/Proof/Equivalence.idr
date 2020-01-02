infix 40 ==


data (==) : t -> t -> Type where
  Refl : a == a

cong : (f : t1 -> t2) -> (a == b) -> f a == f b
cong f Refl = Refl

lhs : {a : t} -> {b : t} -> a == b -> t
lhs {a} {b} p = a

rhs : {a : t} -> {b : t} -> a == b -> t
rhs {a} {b} p = b

reify : (p : a == b) -> (lhs p == rhs p)
reify p = p

sym : a == b -> b == a
sym Refl = Refl

trans : a == b -> b == c -> a == c
trans Refl p = p

data Contraction : Type -> Type where
  MkContraction : (a : t) -> ((b : t) -> (a == b)) -> Contraction t

contraction_center : Contraction t -> t
contraction_center (MkContraction a _) = a

contracton_path : (c : Contraction t) -> (b : t) -> contraction_center c == b
contracton_path (MkContraction a ps) b = ps b

isContr : Type -> Type
isContr = Contraction

data Fiber : (a -> b) -> b -> Type where
  MkFiber : (f : a -> b) -> (x : a) -> (f x == y) ->  Fiber f y

fiber_value : {f : a -> b} -> Fiber f y -> a
fiber_value (MkFiber f x p) = x

fiber_image : {y : b} -> {f : a -> b} -> Fiber f y -> b
fiber_image (MkFiber f x z) = rhs z

fiber_path : {f : a -> b} -> (m : Fiber f y) -> f (fiber_value m) == y
fiber_path (MkFiber f x y) = y

isEquiv : {b : Type} -> (f : a -> b) -> Type
isEquiv {b} f = (x : b) -> Contraction (Fiber f x)

data Isomorphism : Type -> Type -> Type where
  MkIso : (f : a -> b) -> (g : b -> a) -> ((x : a) -> g (f x) == x) -> ((y : b) -> f (g y) == y) -> Isomorphism a b

iso_sym : Isomorphism a b -> Isomorphism b a
iso_sym (MkIso f g gf fg) = MkIso g f fg gf

infixl 4 <<, >>
(>>) : (a -> b) -> (b -> c) -> a -> c
f >> g = \x => g (f x)

(<<) : (b -> c) -> (a -> b) -> a -> c
g << f = \x => g (f x)

iso_trans : Isomorphism a b -> Isomorphism b c -> Isomorphism a c
iso_trans (MkIso f g gf fg) (MkIso f' g' gf' fg')  =
  MkIso
  (f >> f')
  (g << g')
  (\x => (cong g (gf' (f x)) `trans` (gf x)))
  (\x => (cong f' (fg (g' x)) `trans` (fg' x)))

data HAE : Type -> Type -> Type where
  MkHae : (f : a -> b) -> (g : b -> a) -> (gf : (x : a) -> g (f x) == x) -> (fg : (y : b) -> f (g y) == y) -> (fgf : (x : a) -> fg (f x) == cong f (gf x)) -> HAE a b

haef : HAE a b -> a -> b
haef (MkHae f _ _ _ _) = f

haeg : HAE a b -> a -> b
haeg (MkHae _ g _ _ _) = g


funext2 : {a, b : Type} -> {f, g : a -> b} -> (alpha : f == g)
funext2
