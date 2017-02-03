proc hadamard(in1, in2, `out`: ptr float64, count: cint)
  {. cdecl, importc: "hadamard_d" , dynlib: "liblinalg.so" .}

proc hadamard(in1, in2, `out`: ptr float32, count: cint)
  {. cdecl, importc: "hadamard_s" , dynlib: "liblinalg.so" .}

proc `|*|`*(v, w: CudaDVector32): CudaDVector32 {. inline .} =
  assert(v.N == w.N)
  initDynamic(result, v.N)
  hadamard(v.fp, w.fp, result.fp, v.N.cint)

proc `|*|`*(v, w: CudaDVector64): CudaDVector64 {. inline .} =
  assert(v.N == w.N)
  initDynamic(result, v.N)
  hadamard(v.fp, w.fp, result.fp, v.N.cint)

proc `|*|`*(v, w: CudaDMatrix32): CudaDMatrix32 {. inline .} =
  assert(v.dim == w.dim)
  let (m, n) = v.dim
  initMDynamic(result, m, n)
  hadamard(v.fp, w.fp, result.fp, (m * n).cint)

proc `|*|`*(v, w: CudaDMatrix64): CudaDMatrix64 {. inline .} =
  assert(v.dim == w.dim)
  let (m, n) = v.dim
  initMDynamic(result, m, n)
  hadamard(v.fp, w.fp, result.fp, (m * n).cint)