# Copyright 2015 UniCredit S.p.A.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

proc len*[N: static[int]](v: Vector32[N] or Vector64[N]): int = N

proc clone*[N: static[int]](v: Vector64[N]): Vector64[N] =
  new result
  copyMem(result.fp, v.fp, N * sizeof(float64))

proc clone*[N: static[int]](v: Vector32[N]): Vector32[N] =
  new result
  copyMem(result.fp, v.fp, N * sizeof(float32))

template atPrivate(M, N, m, i, j: expr, A: typedesc): auto =
  if m.order == colMajor:
    let data = cast[ref array[N, array[M, A]]](m.data)
    data[j][i]
  else:
    let data = cast[ref array[M, array[N, A]]](m.data)
    data[i][j]

proc at*[M, N: static[int]](m: Matrix64[M, N], i, j: int): float64 {. inline .} = atPrivate(M, N, m, i, j, float64)

template `[]`*(m: Matrix64, i, j: int): float64 = m.at(i, j)

proc at*[M, N: static[int]](m: Matrix32[M, N], i, j: int): float32 {. inline .} = atPrivate(M, N, m, i, j, float32)

template `[]`*(m: Matrix32, i, j: int): float32 = m.at(i, j)

template putPrivate(M, N, m, i, j, val: expr, A: typedesc) =
  if m.order == colMajor:
    var data = cast[ref array[N, array[M, A]]](m.data)
    data[j][i] = val
  else:
    var data = cast[ref array[M, array[N, A]]](m.data)
    data[i][j] = val

proc put*[M, N: static[int]](m: var Matrix64[M, N], i, j: int, val: float64) {. inline .} =
  putPrivate(M, N, m, i, j, val, float64)

proc `[]=`*(m: var Matrix64, i, j: int, val: float64) {. inline .} = m.put(i, j, val)

proc put*[M, N: static[int]](m: var Matrix32[M, N], i, j: int, val: float32) {. inline .} =
  putPrivate(M, N, m, i, j, val, float32)

proc `[]=`*(m: var Matrix32, i, j: int, val: float32) {. inline .} = m.put(i, j, val)

proc column*[M, N: static[int]](m: Matrix64[M, N], j: int): Vector64[M] {. inline .} =
  new result
  for i in 0 .. < M:
    result[i] = m.at(i, j)

proc row*[M, N: static[int]](m: Matrix64[M, N], i: int): Vector64[N] {. inline .} =
  new result
  for j in 0 .. < N:
    result[j] = m.at(i, j)

proc dim*[M, N: static[int]](m: Matrix32[M, N] or Matrix64[M, N]): tuple[rows, columns: int] = (M, N)

proc clone*[M, N: static[int]](m: Matrix64[M, N]): Matrix64[M, N] =
  result.order = m.order
  new result.data
  copyMem(result.fp, m.fp, M * N * sizeof(float64))