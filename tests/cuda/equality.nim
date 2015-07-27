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

import unittest, linalg


suite "vector and matrix equality":
  test "strict 32-bit vector equality":
    let
      u = vector([1'f32, 2'f32, 3'f32, 4'f32], float32).gpu()
      v = vector([1'f32, 2'f32, 3'f32, 4'f32], float32).gpu()
      w = vector([1'f32, 3'f32, 3'f32, 4'f32], float32).gpu()
    check u == v
    check v != w
  test "approximate 32-bit vector equality":
    let
      u = vector([1'f32, 2'f32, 3'f32, 4'f32], float32).gpu()
      v = vector([1'f32, 2'f32, 3'f32, 4'f32], float32).gpu()
      w = vector([1'f32, 2'f32, 2.999999'f32, 4.000001'f32], float32).gpu()
      z = vector([1'f32, 3'f32, 3'f32, 4'f32], float32).gpu()
    check u =~ v
    check v =~ w
    check v != w
    check w !=~ z