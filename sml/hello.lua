local error = error
local setmetatable = setmetatable
local math = math
local math_maxinteger = math.maxinteger
local string = string
local string_char = string.char
local string_format = string.format
local table = table
local table_pack = table.pack
local _exn_meta = {}
function _exn_meta:__tostring()
  local traceback = self.traceback
  if traceback then
    traceback = "\n" .. traceback
  else
    traceback = ""
  end
  return string_format("%s: %s%s", self.location or "<no location info>", self.tag[1], traceback)
end
local _Match_tag = { "Match" }
local _Match = setmetatable({ tag = _Match_tag }, _exn_meta)
local _Overflow_tag = { "Overflow" }
local _Overflow = setmetatable({ tag = _Overflow_tag }, _exn_meta)
local _Size_tag = { "Size" }
local _Size = setmetatable({ tag = _Size_tag }, _exn_meta)
local _Subscript_tag = { "Subscript" }
local _Subscript = setmetatable({ tag = _Subscript_tag }, _exn_meta)
local _Fail_tag = { "Fail" }
local function _Fail(message)
  return setmetatable({ tag = _Fail_tag, payload = message }, _exn_meta)
end
local _Error_tag = { "Error" }
local function _raise(x, location)
  local e
  if x.tag == _Error_tag then
    e = x.payload
  elseif location ~= nil then
    local traceback = debug.traceback(nil, 2)
    e = setmetatable({ tag = x.tag, payload = x.payload, location = location, traceback = traceback }, _exn_meta)
  else
    e = x
  end
  error(e, 1)
end
local function _Int_add(x, y)
  -- assert(math_type(x) == "integer")
  -- assert(math_type(y) == "integer")
  local z = x + y
  if y > 0 and z < x then
    _raise(_Overflow, "Int.+")
  elseif y < 0 and z > x then
    _raise(_Overflow, "Int.+")
  else
    return z
  end
end
local function _Int_sub(x, y)
  -- assert(math_type(x) == "integer")
  -- assert(math_type(y) == "integer")
  local z = x - y
  if y < 0 and z < x then
    _raise(_Overflow, "Int.-")
  elseif y > 0 and x < z then
    _raise(_Overflow, "Int.-")
  else
    return z
  end
end
local function _list(t)
  local xs = nil
  for i = t.n, 1, -1 do
    xs = { t[i], xs }
  end
  return xs
end
local function _Array_array(t)
  local n, init = t[1], t[2]
  if n < 0 then -- or maxLen < n
    _raise(_Size, "Array.array")
  end
  local t = { n = n }
  for i = 1, n do
    t[i] = init
  end
  return t
end
local function _VectorOrArray_fromList(xs)
  local t = {}
  local n = 0
  while xs ~= nil do
    n = n + 1
    t[n] = xs[1]
    xs = xs[2]
  end
  t.n = n
  return t
end
local function _VectorOrArray_tabulate(t)
  local n, f = t[1], t[2]
  if n < 0 then -- or maxLen < n
    _raise(_Size, "(Vector|Array).tabulate")
  end
  local t = { n = n }
  for i = 1, n do
    t[i] = f(i - 1)
  end
  return t
end
local _COLON_COLON_1, eq_132, Chr_143, LESS_155, EQUAL_154, GREATER_153, NONE_217, revAppend_1832942, map_454, tabulate_1832960, sub_602, update_606, sub_2739427, length_856, size_1069, tmp_2759820, tmp_2759822, tmp_2759824, tmp_2759826, tmp_2759827, compare_2759828, tmp_2759836
do
  _COLON_COLON_1 = function(a_104)
    local x_103 = a_104[1]
    local xs_102 = a_104[2]
    local tmp_15958 = {x_103, xs_102}
    return tmp_15958
  end
  eq_132 = function(a_123)
    local x_122 = a_123[1]
    local y_121 = a_123[2]
    local tmp_15971 = x_122 == y_121
    return tmp_15971
  end
  local Chr__tag_195 = {"Chr"}
  Chr_143 = {tag = Chr__tag_195}
  LESS_155 = "LESS"
  EQUAL_154 = "EQUAL"
  GREATER_153 = "GREATER"
  NONE_217 = {tag = "NONE"}
  revAppend_1832942 = function(tmp_1832941, ys_1832940)
    local tmp_2763240, tmp_2763241 = tmp_1832941, ys_1832940
    ::cont_58543::
    do
      local tmp_58542, ys_58541 = tmp_2763240, tmp_2763241
      local tmp_16349 = tmp_58542 == nil
      if tmp_16349 then
        return ys_58541
      end
      local tmp_16351 = tmp_58542 == nil
      local tmp_16352 = not tmp_16351
      if tmp_16352 then
        local tmp_16354 = tmp_58542[1]
        local tmp_16361 = tmp_58542[2]
        local tmp_43845 = {tmp_16354, ys_58541}
        tmp_2763240 = tmp_16361
        tmp_2763241 = tmp_43845
        goto cont_58543
      else
        _raise(_Match, "list.sml:60:5")
      end
    end
  end
  map_454 = function(a_455)
    local tmp_16399 = function(a_456)
      do
        local tmp_16402 = a_456 == nil
        if tmp_16402 then
          return nil
        end
        local tmp_16405 = a_456 == nil
        local tmp_16406 = not tmp_16405
        if tmp_16406 then
          goto then_2763242
        else
          _raise(_Match, "list.sml:66:5")
        end
      end
      ::then_2763242::
      do
        local tmp_16408 = a_456[1]
        local tmp_16415 = a_456[2]
        local tmp_16418 = a_455(tmp_16408)
        local tmp_16420 = map_454(a_455)
        local tmp_16422 = tmp_16420(tmp_16415)
        local tmp_43851 = {tmp_16418, tmp_16422}
        return tmp_43851
      end
    end
    return tmp_16399
  end
  tabulate_1832960 = function(n_1832946, f_1832945)
    do
      local tmp_43900 = n_1832946 < 0
      if tmp_43900 then
        _raise(_Size, "list.sml:101:27")
      end
      local tmp_58616 = n_1832946 < 10
      if tmp_58616 then
        goto then_2763243
      else
        goto else_2763244
      end
    end
    ::then_2763243::
    do
      local function go_58617(a_58619)
        local tmp_58621 = a_58619 >= n_1832946
        if tmp_58621 then
          return nil
        end
        local tmp_58622 = f_1832945(a_58619)
        local tmp_58624 = _Int_add(a_58619, 1)
        local tmp_58625 = go_58617(tmp_58624)
        local tmp_58627 = {tmp_58622, tmp_58625}
        return tmp_58627
      end
      return go_58617(0)
    end
    ::else_2763244::
    local tmp_2763245, tmp_2763246 = 0, nil
    ::cont_1832949::
    do
      local acc_1832950, i_1832951
      do
        i_1832951, acc_1832950 = tmp_2763245, tmp_2763246
        local tmp_1832952 = i_1832951 >= n_1832946
        if tmp_1832952 then
          goto then_2763247
        else
          goto else_2763248
        end
      end
      ::then_2763247::
      do
        return revAppend_1832942(acc_1832950, nil)
      end
      ::else_2763248::
      local tmp_1832956 = _Int_add(i_1832951, 1)
      local tmp_1832957 = f_1832945(i_1832951)
      local tmp_1832958 = {tmp_1832957, acc_1832950}
      tmp_2763245 = tmp_1832956
      tmp_2763246 = tmp_1832958
      goto cont_1832949
    end
  end
  sub_602 = function(a_603)
    local arr_605 = a_603[1]
    local i_604 = a_603[2]
    local tmp_16807 = arr_605[i_604 + 1]
    return tmp_16807
  end
  update_606 = function(a_607)
    local arr_610 = a_607[1]
    local i_609 = a_607[2]
    local v_608 = a_607[3]
    arr_610[i_609 + 1] = v_608
    return nil
  end
  sub_2739427 = function(vec_2739426, i_2739425)
    local tmp_58650
    do
      local tmp_43910 = i_2739425 < 0
      if tmp_43910 then
        tmp_58650 = true
      else
        local tmp_58655 = vec_2739426.n
        local tmp_58657 = tmp_58655 <= i_2739425
        tmp_58650 = tmp_58657
      end
    end
    ::cont_58654::
    if tmp_58650 then
      _raise(_Subscript, "vector-prim.sml:5:24")
    else
      local tmp_58653 = vec_2739426[i_2739425 + 1]
      return tmp_58653
    end
  end
  length_856 = function(a_857)
    local tmp_17202 = a_857.n
    return tmp_17202
  end
  size_1069 = function(a_1070)
    local tmp_17317 = #a_1070
    return tmp_17317
  end
  local tmp_2739469 = _ENV.io
  tmp_2759820 = tmp_2739469.stdout
  tmp_2759822 = string.byte
  tmp_2759824 = string.sub
  tmp_2759826 = table.concat
  tmp_2759827 = {tag = "SOME", payload = math_maxinteger}
  compare_2759828 = function(a_2759829)
    local x_2759831 = a_2759829[1]
    local y_2759832 = a_2759829[2]
    local tmp_2759833 = x_2759831 == y_2759832
    if tmp_2759833 then
      return EQUAL_154
    end
    local tmp_2759834 = x_2759831 < y_2759832
    if tmp_2759834 then
      return LESS_155
    else
      return GREATER_153
    end
  end
  do
    local tmp_2763249, tmp_2763250 = math_maxinteger, 1
    ::cont_2763234::
    do
      local x_2763236, n_2763235 = tmp_2763249, tmp_2763250
      local tmp_2763237 = x_2763236 == 0
      if tmp_2763237 then
        tmp_2759836 = n_2763235
        goto cont_2763233
      else
        local tmp_2763238 = x_2763236 >> 1
        local tmp_2763239 = _Int_add(n_2763235, 1)
        tmp_2763249 = tmp_2763238
        tmp_2763250 = tmp_2763239
        goto cont_2763234
      end
    end
  end
end
::cont_2763233::
local sub_2759837, substring_2759850, concat_2759866, implode_2759872, implodeRev_2759887, chr_2759904, n_2759913, n_2759914
do
  sub_2759837 = function(a_2759838)
    local s_2759840, i_2759841, tmp_2759843
    do
      s_2759840 = a_2759838[1]
      i_2759841 = a_2759838[2]
      local tmp_2759842 = i_2759841 < 0
      if tmp_2759842 then
        tmp_2759843 = true
      else
        local tmp_2759848 = #s_2759840
        local tmp_2759849 = tmp_2759848 <= i_2759841
        tmp_2759843 = tmp_2759849
      end
    end
    ::cont_2759847::
    if tmp_2759843 then
      _raise(_Subscript, "string-1.sml:33:44")
    else
      local tmp_2759845 = _Int_add(i_2759841, 1)
      local tmp_2759846 = tmp_2759822(s_2759840, tmp_2759845)
      return tmp_2759846
    end
  end
  substring_2759850 = function(s_2759853, i_2759852, j_2759851)
    local tmp_2759856
    do
      local tmp_2759855 = i_2759852 < 0
      do
        if tmp_2759855 then
          tmp_2759856 = true
          goto cont_2759861
        end
        local tmp_2759862 = j_2759851 < 0
        if tmp_2759862 then
          tmp_2759856 = true
        else
          local tmp_2759863 = #s_2759853
          local tmp_2759864 = _Int_add(i_2759852, j_2759851)
          local tmp_2759865 = tmp_2759863 < tmp_2759864
          tmp_2759856 = tmp_2759865
        end
      end
    end
    ::cont_2759861::
    if tmp_2759856 then
      _raise(_Subscript, "string-1.sml:40:59")
    else
      local tmp_2759858 = _Int_add(i_2759852, 1)
      local tmp_2759859 = _Int_add(i_2759852, j_2759851)
      local tmp_2759860 = tmp_2759824(s_2759853, tmp_2759858, tmp_2759859)
      return tmp_2759860
    end
  end
  concat_2759866 = function(a_2759867)
    local tmp_2759869 = _VectorOrArray_fromList(a_2759867)
    local tmp_2759870 = tmp_2759826(tmp_2759869)
    return tmp_2759870
  end
  implode_2759872 = function(a_2759873)
    local tmp_2759876
    do
      local tmp_2759875 = _VectorOrArray_fromList(a_2759873)
      do
        local tmp_2759879 = tmp_2759875.n
        local tmp_2759880 = function(i_2759881)
          local tmp_2759883 = tmp_2759875[i_2759881 + 1]
          local tmp_2759884 = string_char(tmp_2759883)
          return tmp_2759884
        end
        local tmp_2759885 = {tmp_2759879, tmp_2759880}
        tmp_2759876 = _VectorOrArray_tabulate(tmp_2759885)
        goto cont_2759878
      end
    end
    ::cont_2759878::
    local tmp_2759877 = tmp_2759826(tmp_2759876)
    return tmp_2759877
  end
  implodeRev_2759887 = function(a_2759888)
    local tmp_2759892
    do
      local tmp_2759890 = revAppend_1832942(a_2759888, nil)
      local tmp_2759891 = _VectorOrArray_fromList(tmp_2759890)
      do
        local tmp_2759895 = tmp_2759891.n
        local tmp_2759896 = function(i_2759897)
          local tmp_2759899 = tmp_2759891[i_2759897 + 1]
          local tmp_2759900 = string_char(tmp_2759899)
          return tmp_2759900
        end
        local tmp_2759901 = {tmp_2759895, tmp_2759896}
        tmp_2759892 = _VectorOrArray_tabulate(tmp_2759901)
        goto cont_2759894
      end
    end
    ::cont_2759894::
    local tmp_2759893 = tmp_2759826(tmp_2759892)
    return tmp_2759893
  end
  chr_2759904 = function(x_2759905)
    local tmp_2759908
    do
      local tmp_2759907 = x_2759905 < 0
      if tmp_2759907 then
        tmp_2759908 = true
      else
        local tmp_2759912 = x_2759905 > 255
        tmp_2759908 = tmp_2759912
      end
    end
    ::cont_2759911::
    if tmp_2759908 then
      _raise(Chr_143, "char-1.sml:47:37")
    else
      local tmp_2759910 = x_2759905
      return tmp_2759910
    end
  end
  n_2759913 = tmp_2759827.payload
  n_2759914 = tmp_2759827.payload
  local tmp_2759915 = tmp_2759836 == 64
  local tmp_2759916 = not tmp_2759915
  do
    if tmp_2759916 then
      goto then_2763251
    else
      goto cont_2763230
    end
    ::then_2763251::
    do
      local tmp_2763231 = _Fail("Word64 is not available")
      _raise(tmp_2763231, "word.sml:333:18")
    end
  end
end
::cont_2763230::
local MonoSequence_2759917, tmp_2761707, tmp_2761708, tmp_2761709, tmp_2761710, tmp_2761711, tmp_2761712, tmp_2761713, tmp_2761714, tmp_2761715, tmp_2761716, tmp_2761717, tmp_2761718, tmp_2761719, tmp_2761720, tmp_2761721, tmp_2761722, tmp_2761723, tmp_2761724, tmp_2761725, tmp_2761726, tmp_2761727, tmp_2761728, tmp_2761729, tmp_2761730, tmp_2761731, tmp_2761732, tmp_2761733, tmp_2761734, tmp_2761735, tmp_2761736, tmp_2761737, tmp_2761738, tmp_2761739, tmp_2761740, tmp_2761741, tmp_2761742, tmp_2761743, tmp_2761744, tmp_2761745, tmp_2761746, tmp_2761747, tmp_2761748, tmp_2761749, tmp_2761750, tmp_2761751, tmp_2761752, tmp_2761753, tmp_2761754, tmp_2761755, tmp_2761756, tmp_2761757, tmp_2761758, tmp_2761759, tmp_2761760, tmp_2761761, tmp_2761762, tmp_2761763, tmp_2761764, tmp_2761765, tmp_2761766, tmp_2761767, tmp_2761768, tmp_2761769, tmp_2761770, tmp_2761771, tmp_2761772, tmp_2761773, tmp_2761774, tmp_2761775, tmp_2761776, tmp_2761777, tmp_2761778, tmp_2761779, tmp_2761780, tmp_2761781, tmp_2761782, tmp_2761783, tmp_2761784, tmp_2761785, tmp_2761786, tmp_2761787, tmp_2761788, tmp_2761789, tmp_2761790, tmp_2761791, tmp_2761792, tmp_2761793, tmp_2761794, tmp_2761795, tmp_2761796, tmp_2761797, tmp_2761798, tmp_2761799, tmp_2761800, tmp_2761801, tmp_2761802, tmp_2761803
do
  MonoSequence_2759917 = function(fromList_2759934, length_2759933, maxLen_2759932, tmp_2759931, create_2759930, tmp_2759929, tmp_2759928, tmp_2759927, tmp_2759926, fromList_2759925, length_2759924, maxLen_2759923, tmp_2759922, vector_2759921, tmp_2759920, tmp_2759919, tmp_2759918)
    local tabulate_2759936, sub_2759944, update_2759957, appi_2759978, app_2759995, mapi_2760011, map_2760029, foldli_2760046, foldri_2760068, foldl_2760091, foldr_2760113, findi_2760136, find_2760156, exists_2760174, all_2760191, collate_2760208, toList_2760249, append_2760256, prepend_2760265, array_2760724, tabulate_2760735, sub_2760745, update_2760758, copy_2760772, copyVec_2760798, appi_2760824, app_2760841, modifyi_2760857, modify_2760877, foldli_2760896, foldri_2760918, foldl_2760941, foldr_2760963, findi_2760986, find_2761006, exists_2761024, all_2761041, collate_2761058, toList_2761099, vector_2761106, fromVector_2761118, length_2761130, sub_2761134, update_2761151, full_2761169, slice_2761175, subslice_2761210, base_2761253, copy_2761260, copyVec_2761303, isEmpty_2761333, getItem_2761338, appi_2761353, app_2761372, modifyi_2761390, modify_2761412, foldli_2761433, foldri_2761457, foldl_2761482, foldr_2761506, findi_2761531, find_2761553, exists_2761573, all_2761592, collate_2761611, vector_2761662, UnsafeMonoVector_2761673, UnsafeMonoArray_2761674, MonoVectorSlice_2761675
    do
      tabulate_2759936 = function(a_2759937)
        local n_2759939 = a_2759937[1]
        local f_2759940 = a_2759937[2]
        local tmp_2759941 = tabulate_1832960(n_2759939, f_2759940)
        local tmp_2759942 = {n_2759939, tmp_2759941}
        return tmp_2759920(tmp_2759942)
      end
      sub_2759944 = function(a_2759945)
        local v_2759947, i_2759948, tmp_2759950
        do
          v_2759947 = a_2759945[1]
          i_2759948 = a_2759945[2]
          local tmp_2759949 = 0 <= i_2759948
          do
            if tmp_2759949 then
              goto then_2763252
            else
              tmp_2759950 = false
              goto cont_2759953
            end
            ::then_2763252::
            do
              local tmp_2759954 = length_2759924(v_2759947)
              local tmp_2759955 = i_2759948 < tmp_2759954
              tmp_2759950 = tmp_2759955
            end
          end
        end
        ::cont_2759953::
        if tmp_2759950 then
          goto then_2763253
        else
          _raise(_Subscript, "mono-sequence.sml:221:22")
        end
        ::then_2763253::
        do
          local tmp_2759951 = {v_2759947, i_2759948}
          return tmp_2759918(tmp_2759951)
        end
      end
      update_2759957 = function(a_2759958)
        local tmp_2759964, tmp_2759966, tmp_2759972
        do
          local v_2759960 = a_2759958[1]
          local i_2759961 = a_2759958[2]
          local x_2759962 = a_2759958[3]
          local tmp_2759963 = {base = v_2759960, length = i_2759961, start = 0}
          tmp_2759964 = tmp_2759922(tmp_2759963)
          local tmp_2759965 = _list({n = 1, x_2759962})
          tmp_2759966 = fromList_2759925(tmp_2759965)
          local tmp_2759967 = _Int_add(i_2759961, 1)
          local tmp_2759968 = length_2759924(v_2759960)
          local tmp_2759969 = _Int_sub(tmp_2759968, i_2759961)
          local tmp_2759970 = _Int_sub(tmp_2759969, 1)
          local tmp_2759971 = {base = v_2759960, length = tmp_2759970, start = tmp_2759967}
          tmp_2759972 = tmp_2759922(tmp_2759971)
        end
        local tmp_2759973 = _list({n = 3, tmp_2759964, tmp_2759966, tmp_2759972})
        return tmp_2759926(tmp_2759973)
      end
      appi_2759978 = function(a_2759979)
        local tmp_2759981 = function(a_2759982)
          local n_2759984 = length_2759924(a_2759982)
          local tmp_2763254 = 0
          ::cont_2759985::
          do
            local a_2759986 = tmp_2763254
            local tmp_2759987 = a_2759986 >= n_2759984
            if tmp_2759987 then
              return nil
            end
            local tmp_2759988 = {a_2759982, a_2759986}
            local tmp_2759989 = tmp_2759918(tmp_2759988)
            local tmp_2759990 = {a_2759986, tmp_2759989}
            local tmp_2763255 = a_2759979(tmp_2759990)
            local tmp_2759991 = _Int_add(a_2759986, 1)
            tmp_2763254 = tmp_2759991
            goto cont_2759985
          end
        end
        return tmp_2759981
      end
      app_2759995 = function(a_2759996)
        local tmp_2759998 = function(a_2759999)
          local n_2760001 = length_2759924(a_2759999)
          local tmp_2763256 = 0
          ::cont_2760002::
          do
            local a_2760003 = tmp_2763256
            local tmp_2760004 = a_2760003 >= n_2760001
            if tmp_2760004 then
              return nil
            end
            local tmp_2760005 = {a_2759999, a_2760003}
            local tmp_2760006 = tmp_2759918(tmp_2760005)
            local tmp_2763257 = a_2759996(tmp_2760006)
            local tmp_2760007 = _Int_add(a_2760003, 1)
            tmp_2763256 = tmp_2760007
            goto cont_2760002
          end
        end
        return tmp_2759998
      end
      mapi_2760011 = function(a_2760012)
        local tmp_2760014 = function(a_2760015)
          local n_2760017 = length_2759924(a_2760015)
          local tmp_2760018 = function(i_2760019)
            local tmp_2760021 = {a_2760015, i_2760019}
            local tmp_2760022 = tmp_2759918(tmp_2760021)
            local tmp_2760023 = {i_2760019, tmp_2760022}
            return a_2760012(tmp_2760023)
          end
          local tmp_2760025 = tabulate_1832960(n_2760017, tmp_2760018)
          local tmp_2760026 = {n_2760017, tmp_2760025}
          return tmp_2759920(tmp_2760026)
        end
        return tmp_2760014
      end
      map_2760029 = function(a_2760030)
        local tmp_2760032 = function(a_2760033)
          local n_2760035 = length_2759924(a_2760033)
          local tmp_2760036 = function(i_2760037)
            local tmp_2760039 = {a_2760033, i_2760037}
            local tmp_2760040 = tmp_2759918(tmp_2760039)
            return a_2760030(tmp_2760040)
          end
          local tmp_2760042 = tabulate_1832960(n_2760035, tmp_2760036)
          local tmp_2760043 = {n_2760035, tmp_2760042}
          return tmp_2759920(tmp_2760043)
        end
        return tmp_2760032
      end
      foldli_2760046 = function(a_2760047)
        local tmp_2760049 = function(a_2760050)
          local tmp_2760052 = function(a_2760053)
            local n_2760055 = length_2759924(a_2760053)
            local tmp_2763258, tmp_2763259 = 0, a_2760050
            ::cont_2760056::
            do
              local i_2760058, acc_2760057 = tmp_2763258, tmp_2763259
              local tmp_2760059 = i_2760058 >= n_2760055
              if tmp_2760059 then
                return acc_2760057
              end
              local tmp_2760060 = _Int_add(i_2760058, 1)
              local tmp_2760061 = {a_2760053, i_2760058}
              local tmp_2760062 = tmp_2759918(tmp_2760061)
              local tmp_2760063 = {i_2760058, tmp_2760062, acc_2760057}
              local tmp_2760064 = a_2760047(tmp_2760063)
              tmp_2763258 = tmp_2760060
              tmp_2763259 = tmp_2760064
              goto cont_2760056
            end
          end
          return tmp_2760052
        end
        return tmp_2760049
      end
      foldri_2760068 = function(a_2760069)
        local tmp_2760071 = function(a_2760072)
          local tmp_2760074 = function(a_2760075)
            local tmp_2763261, tmp_2763260
            do
              local tmp_2760077 = length_2759924(a_2760075)
              local tmp_2760078 = _Int_sub(tmp_2760077, 1)
              tmp_2763260, tmp_2763261 = tmp_2760078, a_2760072
            end
            ::cont_2760079::
            do
              local i_2760081, acc_2760080 = tmp_2763260, tmp_2763261
              local tmp_2760082 = i_2760081 < 0
              if tmp_2760082 then
                return acc_2760080
              end
              local tmp_2760083 = _Int_sub(i_2760081, 1)
              local tmp_2760084 = {a_2760075, i_2760081}
              local tmp_2760085 = tmp_2759918(tmp_2760084)
              local tmp_2760086 = {i_2760081, tmp_2760085, acc_2760080}
              local tmp_2760087 = a_2760069(tmp_2760086)
              tmp_2763260 = tmp_2760083
              tmp_2763261 = tmp_2760087
              goto cont_2760079
            end
          end
          return tmp_2760074
        end
        return tmp_2760071
      end
      foldl_2760091 = function(a_2760092)
        local tmp_2760094 = function(a_2760095)
          local tmp_2760097 = function(a_2760098)
            local n_2760100 = length_2759924(a_2760098)
            local tmp_2763262, tmp_2763263 = 0, a_2760095
            ::cont_2760101::
            do
              local i_2760103, acc_2760102 = tmp_2763262, tmp_2763263
              local tmp_2760104 = i_2760103 >= n_2760100
              if tmp_2760104 then
                return acc_2760102
              end
              local tmp_2760105 = _Int_add(i_2760103, 1)
              local tmp_2760106 = {a_2760098, i_2760103}
              local tmp_2760107 = tmp_2759918(tmp_2760106)
              local tmp_2760108 = {tmp_2760107, acc_2760102}
              local tmp_2760109 = a_2760092(tmp_2760108)
              tmp_2763262 = tmp_2760105
              tmp_2763263 = tmp_2760109
              goto cont_2760101
            end
          end
          return tmp_2760097
        end
        return tmp_2760094
      end
      foldr_2760113 = function(a_2760114)
        local tmp_2760116 = function(a_2760117)
          local tmp_2760119 = function(a_2760120)
            local tmp_2763265, tmp_2763264
            do
              local tmp_2760122 = length_2759924(a_2760120)
              local tmp_2760123 = _Int_sub(tmp_2760122, 1)
              tmp_2763264, tmp_2763265 = tmp_2760123, a_2760117
            end
            ::cont_2760124::
            do
              local i_2760126, acc_2760125 = tmp_2763264, tmp_2763265
              local tmp_2760127 = i_2760126 < 0
              if tmp_2760127 then
                return acc_2760125
              end
              local tmp_2760128 = _Int_sub(i_2760126, 1)
              local tmp_2760129 = {a_2760120, i_2760126}
              local tmp_2760130 = tmp_2759918(tmp_2760129)
              local tmp_2760131 = {tmp_2760130, acc_2760125}
              local tmp_2760132 = a_2760114(tmp_2760131)
              tmp_2763264 = tmp_2760128
              tmp_2763265 = tmp_2760132
              goto cont_2760124
            end
          end
          return tmp_2760119
        end
        return tmp_2760116
      end
      findi_2760136 = function(a_2760137)
        local tmp_2760139 = function(a_2760140)
          local n_2760142 = length_2759924(a_2760140)
          local tmp_2763266 = 0
          ::cont_2760143::
          do
            local a_2760144 = tmp_2763266
            local tmp_2760145 = a_2760144 >= n_2760142
            if tmp_2760145 then
              return NONE_217
            end
            local tmp_2760146 = {a_2760140, a_2760144}
            local x_2760147 = tmp_2759918(tmp_2760146)
            local tmp_2760148 = {a_2760144, x_2760147}
            local tmp_2760149 = a_2760137(tmp_2760148)
            if tmp_2760149 then
              local tmp_2760150 = {a_2760144, x_2760147}
              local tmp_2760151 = {tag = "SOME", payload = tmp_2760150}
              return tmp_2760151
            else
              local tmp_2760152 = _Int_add(a_2760144, 1)
              tmp_2763266 = tmp_2760152
              goto cont_2760143
            end
          end
        end
        return tmp_2760139
      end
      find_2760156 = function(a_2760157)
        local tmp_2760159 = function(a_2760160)
          local n_2760162 = length_2759924(a_2760160)
          local tmp_2763267 = 0
          ::cont_2760163::
          do
            local a_2760164 = tmp_2763267
            local tmp_2760165 = a_2760164 >= n_2760162
            if tmp_2760165 then
              return NONE_217
            end
            local tmp_2760166 = {a_2760160, a_2760164}
            local x_2760167 = tmp_2759918(tmp_2760166)
            local tmp_2760168 = a_2760157(x_2760167)
            if tmp_2760168 then
              local tmp_2760169 = {tag = "SOME", payload = x_2760167}
              return tmp_2760169
            else
              local tmp_2760170 = _Int_add(a_2760164, 1)
              tmp_2763267 = tmp_2760170
              goto cont_2760163
            end
          end
        end
        return tmp_2760159
      end
      exists_2760174 = function(a_2760175)
        local tmp_2760177 = function(a_2760178)
          local n_2760180 = length_2759924(a_2760178)
          local tmp_2763268 = 0
          ::cont_2760181::
          do
            local a_2760182 = tmp_2763268
            local tmp_2760183 = a_2760182 >= n_2760180
            if tmp_2760183 then
              return false
            end
            local tmp_2760184 = {a_2760178, a_2760182}
            local tmp_2760185 = tmp_2759918(tmp_2760184)
            local tmp_2760186 = a_2760175(tmp_2760185)
            if tmp_2760186 then
              return true
            else
              local tmp_2760187 = _Int_add(a_2760182, 1)
              tmp_2763268 = tmp_2760187
              goto cont_2760181
            end
          end
        end
        return tmp_2760177
      end
      all_2760191 = function(a_2760192)
        local tmp_2760194 = function(a_2760195)
          local n_2760197 = length_2759924(a_2760195)
          local tmp_2763269 = 0
          ::cont_2760198::
          do
            local a_2760199 = tmp_2763269
            local tmp_2760200 = a_2760199 >= n_2760197
            if tmp_2760200 then
              return true
            end
            local tmp_2760201 = {a_2760195, a_2760199}
            local tmp_2760202 = tmp_2759918(tmp_2760201)
            local tmp_2760203 = a_2760192(tmp_2760202)
            if tmp_2760203 then
              local tmp_2760204 = _Int_add(a_2760199, 1)
              tmp_2763269 = tmp_2760204
              goto cont_2760198
            else
              return false
            end
          end
        end
        return tmp_2760194
      end
      collate_2760208 = function(a_2760209)
        local tmp_2760211 = function(a_2760212)
          local xs_2760214 = a_2760212[1]
          local ys_2760215 = a_2760212[2]
          local xl_2760216 = length_2759924(xs_2760214)
          local yl_2760217 = length_2759924(ys_2760215)
          local tmp_2763270 = 0
          ::cont_2760218::
          do
            local a_2760219 = tmp_2763270
            local tmp_2760220 = xl_2760216 <= a_2760219
            local tmp_2760221 = yl_2760217 <= a_2760219
            local tmp_2760222
            if tmp_2760220 then
              tmp_2760222 = tmp_2760221
            else
              tmp_2760222 = false
            end
            ::cont_2760246::
            if tmp_2760222 then
              return EQUAL_154
            end
            local tmp_2760223
            if tmp_2760220 then
              local tmp_2760245 = not tmp_2760221
              tmp_2760223 = tmp_2760245
            else
              tmp_2760223 = false
            end
            ::cont_2760244::
            local tmp_2760225
            do
              if tmp_2760223 then
                return LESS_155
              end
              local tmp_2760224 = not tmp_2760220
              if tmp_2760224 then
                tmp_2760225 = tmp_2760221
              else
                tmp_2760225 = false
              end
            end
            ::cont_2760243::
            local tmp_2760227
            do
              if tmp_2760225 then
                return GREATER_153
              end
              local tmp_2760226 = not tmp_2760220
              if tmp_2760226 then
                local tmp_2760242 = not tmp_2760221
                tmp_2760227 = tmp_2760242
              else
                tmp_2760227 = false
              end
            end
            ::cont_2760241::
            if tmp_2760227 then
              goto then_2763271
            else
              _raise(_Match, "mono-sequence.sml:310:49")
            end
            ::then_2763271::
            do
              local tmp_2760228 = {xs_2760214, a_2760219}
              local tmp_2760229 = tmp_2759918(tmp_2760228)
              local tmp_2760230 = {ys_2760215, a_2760219}
              local tmp_2760231 = tmp_2759918(tmp_2760230)
              local tmp_2760232 = {tmp_2760229, tmp_2760231}
              local exp_2760233 = a_2760209(tmp_2760232)
              local tmp_2760234 = exp_2760233
              local tmp_2760235 = tmp_2760234 == "EQUAL"
              if tmp_2760235 then
                local tmp_2760236 = _Int_add(a_2760219, 1)
                tmp_2763270 = tmp_2760236
                goto cont_2760218
              else
                return exp_2760233
              end
            end
          end
        end
        return tmp_2760211
      end
      toList_2760249 = function(a_2760250)
        local tmp_2760252 = foldr_2760113(_COLON_COLON_1)
        local tmp_2760253 = tmp_2760252(nil)
        return tmp_2760253(a_2760250)
      end
      append_2760256 = function(a_2760257)
        local v_2760259 = a_2760257[1]
        local x_2760260 = a_2760257[2]
        local tmp_2760261 = _list({n = 1, x_2760260})
        local tmp_2760262 = fromList_2759925(tmp_2760261)
        local tmp_2760263 = _list({n = 2, v_2760259, tmp_2760262})
        return tmp_2759926(tmp_2760263)
      end
      prepend_2760265 = function(a_2760266)
        local x_2760268 = a_2760266[1]
        local v_2760269 = a_2760266[2]
        local tmp_2760270 = _list({n = 1, x_2760268})
        local tmp_2760271 = fromList_2759925(tmp_2760270)
        local tmp_2760272 = _list({n = 2, tmp_2760271, v_2760269})
        return tmp_2759926(tmp_2760272)
      end
      local length_2760274 = function(tmp_2760275)
        local tmp_2760277 = tmp_2760275.length
        return tmp_2760277
      end
      local sub_2760278 = function(a_2760279)
        local base_2760282, start_2760284, i_2760287, tmp_2760289
        do
          local tmp_2760281 = a_2760279[1]
          base_2760282 = tmp_2760281.base
          local tmp_2760283 = a_2760279[1]
          start_2760284 = tmp_2760283.start
          local tmp_2760285 = a_2760279[1]
          local length_2760286 = tmp_2760285.length
          i_2760287 = a_2760279[2]
          local tmp_2760288 = 0 <= i_2760287
          if tmp_2760288 then
            local tmp_2760294 = i_2760287 < length_2760286
            tmp_2760289 = tmp_2760294
          else
            tmp_2760289 = false
          end
        end
        ::cont_2760293::
        if tmp_2760289 then
          goto then_2763272
        else
          _raise(_Subscript, "mono-sequence.sml:331:44")
        end
        ::then_2763272::
        do
          local tmp_2760290 = _Int_add(start_2760284, i_2760287)
          local tmp_2760291 = {base_2760282, tmp_2760290}
          return tmp_2759918(tmp_2760291)
        end
      end
      local full_2760295 = function(a_2760296)
        local tmp_2760298 = length_2759924(a_2760296)
        local tmp_2760299 = {base = a_2760296, length = tmp_2760298, start = 0}
        return tmp_2760299
      end
      local slice_2760301 = function(a_2760302)
        do
          local tmp_2760304 = a_2760302[3]
          local tmp_2760305 = tmp_2760304.tag
          local tmp_2760306 = tmp_2760305 == "NONE"
          if tmp_2760306 then
            goto then_2763273
          else
            goto else_2763274
          end
        end
        ::then_2763273::
        do
          local v_2760307, i_2760308, n_2760309, tmp_2760311
          do
            v_2760307 = a_2760302[1]
            i_2760308 = a_2760302[2]
            n_2760309 = length_2759924(v_2760307)
            local tmp_2760310 = 0 <= i_2760308
            if tmp_2760310 then
              local tmp_2760316 = i_2760308 <= n_2760309
              tmp_2760311 = tmp_2760316
            else
              tmp_2760311 = false
            end
          end
          ::cont_2760315::
          if tmp_2760311 then
            local tmp_2760312 = _Int_sub(n_2760309, i_2760308)
            local tmp_2760313 = {base = v_2760307, length = tmp_2760312, start = i_2760308}
            return tmp_2760313
          else
            _raise(_Subscript, "mono-sequence.sml:337:33")
          end
        end
        ::else_2763274::
        do
          local tmp_2760318 = a_2760302[3]
          local tmp_2760319 = tmp_2760318.tag
          local tmp_2760320 = tmp_2760319 == "SOME"
          if tmp_2760320 then
            goto then_2763275
          else
            _raise(_Match, "mono-sequence.sml:333:5")
          end
        end
        ::then_2763275::
        do
          local v_2760321, i_2760322, n_2760324, tmp_2760326
          do
            v_2760321 = a_2760302[1]
            i_2760322 = a_2760302[2]
            local tmp_2760323 = a_2760302[3]
            n_2760324 = tmp_2760323.payload
            local tmp_2760325 = 0 <= i_2760322
            do
              if tmp_2760325 then
                goto then_2763276
              else
                tmp_2760326 = false
                goto cont_2760329
              end
              ::then_2763276::
              do
                do
                  local tmp_2760330 = 0 <= n_2760324
                  if tmp_2760330 then
                    goto then_2763277
                  else
                    tmp_2760326 = false
                    goto cont_2760329
                  end
                end
                ::then_2763277::
                do
                  local tmp_2760331 = _Int_add(i_2760322, n_2760324)
                  local tmp_2760332 = length_2759924(v_2760321)
                  local tmp_2760333 = tmp_2760331 <= tmp_2760332
                  tmp_2760326 = tmp_2760333
                end
              end
            end
          end
          ::cont_2760329::
          if tmp_2760326 then
            local tmp_2760327 = {base = v_2760321, length = n_2760324, start = i_2760322}
            return tmp_2760327
          else
            _raise(_Subscript, "mono-sequence.sml:342:32")
          end
        end
      end
      local subslice_2760336 = function(a_2760337)
        local tmp_2760339 = a_2760337[3]
        local tmp_2760340 = tmp_2760339.tag
        local tmp_2760341 = tmp_2760340 == "NONE"
        if tmp_2760341 then
          local base_2760343, start_2760345, length_2760347, i_2760348, tmp_2760350
          do
            local tmp_2760342 = a_2760337[1]
            base_2760343 = tmp_2760342.base
            local tmp_2760344 = a_2760337[1]
            start_2760345 = tmp_2760344.start
            local tmp_2760346 = a_2760337[1]
            length_2760347 = tmp_2760346.length
            i_2760348 = a_2760337[2]
            local tmp_2760349 = 0 <= i_2760348
            if tmp_2760349 then
              local tmp_2760356 = i_2760348 <= length_2760347
              tmp_2760350 = tmp_2760356
            else
              tmp_2760350 = false
            end
          end
          ::cont_2760355::
          if tmp_2760350 then
            local tmp_2760351 = _Int_add(start_2760345, i_2760348)
            local tmp_2760352 = _Int_sub(length_2760347, i_2760348)
            local tmp_2760353 = {base = base_2760343, length = tmp_2760352, start = tmp_2760351}
            return tmp_2760353
          else
            _raise(_Subscript, "mono-sequence.sml:346:55")
          end
        end
        local tmp_2760357 = a_2760337[3]
        local tmp_2760358 = tmp_2760357.tag
        local tmp_2760359 = tmp_2760358 == "SOME"
        if tmp_2760359 then
          local base_2760361, start_2760363, i_2760366, n_2760368, tmp_2760370
          do
            local tmp_2760360 = a_2760337[1]
            base_2760361 = tmp_2760360.base
            local tmp_2760362 = a_2760337[1]
            start_2760363 = tmp_2760362.start
            local tmp_2760364 = a_2760337[1]
            local length_2760365 = tmp_2760364.length
            i_2760366 = a_2760337[2]
            local tmp_2760367 = a_2760337[3]
            n_2760368 = tmp_2760367.payload
            local tmp_2760369 = 0 <= i_2760366
            if tmp_2760369 then
              local tmp_2760375 = 0 <= n_2760368
              if tmp_2760375 then
                local tmp_2760376 = _Int_add(i_2760366, n_2760368)
                local tmp_2760377 = tmp_2760376 <= length_2760365
                tmp_2760370 = tmp_2760377
              else
                tmp_2760370 = false
              end
            else
              tmp_2760370 = false
            end
          end
          ::cont_2760374::
          if tmp_2760370 then
            local tmp_2760371 = _Int_add(start_2760363, i_2760366)
            local tmp_2760372 = {base = base_2760361, length = n_2760368, start = tmp_2760371}
            return tmp_2760372
          else
            _raise(_Subscript, "mono-sequence.sml:350:57")
          end
        else
          _raise(_Match, "mono-sequence.sml:343:5")
        end
      end
      local base_2760379 = function(a_2760380)
        local b_2760382 = a_2760380.base
        local start_2760383 = a_2760380.start
        local length_2760384 = a_2760380.length
        local tmp_2760385 = {b_2760382, start_2760383, length_2760384}
        return tmp_2760385
      end
      local concat_2760386 = function(a_2760387)
        local tmp_2760389 = map_454(tmp_2759922)
        local tmp_2760390 = tmp_2760389(a_2760387)
        return tmp_2759926(tmp_2760390)
      end
      local isEmpty_2760393 = function(a_2760394)
        local length_2760396 = a_2760394.length
        local tmp_2760397 = length_2760396 == 0
        return tmp_2760397
      end
      local getItem_2760398 = function(a_2760399)
        local base_2760401, start_2760402, length_2760403
        do
          base_2760401 = a_2760399.base
          start_2760402 = a_2760399.start
          length_2760403 = a_2760399.length
          local tmp_2760404 = length_2760403 > 0
          if tmp_2760404 then
            goto then_2763278
          else
            return NONE_217
          end
        end
        ::then_2763278::
        do
          local tmp_2760405 = {base_2760401, start_2760402}
          local tmp_2760406 = tmp_2759918(tmp_2760405)
          local tmp_2760407 = _Int_add(start_2760402, 1)
          local tmp_2760408 = _Int_sub(length_2760403, 1)
          local tmp_2760409 = {base = base_2760401, length = tmp_2760408, start = tmp_2760407}
          local tmp_2760410 = {tmp_2760406, tmp_2760409}
          local tmp_2760411 = {tag = "SOME", payload = tmp_2760410}
          return tmp_2760411
        end
      end
      local appi_2760413 = function(a_2760414)
        local tmp_2760416 = function(a_2760417)
          local base_2760419 = a_2760417.base
          local start_2760420 = a_2760417.start
          local length_2760421 = a_2760417.length
          local tmp_2763279 = 0
          ::cont_2760422::
          do
            local a_2760423 = tmp_2763279
            local tmp_2760424 = a_2760423 >= length_2760421
            if tmp_2760424 then
              return nil
            end
            local tmp_2760425 = _Int_add(start_2760420, a_2760423)
            local tmp_2760426 = {base_2760419, tmp_2760425}
            local tmp_2760427 = tmp_2759918(tmp_2760426)
            local tmp_2760428 = {a_2760423, tmp_2760427}
            local tmp_2763280 = a_2760414(tmp_2760428)
            local tmp_2760429 = _Int_add(a_2760423, 1)
            tmp_2763279 = tmp_2760429
            goto cont_2760422
          end
        end
        return tmp_2760416
      end
      local app_2760432 = function(a_2760433)
        local tmp_2760435 = function(a_2760436)
          local base_2760438, tmp_2760441, tmp_2763281
          do
            base_2760438 = a_2760436.base
            local start_2760439 = a_2760436.start
            local length_2760440 = a_2760436.length
            tmp_2760441 = _Int_add(start_2760439, length_2760440)
            tmp_2763281 = start_2760439
          end
          ::cont_2760442::
          do
            local a_2760443 = tmp_2763281
            local tmp_2760444 = a_2760443 >= tmp_2760441
            if tmp_2760444 then
              return nil
            end
            local tmp_2760445 = {base_2760438, a_2760443}
            local tmp_2760446 = tmp_2759918(tmp_2760445)
            local tmp_2763282 = a_2760433(tmp_2760446)
            local tmp_2760447 = _Int_add(a_2760443, 1)
            tmp_2763281 = tmp_2760447
            goto cont_2760442
          end
        end
        return tmp_2760435
      end
      local mapi_2760450 = function(a_2760451)
        local tmp_2760453 = function(a_2760454)
          local base_2760456 = a_2760454.base
          local start_2760457 = a_2760454.start
          local length_2760458 = a_2760454.length
          local tmp_2763283, tmp_2763284 = 0, nil
          ::cont_2760459::
          do
            local acc_2760460, i_2760461
            do
              i_2760461, acc_2760460 = tmp_2763283, tmp_2763284
              local tmp_2760462 = i_2760461 >= length_2760458
              if tmp_2760462 then
                goto then_2763285
              else
                goto else_2763286
              end
            end
            ::then_2763285::
            do
              local tmp_2760463 = {length_2760458, acc_2760460}
              return tmp_2759919(tmp_2760463)
            end
            ::else_2763286::
            local tmp_2760464 = _Int_add(i_2760461, 1)
            local tmp_2760465 = _Int_add(start_2760457, i_2760461)
            local tmp_2760466 = {base_2760456, tmp_2760465}
            local tmp_2760467 = tmp_2759918(tmp_2760466)
            local tmp_2760468 = {i_2760461, tmp_2760467}
            local tmp_2760469 = a_2760451(tmp_2760468)
            local tmp_2760470 = {tmp_2760469, acc_2760460}
            tmp_2763283 = tmp_2760464
            tmp_2763284 = tmp_2760470
            goto cont_2760459
          end
        end
        return tmp_2760453
      end
      local map_2760473 = function(a_2760474)
        local tmp_2760476 = function(a_2760477)
          local base_2760479, length_2760481, tmp_2760482, tmp_2763288, tmp_2763287
          do
            base_2760479 = a_2760477.base
            local start_2760480 = a_2760477.start
            length_2760481 = a_2760477.length
            tmp_2760482 = _Int_add(start_2760480, length_2760481)
            tmp_2763287, tmp_2763288 = start_2760480, nil
          end
          ::cont_2760483::
          do
            local acc_2760484, i_2760485
            do
              i_2760485, acc_2760484 = tmp_2763287, tmp_2763288
              local tmp_2760486 = i_2760485 >= tmp_2760482
              if tmp_2760486 then
                goto then_2763289
              else
                goto else_2763290
              end
            end
            ::then_2763289::
            do
              local tmp_2760487 = {length_2760481, acc_2760484}
              return tmp_2759919(tmp_2760487)
            end
            ::else_2763290::
            local tmp_2760488 = _Int_add(i_2760485, 1)
            local tmp_2760489 = {base_2760479, i_2760485}
            local tmp_2760490 = tmp_2759918(tmp_2760489)
            local tmp_2760491 = a_2760474(tmp_2760490)
            local tmp_2760492 = {tmp_2760491, acc_2760484}
            tmp_2763287 = tmp_2760488
            tmp_2763288 = tmp_2760492
            goto cont_2760483
          end
        end
        return tmp_2760476
      end
      local foldli_2760495 = function(a_2760496)
        local tmp_2760498 = function(a_2760499)
          local tmp_2760501 = function(a_2760502)
            local base_2760504 = a_2760502.base
            local start_2760505 = a_2760502.start
            local length_2760506 = a_2760502.length
            local tmp_2763291, tmp_2763292 = 0, a_2760499
            ::cont_2760507::
            do
              local i_2760509, acc_2760508 = tmp_2763291, tmp_2763292
              local tmp_2760510 = i_2760509 >= length_2760506
              if tmp_2760510 then
                return acc_2760508
              end
              local tmp_2760511 = _Int_add(i_2760509, 1)
              local tmp_2760512 = _Int_add(start_2760505, i_2760509)
              local tmp_2760513 = {base_2760504, tmp_2760512}
              local tmp_2760514 = tmp_2759918(tmp_2760513)
              local tmp_2760515 = {i_2760509, tmp_2760514, acc_2760508}
              local tmp_2760516 = a_2760496(tmp_2760515)
              tmp_2763291 = tmp_2760511
              tmp_2763292 = tmp_2760516
              goto cont_2760507
            end
          end
          return tmp_2760501
        end
        return tmp_2760498
      end
      local foldri_2760519 = function(a_2760520)
        local tmp_2760522 = function(a_2760523)
          local tmp_2760525 = function(a_2760526)
            local base_2760528, start_2760529, tmp_2763294, tmp_2763293
            do
              base_2760528 = a_2760526.base
              start_2760529 = a_2760526.start
              local length_2760530 = a_2760526.length
              local tmp_2760531 = _Int_sub(length_2760530, 1)
              tmp_2763293, tmp_2763294 = tmp_2760531, a_2760523
            end
            ::cont_2760532::
            do
              local i_2760534, acc_2760533 = tmp_2763293, tmp_2763294
              local tmp_2760535 = i_2760534 < 0
              if tmp_2760535 then
                return acc_2760533
              end
              local tmp_2760536 = _Int_sub(i_2760534, 1)
              local tmp_2760537 = _Int_add(start_2760529, i_2760534)
              local tmp_2760538 = {base_2760528, tmp_2760537}
              local tmp_2760539 = tmp_2759918(tmp_2760538)
              local tmp_2760540 = {i_2760534, tmp_2760539, acc_2760533}
              local tmp_2760541 = a_2760520(tmp_2760540)
              tmp_2763293 = tmp_2760536
              tmp_2763294 = tmp_2760541
              goto cont_2760532
            end
          end
          return tmp_2760525
        end
        return tmp_2760522
      end
      local foldl_2760544 = function(a_2760545)
        local tmp_2760547 = function(a_2760548)
          local tmp_2760550 = function(a_2760551)
            local base_2760553, tmp_2760556, tmp_2763296, tmp_2763295
            do
              base_2760553 = a_2760551.base
              local start_2760554 = a_2760551.start
              local length_2760555 = a_2760551.length
              tmp_2760556 = _Int_add(start_2760554, length_2760555)
              tmp_2763295, tmp_2763296 = start_2760554, a_2760548
            end
            ::cont_2760557::
            do
              local i_2760559, acc_2760558 = tmp_2763295, tmp_2763296
              local tmp_2760560 = i_2760559 >= tmp_2760556
              if tmp_2760560 then
                return acc_2760558
              end
              local tmp_2760561 = _Int_add(i_2760559, 1)
              local tmp_2760562 = {base_2760553, i_2760559}
              local tmp_2760563 = tmp_2759918(tmp_2760562)
              local tmp_2760564 = {tmp_2760563, acc_2760558}
              local tmp_2760565 = a_2760545(tmp_2760564)
              tmp_2763295 = tmp_2760561
              tmp_2763296 = tmp_2760565
              goto cont_2760557
            end
          end
          return tmp_2760550
        end
        return tmp_2760547
      end
      local foldr_2760568 = function(a_2760569)
        local tmp_2760571 = function(a_2760572)
          local tmp_2760574 = function(a_2760575)
            local base_2760577, start_2760578, tmp_2763298, tmp_2763297
            do
              base_2760577 = a_2760575.base
              start_2760578 = a_2760575.start
              local length_2760579 = a_2760575.length
              local tmp_2760580 = _Int_add(start_2760578, length_2760579)
              local tmp_2760581 = _Int_sub(tmp_2760580, 1)
              tmp_2763297, tmp_2763298 = tmp_2760581, a_2760572
            end
            ::cont_2760582::
            do
              local i_2760584, acc_2760583 = tmp_2763297, tmp_2763298
              local tmp_2760585 = i_2760584 < start_2760578
              if tmp_2760585 then
                return acc_2760583
              end
              local tmp_2760586 = _Int_sub(i_2760584, 1)
              local tmp_2760587 = {base_2760577, i_2760584}
              local tmp_2760588 = tmp_2759918(tmp_2760587)
              local tmp_2760589 = {tmp_2760588, acc_2760583}
              local tmp_2760590 = a_2760569(tmp_2760589)
              tmp_2763297 = tmp_2760586
              tmp_2763298 = tmp_2760590
              goto cont_2760582
            end
          end
          return tmp_2760574
        end
        return tmp_2760571
      end
      local findi_2760593 = function(a_2760594)
        local tmp_2760596 = function(a_2760597)
          local base_2760599 = a_2760597.base
          local start_2760600 = a_2760597.start
          local length_2760601 = a_2760597.length
          local tmp_2763299 = 0
          ::cont_2760602::
          do
            local a_2760603 = tmp_2763299
            local tmp_2760604 = a_2760603 >= length_2760601
            if tmp_2760604 then
              return NONE_217
            end
            local tmp_2760605 = _Int_add(start_2760600, a_2760603)
            local tmp_2760606 = {base_2760599, tmp_2760605}
            local x_2760607 = tmp_2759918(tmp_2760606)
            local tmp_2760608 = {a_2760603, x_2760607}
            local tmp_2760609 = a_2760594(tmp_2760608)
            if tmp_2760609 then
              local tmp_2760610 = {a_2760603, x_2760607}
              local tmp_2760611 = {tag = "SOME", payload = tmp_2760610}
              return tmp_2760611
            else
              local tmp_2760612 = _Int_add(a_2760603, 1)
              tmp_2763299 = tmp_2760612
              goto cont_2760602
            end
          end
        end
        return tmp_2760596
      end
      local find_2760615 = function(a_2760616)
        local tmp_2760618 = function(a_2760619)
          local base_2760621, tmp_2760624, tmp_2763300
          do
            base_2760621 = a_2760619.base
            local start_2760622 = a_2760619.start
            local length_2760623 = a_2760619.length
            tmp_2760624 = _Int_add(start_2760622, length_2760623)
            tmp_2763300 = start_2760622
          end
          ::cont_2760625::
          do
            local a_2760626 = tmp_2763300
            local tmp_2760627 = a_2760626 >= tmp_2760624
            if tmp_2760627 then
              return NONE_217
            end
            local tmp_2760628 = {base_2760621, a_2760626}
            local x_2760629 = tmp_2759918(tmp_2760628)
            local tmp_2760630 = a_2760616(x_2760629)
            if tmp_2760630 then
              local tmp_2760631 = {tag = "SOME", payload = x_2760629}
              return tmp_2760631
            else
              local tmp_2760632 = _Int_add(a_2760626, 1)
              tmp_2763300 = tmp_2760632
              goto cont_2760625
            end
          end
        end
        return tmp_2760618
      end
      local exists_2760635 = function(a_2760636)
        local tmp_2760638 = function(a_2760639)
          local base_2760641, tmp_2760644, tmp_2763301
          do
            base_2760641 = a_2760639.base
            local start_2760642 = a_2760639.start
            local length_2760643 = a_2760639.length
            tmp_2760644 = _Int_add(start_2760642, length_2760643)
            tmp_2763301 = start_2760642
          end
          ::cont_2760645::
          do
            local a_2760646 = tmp_2763301
            local tmp_2760647 = a_2760646 >= tmp_2760644
            if tmp_2760647 then
              return false
            end
            local tmp_2760648 = {base_2760641, a_2760646}
            local tmp_2760649 = tmp_2759918(tmp_2760648)
            local tmp_2760650 = a_2760636(tmp_2760649)
            if tmp_2760650 then
              return true
            else
              local tmp_2760651 = _Int_add(a_2760646, 1)
              tmp_2763301 = tmp_2760651
              goto cont_2760645
            end
          end
        end
        return tmp_2760638
      end
      local all_2760654 = function(a_2760655)
        local tmp_2760657 = function(a_2760658)
          local base_2760660, tmp_2760663, tmp_2763302
          do
            base_2760660 = a_2760658.base
            local start_2760661 = a_2760658.start
            local length_2760662 = a_2760658.length
            tmp_2760663 = _Int_add(start_2760661, length_2760662)
            tmp_2763302 = start_2760661
          end
          ::cont_2760664::
          do
            local a_2760665 = tmp_2763302
            local tmp_2760666 = a_2760665 >= tmp_2760663
            if tmp_2760666 then
              return true
            end
            local tmp_2760667 = {base_2760660, a_2760665}
            local tmp_2760668 = tmp_2759918(tmp_2760667)
            local tmp_2760669 = a_2760655(tmp_2760668)
            if tmp_2760669 then
              local tmp_2760670 = _Int_add(a_2760665, 1)
              tmp_2763302 = tmp_2760670
              goto cont_2760664
            else
              return false
            end
          end
        end
        return tmp_2760657
      end
      local collate_2760673 = function(a_2760674)
        local tmp_2760676 = function(a_2760677)
          local base_2760680, base_PRIME_2760686, tmp_2760691, tmp_2760692, tmp_2763304, tmp_2763303
          do
            local tmp_2760679 = a_2760677[1]
            base_2760680 = tmp_2760679.base
            local tmp_2760681 = a_2760677[1]
            local start_2760682 = tmp_2760681.start
            local tmp_2760683 = a_2760677[1]
            local length_2760684 = tmp_2760683.length
            local tmp_2760685 = a_2760677[2]
            base_PRIME_2760686 = tmp_2760685.base
            local tmp_2760687 = a_2760677[2]
            local start_PRIME_2760688 = tmp_2760687.start
            local tmp_2760689 = a_2760677[2]
            local length_PRIME_2760690 = tmp_2760689.length
            tmp_2760691 = _Int_add(start_2760682, length_2760684)
            tmp_2760692 = _Int_add(start_PRIME_2760688, length_PRIME_2760690)
            tmp_2763303, tmp_2763304 = start_2760682, start_PRIME_2760688
          end
          ::cont_2760693::
          do
            local i_2760695, j_2760694 = tmp_2763303, tmp_2763304
            local tmp_2760696 = tmp_2760691 <= i_2760695
            local tmp_2760697 = tmp_2760692 <= j_2760694
            local tmp_2760698
            if tmp_2760696 then
              tmp_2760698 = tmp_2760697
            else
              tmp_2760698 = false
            end
            ::cont_2760723::
            if tmp_2760698 then
              return EQUAL_154
            end
            local tmp_2760699
            if tmp_2760696 then
              local tmp_2760722 = not tmp_2760697
              tmp_2760699 = tmp_2760722
            else
              tmp_2760699 = false
            end
            ::cont_2760721::
            local tmp_2760701
            do
              if tmp_2760699 then
                return LESS_155
              end
              local tmp_2760700 = not tmp_2760696
              if tmp_2760700 then
                tmp_2760701 = tmp_2760697
              else
                tmp_2760701 = false
              end
            end
            ::cont_2760720::
            local tmp_2760703
            do
              if tmp_2760701 then
                return GREATER_153
              end
              local tmp_2760702 = not tmp_2760696
              if tmp_2760702 then
                local tmp_2760719 = not tmp_2760697
                tmp_2760703 = tmp_2760719
              else
                tmp_2760703 = false
              end
            end
            ::cont_2760718::
            if tmp_2760703 then
              goto then_2763305
            else
              _raise(_Match, "mono-sequence.sml:454:29")
            end
            ::then_2763305::
            do
              local tmp_2760704 = {base_2760680, i_2760695}
              local tmp_2760705 = tmp_2759918(tmp_2760704)
              local tmp_2760706 = {base_PRIME_2760686, j_2760694}
              local tmp_2760707 = tmp_2759918(tmp_2760706)
              local tmp_2760708 = {tmp_2760705, tmp_2760707}
              local exp_2760709 = a_2760674(tmp_2760708)
              local tmp_2760710 = exp_2760709
              local tmp_2760711 = tmp_2760710 == "EQUAL"
              if tmp_2760711 then
                local tmp_2760712 = _Int_add(i_2760695, 1)
                local tmp_2760713 = _Int_add(j_2760694, 1)
                tmp_2763303 = tmp_2760712
                tmp_2763304 = tmp_2760713
                goto cont_2760693
              else
                return exp_2760709
              end
            end
          end
        end
        return tmp_2760676
      end
      array_2760724 = function(a_2760725)
        local n_2760727, init_2760728, tmp_2760730
        do
          n_2760727 = a_2760725[1]
          init_2760728 = a_2760725[2]
          local tmp_2760729 = n_2760727 < 0
          if tmp_2760729 then
            tmp_2760730 = true
          else
            local tmp_2760734 = maxLen_2759932 < n_2760727
            tmp_2760730 = tmp_2760734
          end
        end
        ::cont_2760733::
        if tmp_2760730 then
          _raise(_Size, "mono-sequence.sml:470:27")
        else
          local tmp_2760732 = {n_2760727, init_2760728}
          return tmp_2759931(tmp_2760732)
        end
      end
      tabulate_2760735 = function(a_2760736)
        local n_2760738 = a_2760736[1]
        local f_2760739 = a_2760736[2]
        local tmp_2760740 = maxLen_2759932 < n_2760738
        if tmp_2760740 then
          _raise(_Size, "mono-sequence.sml:475:27")
        end
        local tmp_2760742 = tabulate_1832960(n_2760738, f_2760739)
        local tmp_2760743 = {n_2760738, tmp_2760742}
        return tmp_2759929(tmp_2760743)
      end
      sub_2760745 = function(a_2760746)
        local a_2760748, i_2760749, tmp_2760751
        do
          a_2760748 = a_2760746[1]
          i_2760749 = a_2760746[2]
          local tmp_2760750 = 0 <= i_2760749
          do
            if tmp_2760750 then
              goto then_2763306
            else
              tmp_2760751 = false
              goto cont_2760754
            end
            ::then_2763306::
            do
              local tmp_2760755 = length_2759933(a_2760748)
              local tmp_2760756 = i_2760749 < tmp_2760755
              tmp_2760751 = tmp_2760756
            end
          end
        end
        ::cont_2760754::
        if tmp_2760751 then
          goto then_2763307
        else
          _raise(_Subscript, "mono-sequence.sml:482:22")
        end
        ::then_2763307::
        do
          local tmp_2760752 = {a_2760748, i_2760749}
          return tmp_2759928(tmp_2760752)
        end
      end
      update_2760758 = function(a_2760759)
        local a_2760761, i_2760762, x_2760763, tmp_2760765
        do
          a_2760761 = a_2760759[1]
          i_2760762 = a_2760759[2]
          x_2760763 = a_2760759[3]
          local tmp_2760764 = 0 <= i_2760762
          do
            if tmp_2760764 then
              goto then_2763308
            else
              tmp_2760765 = false
              goto cont_2760768
            end
            ::then_2763308::
            do
              local tmp_2760769 = length_2759933(a_2760761)
              local tmp_2760770 = i_2760762 < tmp_2760769
              tmp_2760765 = tmp_2760770
            end
          end
        end
        ::cont_2760768::
        if tmp_2760765 then
          goto then_2763309
        else
          _raise(_Subscript, "mono-sequence.sml:486:28")
        end
        ::then_2763309::
        do
          local tmp_2760766 = {a_2760761, i_2760762, x_2760763}
          return tmp_2759927(tmp_2760766)
        end
      end
      copy_2760772 = function(a_2760773)
        local src_2760775, dst_2760776, di_2760777, srcLen_2760778, tmp_2760780
        do
          src_2760775 = a_2760773.src
          dst_2760776 = a_2760773.dst
          di_2760777 = a_2760773.di
          srcLen_2760778 = length_2759933(src_2760775)
          local tmp_2760779 = 0 <= di_2760777
          do
            if tmp_2760779 then
              goto then_2763310
            else
              tmp_2760780 = false
              goto cont_2760792
            end
            ::then_2763310::
            do
              local tmp_2760793 = _Int_add(di_2760777, srcLen_2760778)
              local tmp_2760794 = length_2759933(dst_2760776)
              local tmp_2760795 = tmp_2760793 <= tmp_2760794
              tmp_2760780 = tmp_2760795
            end
          end
        end
        ::cont_2760792::
        if tmp_2760780 then
          goto then_2763311
        else
          _raise(_Subscript, "mono-sequence.sml:499:36")
        end
        ::then_2763311::
        do
          local tmp_2763312 = 0
          ::cont_2760781::
          do
            local a_2760782 = tmp_2763312
            local tmp_2760783 = a_2760782 >= srcLen_2760778
            if tmp_2760783 then
              return nil
            end
            local tmp_2760784 = _Int_add(di_2760777, a_2760782)
            local tmp_2760785 = {src_2760775, a_2760782}
            local tmp_2760786 = tmp_2759928(tmp_2760785)
            local tmp_2760787 = {dst_2760776, tmp_2760784, tmp_2760786}
            local tmp_2763313 = tmp_2759927(tmp_2760787)
            local tmp_2760788 = _Int_add(a_2760782, 1)
            tmp_2763312 = tmp_2760788
            goto cont_2760781
          end
        end
      end
      copyVec_2760798 = function(a_2760799)
        local src_2760801, dst_2760802, di_2760803, srcLen_2760804, tmp_2760806
        do
          src_2760801 = a_2760799.src
          dst_2760802 = a_2760799.dst
          di_2760803 = a_2760799.di
          srcLen_2760804 = length_2759924(src_2760801)
          local tmp_2760805 = 0 <= di_2760803
          do
            if tmp_2760805 then
              goto then_2763314
            else
              tmp_2760806 = false
              goto cont_2760818
            end
            ::then_2763314::
            do
              local tmp_2760819 = _Int_add(di_2760803, srcLen_2760804)
              local tmp_2760820 = length_2759933(dst_2760802)
              local tmp_2760821 = tmp_2760819 <= tmp_2760820
              tmp_2760806 = tmp_2760821
            end
          end
        end
        ::cont_2760818::
        if tmp_2760806 then
          goto then_2763315
        else
          _raise(_Subscript, "mono-sequence.sml:513:39")
        end
        ::then_2763315::
        do
          local tmp_2763316 = 0
          ::cont_2760807::
          do
            local a_2760808 = tmp_2763316
            local tmp_2760809 = a_2760808 >= srcLen_2760804
            if tmp_2760809 then
              return nil
            end
            local tmp_2760810 = _Int_add(di_2760803, a_2760808)
            local tmp_2760811 = {src_2760801, a_2760808}
            local tmp_2760812 = tmp_2759918(tmp_2760811)
            local tmp_2760813 = {dst_2760802, tmp_2760810, tmp_2760812}
            local tmp_2763317 = tmp_2759927(tmp_2760813)
            local tmp_2760814 = _Int_add(a_2760808, 1)
            tmp_2763316 = tmp_2760814
            goto cont_2760807
          end
        end
      end
      appi_2760824 = function(a_2760825)
        local tmp_2760827 = function(a_2760828)
          local n_2760830 = length_2759933(a_2760828)
          local tmp_2763318 = 0
          ::cont_2760831::
          do
            local a_2760832 = tmp_2763318
            local tmp_2760833 = a_2760832 >= n_2760830
            if tmp_2760833 then
              return nil
            end
            local tmp_2760834 = {a_2760828, a_2760832}
            local tmp_2760835 = tmp_2759928(tmp_2760834)
            local tmp_2760836 = {a_2760832, tmp_2760835}
            local tmp_2763319 = a_2760825(tmp_2760836)
            local tmp_2760837 = _Int_add(a_2760832, 1)
            tmp_2763318 = tmp_2760837
            goto cont_2760831
          end
        end
        return tmp_2760827
      end
      app_2760841 = function(a_2760842)
        local tmp_2760844 = function(a_2760845)
          local n_2760847 = length_2759933(a_2760845)
          local tmp_2763320 = 0
          ::cont_2760848::
          do
            local a_2760849 = tmp_2763320
            local tmp_2760850 = a_2760849 >= n_2760847
            if tmp_2760850 then
              return nil
            end
            local tmp_2760851 = {a_2760845, a_2760849}
            local tmp_2760852 = tmp_2759928(tmp_2760851)
            local tmp_2763321 = a_2760842(tmp_2760852)
            local tmp_2760853 = _Int_add(a_2760849, 1)
            tmp_2763320 = tmp_2760853
            goto cont_2760848
          end
        end
        return tmp_2760844
      end
      modifyi_2760857 = function(a_2760858)
        local tmp_2760860 = function(a_2760861)
          local n_2760863 = length_2759933(a_2760861)
          local tmp_2763322 = 0
          ::cont_2760864::
          do
            local a_2760865 = tmp_2763322
            local tmp_2760866 = a_2760865 >= n_2760863
            if tmp_2760866 then
              return nil
            end
            local tmp_2760867 = {a_2760861, a_2760865}
            local x_2760868 = tmp_2759928(tmp_2760867)
            local tmp_2760869 = {a_2760865, x_2760868}
            local y_2760870 = a_2760858(tmp_2760869)
            local tmp_2760871 = {a_2760861, a_2760865, y_2760870}
            local tmp_2763323 = tmp_2759927(tmp_2760871)
            local tmp_2760872 = _Int_add(a_2760865, 1)
            tmp_2763322 = tmp_2760872
            goto cont_2760864
          end
        end
        return tmp_2760860
      end
      modify_2760877 = function(a_2760878)
        local tmp_2760880 = function(a_2760881)
          local n_2760883 = length_2759933(a_2760881)
          local tmp_2763324 = 0
          ::cont_2760884::
          do
            local a_2760885 = tmp_2763324
            local tmp_2760886 = a_2760885 >= n_2760883
            if tmp_2760886 then
              return nil
            end
            local tmp_2760887 = {a_2760881, a_2760885}
            local x_2760888 = tmp_2759928(tmp_2760887)
            local y_2760889 = a_2760878(x_2760888)
            local tmp_2760890 = {a_2760881, a_2760885, y_2760889}
            local tmp_2763325 = tmp_2759927(tmp_2760890)
            local tmp_2760891 = _Int_add(a_2760885, 1)
            tmp_2763324 = tmp_2760891
            goto cont_2760884
          end
        end
        return tmp_2760880
      end
      foldli_2760896 = function(a_2760897)
        local tmp_2760899 = function(a_2760900)
          local tmp_2760902 = function(a_2760903)
            local n_2760905 = length_2759933(a_2760903)
            local tmp_2763326, tmp_2763327 = 0, a_2760900
            ::cont_2760906::
            do
              local i_2760908, acc_2760907 = tmp_2763326, tmp_2763327
              local tmp_2760909 = i_2760908 >= n_2760905
              if tmp_2760909 then
                return acc_2760907
              end
              local tmp_2760910 = _Int_add(i_2760908, 1)
              local tmp_2760911 = {a_2760903, i_2760908}
              local tmp_2760912 = tmp_2759928(tmp_2760911)
              local tmp_2760913 = {i_2760908, tmp_2760912, acc_2760907}
              local tmp_2760914 = a_2760897(tmp_2760913)
              tmp_2763326 = tmp_2760910
              tmp_2763327 = tmp_2760914
              goto cont_2760906
            end
          end
          return tmp_2760902
        end
        return tmp_2760899
      end
      foldri_2760918 = function(a_2760919)
        local tmp_2760921 = function(a_2760922)
          local tmp_2760924 = function(a_2760925)
            local tmp_2763329, tmp_2763328
            do
              local tmp_2760927 = length_2759933(a_2760925)
              local tmp_2760928 = _Int_sub(tmp_2760927, 1)
              tmp_2763328, tmp_2763329 = tmp_2760928, a_2760922
            end
            ::cont_2760929::
            do
              local i_2760931, acc_2760930 = tmp_2763328, tmp_2763329
              local tmp_2760932 = i_2760931 < 0
              if tmp_2760932 then
                return acc_2760930
              end
              local tmp_2760933 = _Int_sub(i_2760931, 1)
              local tmp_2760934 = {a_2760925, i_2760931}
              local tmp_2760935 = tmp_2759928(tmp_2760934)
              local tmp_2760936 = {i_2760931, tmp_2760935, acc_2760930}
              local tmp_2760937 = a_2760919(tmp_2760936)
              tmp_2763328 = tmp_2760933
              tmp_2763329 = tmp_2760937
              goto cont_2760929
            end
          end
          return tmp_2760924
        end
        return tmp_2760921
      end
      foldl_2760941 = function(a_2760942)
        local tmp_2760944 = function(a_2760945)
          local tmp_2760947 = function(a_2760948)
            local n_2760950 = length_2759933(a_2760948)
            local tmp_2763330, tmp_2763331 = 0, a_2760945
            ::cont_2760951::
            do
              local i_2760953, acc_2760952 = tmp_2763330, tmp_2763331
              local tmp_2760954 = i_2760953 >= n_2760950
              if tmp_2760954 then
                return acc_2760952
              end
              local tmp_2760955 = _Int_add(i_2760953, 1)
              local tmp_2760956 = {a_2760948, i_2760953}
              local tmp_2760957 = tmp_2759928(tmp_2760956)
              local tmp_2760958 = {tmp_2760957, acc_2760952}
              local tmp_2760959 = a_2760942(tmp_2760958)
              tmp_2763330 = tmp_2760955
              tmp_2763331 = tmp_2760959
              goto cont_2760951
            end
          end
          return tmp_2760947
        end
        return tmp_2760944
      end
      foldr_2760963 = function(a_2760964)
        local tmp_2760966 = function(a_2760967)
          local tmp_2760969 = function(a_2760970)
            local tmp_2763333, tmp_2763332
            do
              local tmp_2760972 = length_2759933(a_2760970)
              local tmp_2760973 = _Int_sub(tmp_2760972, 1)
              tmp_2763332, tmp_2763333 = tmp_2760973, a_2760967
            end
            ::cont_2760974::
            do
              local i_2760976, acc_2760975 = tmp_2763332, tmp_2763333
              local tmp_2760977 = i_2760976 < 0
              if tmp_2760977 then
                return acc_2760975
              end
              local tmp_2760978 = _Int_sub(i_2760976, 1)
              local tmp_2760979 = {a_2760970, i_2760976}
              local tmp_2760980 = tmp_2759928(tmp_2760979)
              local tmp_2760981 = {tmp_2760980, acc_2760975}
              local tmp_2760982 = a_2760964(tmp_2760981)
              tmp_2763332 = tmp_2760978
              tmp_2763333 = tmp_2760982
              goto cont_2760974
            end
          end
          return tmp_2760969
        end
        return tmp_2760966
      end
      findi_2760986 = function(a_2760987)
        local tmp_2760989 = function(a_2760990)
          local n_2760992 = length_2759933(a_2760990)
          local tmp_2763334 = 0
          ::cont_2760993::
          do
            local a_2760994 = tmp_2763334
            local tmp_2760995 = a_2760994 >= n_2760992
            if tmp_2760995 then
              return NONE_217
            end
            local tmp_2760996 = {a_2760990, a_2760994}
            local x_2760997 = tmp_2759928(tmp_2760996)
            local tmp_2760998 = {a_2760994, x_2760997}
            local tmp_2760999 = a_2760987(tmp_2760998)
            if tmp_2760999 then
              local tmp_2761000 = {a_2760994, x_2760997}
              local tmp_2761001 = {tag = "SOME", payload = tmp_2761000}
              return tmp_2761001
            else
              local tmp_2761002 = _Int_add(a_2760994, 1)
              tmp_2763334 = tmp_2761002
              goto cont_2760993
            end
          end
        end
        return tmp_2760989
      end
      find_2761006 = function(a_2761007)
        local tmp_2761009 = function(a_2761010)
          local n_2761012 = length_2759933(a_2761010)
          local tmp_2763335 = 0
          ::cont_2761013::
          do
            local a_2761014 = tmp_2763335
            local tmp_2761015 = a_2761014 >= n_2761012
            if tmp_2761015 then
              return NONE_217
            end
            local tmp_2761016 = {a_2761010, a_2761014}
            local x_2761017 = tmp_2759928(tmp_2761016)
            local tmp_2761018 = a_2761007(x_2761017)
            if tmp_2761018 then
              local tmp_2761019 = {tag = "SOME", payload = x_2761017}
              return tmp_2761019
            else
              local tmp_2761020 = _Int_add(a_2761014, 1)
              tmp_2763335 = tmp_2761020
              goto cont_2761013
            end
          end
        end
        return tmp_2761009
      end
      exists_2761024 = function(a_2761025)
        local tmp_2761027 = function(a_2761028)
          local n_2761030 = length_2759933(a_2761028)
          local tmp_2763336 = 0
          ::cont_2761031::
          do
            local a_2761032 = tmp_2763336
            local tmp_2761033 = a_2761032 >= n_2761030
            if tmp_2761033 then
              return false
            end
            local tmp_2761034 = {a_2761028, a_2761032}
            local tmp_2761035 = tmp_2759928(tmp_2761034)
            local tmp_2761036 = a_2761025(tmp_2761035)
            if tmp_2761036 then
              return true
            else
              local tmp_2761037 = _Int_add(a_2761032, 1)
              tmp_2763336 = tmp_2761037
              goto cont_2761031
            end
          end
        end
        return tmp_2761027
      end
      all_2761041 = function(a_2761042)
        local tmp_2761044 = function(a_2761045)
          local n_2761047 = length_2759933(a_2761045)
          local tmp_2763337 = 0
          ::cont_2761048::
          do
            local a_2761049 = tmp_2763337
            local tmp_2761050 = a_2761049 >= n_2761047
            if tmp_2761050 then
              return true
            end
            local tmp_2761051 = {a_2761045, a_2761049}
            local tmp_2761052 = tmp_2759928(tmp_2761051)
            local tmp_2761053 = a_2761042(tmp_2761052)
            if tmp_2761053 then
              local tmp_2761054 = _Int_add(a_2761049, 1)
              tmp_2763337 = tmp_2761054
              goto cont_2761048
            else
              return false
            end
          end
        end
        return tmp_2761044
      end
      collate_2761058 = function(a_2761059)
        local tmp_2761061 = function(a_2761062)
          local xs_2761064 = a_2761062[1]
          local ys_2761065 = a_2761062[2]
          local xl_2761066 = length_2759933(xs_2761064)
          local yl_2761067 = length_2759933(ys_2761065)
          local tmp_2763338 = 0
          ::cont_2761068::
          do
            local a_2761069 = tmp_2763338
            local tmp_2761070 = xl_2761066 <= a_2761069
            local tmp_2761071 = yl_2761067 <= a_2761069
            local tmp_2761072
            if tmp_2761070 then
              tmp_2761072 = tmp_2761071
            else
              tmp_2761072 = false
            end
            ::cont_2761096::
            if tmp_2761072 then
              return EQUAL_154
            end
            local tmp_2761073
            if tmp_2761070 then
              local tmp_2761095 = not tmp_2761071
              tmp_2761073 = tmp_2761095
            else
              tmp_2761073 = false
            end
            ::cont_2761094::
            local tmp_2761075
            do
              if tmp_2761073 then
                return LESS_155
              end
              local tmp_2761074 = not tmp_2761070
              if tmp_2761074 then
                tmp_2761075 = tmp_2761071
              else
                tmp_2761075 = false
              end
            end
            ::cont_2761093::
            local tmp_2761077
            do
              if tmp_2761075 then
                return GREATER_153
              end
              local tmp_2761076 = not tmp_2761070
              if tmp_2761076 then
                local tmp_2761092 = not tmp_2761071
                tmp_2761077 = tmp_2761092
              else
                tmp_2761077 = false
              end
            end
            ::cont_2761091::
            if tmp_2761077 then
              goto then_2763339
            else
              _raise(_Match, "mono-sequence.sml:621:49")
            end
            ::then_2763339::
            do
              local tmp_2761078 = {xs_2761064, a_2761069}
              local tmp_2761079 = tmp_2759928(tmp_2761078)
              local tmp_2761080 = {ys_2761065, a_2761069}
              local tmp_2761081 = tmp_2759928(tmp_2761080)
              local tmp_2761082 = {tmp_2761079, tmp_2761081}
              local exp_2761083 = a_2761059(tmp_2761082)
              local tmp_2761084 = exp_2761083
              local tmp_2761085 = tmp_2761084 == "EQUAL"
              if tmp_2761085 then
                local tmp_2761086 = _Int_add(a_2761069, 1)
                tmp_2763338 = tmp_2761086
                goto cont_2761068
              else
                return exp_2761083
              end
            end
          end
        end
        return tmp_2761061
      end
      toList_2761099 = function(a_2761100)
        local tmp_2761102 = foldr_2760963(_COLON_COLON_1)
        local tmp_2761103 = tmp_2761102(nil)
        return tmp_2761103(a_2761100)
      end
      vector_2761106 = function(a_2761107)
        local tmp_2761109 = length_2759933(a_2761107)
        local tmp_2761110
        do
          local tmp_2761113 = foldr_2760963(_COLON_COLON_1)
          local tmp_2761114 = tmp_2761113(nil)
          tmp_2761110 = tmp_2761114(a_2761107)
          goto cont_2761112
        end
        ::cont_2761112::
        local tmp_2761111 = {tmp_2761109, tmp_2761110}
        return tmp_2759920(tmp_2761111)
      end
      fromVector_2761118 = function(a_2761119)
        local tmp_2761121 = length_2759924(a_2761119)
        local tmp_2761122
        do
          local tmp_2761125 = foldr_2760113(_COLON_COLON_1)
          local tmp_2761126 = tmp_2761125(nil)
          tmp_2761122 = tmp_2761126(a_2761119)
          goto cont_2761124
        end
        ::cont_2761124::
        local tmp_2761123 = {tmp_2761121, tmp_2761122}
        return tmp_2759929(tmp_2761123)
      end
      length_2761130 = function(tmp_2761131)
        local tmp_2761133 = tmp_2761131.length
        return tmp_2761133
      end
      sub_2761134 = function(a_2761135)
        local base_2761138, start_2761140, i_2761143, tmp_2761145
        do
          local tmp_2761137 = a_2761135[1]
          base_2761138 = tmp_2761137.base
          local tmp_2761139 = a_2761135[1]
          start_2761140 = tmp_2761139.start
          local tmp_2761141 = a_2761135[1]
          local length_2761142 = tmp_2761141.length
          i_2761143 = a_2761135[2]
          local tmp_2761144 = 0 <= i_2761143
          if tmp_2761144 then
            local tmp_2761150 = i_2761143 < length_2761142
            tmp_2761145 = tmp_2761150
          else
            tmp_2761145 = false
          end
        end
        ::cont_2761149::
        if tmp_2761145 then
          goto then_2763340
        else
          _raise(_Subscript, "mono-sequence.sml:645:44")
        end
        ::then_2763340::
        do
          local tmp_2761146 = _Int_add(start_2761140, i_2761143)
          local tmp_2761147 = {base_2761138, tmp_2761146}
          return tmp_2759928(tmp_2761147)
        end
      end
      update_2761151 = function(a_2761152)
        local base_2761155, start_2761157, i_2761160, x_2761161, tmp_2761163
        do
          local tmp_2761154 = a_2761152[1]
          base_2761155 = tmp_2761154.base
          local tmp_2761156 = a_2761152[1]
          start_2761157 = tmp_2761156.start
          local tmp_2761158 = a_2761152[1]
          local length_2761159 = tmp_2761158.length
          i_2761160 = a_2761152[2]
          x_2761161 = a_2761152[3]
          local tmp_2761162 = 0 <= i_2761160
          if tmp_2761162 then
            local tmp_2761168 = i_2761160 < length_2761159
            tmp_2761163 = tmp_2761168
          else
            tmp_2761163 = false
          end
        end
        ::cont_2761167::
        if tmp_2761163 then
          goto then_2763341
        else
          _raise(_Subscript, "mono-sequence.sml:649:50")
        end
        ::then_2763341::
        do
          local tmp_2761164 = _Int_add(start_2761157, i_2761160)
          local tmp_2761165 = {base_2761155, tmp_2761164, x_2761161}
          return tmp_2759927(tmp_2761165)
        end
      end
      full_2761169 = function(a_2761170)
        local tmp_2761172 = length_2759933(a_2761170)
        local tmp_2761173 = {base = a_2761170, length = tmp_2761172, start = 0}
        return tmp_2761173
      end
      slice_2761175 = function(a_2761176)
        do
          local tmp_2761178 = a_2761176[3]
          local tmp_2761179 = tmp_2761178.tag
          local tmp_2761180 = tmp_2761179 == "NONE"
          if tmp_2761180 then
            goto then_2763342
          else
            goto else_2763343
          end
        end
        ::then_2763342::
        do
          local v_2761181, i_2761182, n_2761183, tmp_2761185
          do
            v_2761181 = a_2761176[1]
            i_2761182 = a_2761176[2]
            n_2761183 = length_2759933(v_2761181)
            local tmp_2761184 = 0 <= i_2761182
            if tmp_2761184 then
              local tmp_2761190 = i_2761182 <= n_2761183
              tmp_2761185 = tmp_2761190
            else
              tmp_2761185 = false
            end
          end
          ::cont_2761189::
          if tmp_2761185 then
            local tmp_2761186 = _Int_sub(n_2761183, i_2761182)
            local tmp_2761187 = {base = v_2761181, length = tmp_2761186, start = i_2761182}
            return tmp_2761187
          else
            _raise(_Subscript, "mono-sequence.sml:655:33")
          end
        end
        ::else_2763343::
        do
          local tmp_2761192 = a_2761176[3]
          local tmp_2761193 = tmp_2761192.tag
          local tmp_2761194 = tmp_2761193 == "SOME"
          if tmp_2761194 then
            goto then_2763344
          else
            _raise(_Match, "mono-sequence.sml:651:5")
          end
        end
        ::then_2763344::
        do
          local v_2761195, i_2761196, n_2761198, tmp_2761200
          do
            v_2761195 = a_2761176[1]
            i_2761196 = a_2761176[2]
            local tmp_2761197 = a_2761176[3]
            n_2761198 = tmp_2761197.payload
            local tmp_2761199 = 0 <= i_2761196
            do
              if tmp_2761199 then
                goto then_2763345
              else
                tmp_2761200 = false
                goto cont_2761203
              end
              ::then_2763345::
              do
                do
                  local tmp_2761204 = 0 <= n_2761198
                  if tmp_2761204 then
                    goto then_2763346
                  else
                    tmp_2761200 = false
                    goto cont_2761203
                  end
                end
                ::then_2763346::
                do
                  local tmp_2761205 = _Int_add(i_2761196, n_2761198)
                  local tmp_2761206 = length_2759933(v_2761195)
                  local tmp_2761207 = tmp_2761205 <= tmp_2761206
                  tmp_2761200 = tmp_2761207
                end
              end
            end
          end
          ::cont_2761203::
          if tmp_2761200 then
            local tmp_2761201 = {base = v_2761195, length = n_2761198, start = i_2761196}
            return tmp_2761201
          else
            _raise(_Subscript, "mono-sequence.sml:660:32")
          end
        end
      end
      subslice_2761210 = function(a_2761211)
        local tmp_2761213 = a_2761211[3]
        local tmp_2761214 = tmp_2761213.tag
        local tmp_2761215 = tmp_2761214 == "NONE"
        if tmp_2761215 then
          local base_2761217, start_2761219, length_2761221, i_2761222, tmp_2761224
          do
            local tmp_2761216 = a_2761211[1]
            base_2761217 = tmp_2761216.base
            local tmp_2761218 = a_2761211[1]
            start_2761219 = tmp_2761218.start
            local tmp_2761220 = a_2761211[1]
            length_2761221 = tmp_2761220.length
            i_2761222 = a_2761211[2]
            local tmp_2761223 = 0 <= i_2761222
            if tmp_2761223 then
              local tmp_2761230 = i_2761222 <= length_2761221
              tmp_2761224 = tmp_2761230
            else
              tmp_2761224 = false
            end
          end
          ::cont_2761229::
          if tmp_2761224 then
            local tmp_2761225 = _Int_add(start_2761219, i_2761222)
            local tmp_2761226 = _Int_sub(length_2761221, i_2761222)
            local tmp_2761227 = {base = base_2761217, length = tmp_2761226, start = tmp_2761225}
            return tmp_2761227
          else
            _raise(_Subscript, "mono-sequence.sml:664:55")
          end
        end
        local tmp_2761231 = a_2761211[3]
        local tmp_2761232 = tmp_2761231.tag
        local tmp_2761233 = tmp_2761232 == "SOME"
        if tmp_2761233 then
          local base_2761235, start_2761237, i_2761240, n_2761242, tmp_2761244
          do
            local tmp_2761234 = a_2761211[1]
            base_2761235 = tmp_2761234.base
            local tmp_2761236 = a_2761211[1]
            start_2761237 = tmp_2761236.start
            local tmp_2761238 = a_2761211[1]
            local length_2761239 = tmp_2761238.length
            i_2761240 = a_2761211[2]
            local tmp_2761241 = a_2761211[3]
            n_2761242 = tmp_2761241.payload
            local tmp_2761243 = 0 <= i_2761240
            if tmp_2761243 then
              local tmp_2761249 = 0 <= n_2761242
              if tmp_2761249 then
                local tmp_2761250 = _Int_add(i_2761240, n_2761242)
                local tmp_2761251 = tmp_2761250 <= length_2761239
                tmp_2761244 = tmp_2761251
              else
                tmp_2761244 = false
              end
            else
              tmp_2761244 = false
            end
          end
          ::cont_2761248::
          if tmp_2761244 then
            local tmp_2761245 = _Int_add(start_2761237, i_2761240)
            local tmp_2761246 = {base = base_2761235, length = n_2761242, start = tmp_2761245}
            return tmp_2761246
          else
            _raise(_Subscript, "mono-sequence.sml:668:57")
          end
        else
          _raise(_Match, "mono-sequence.sml:661:5")
        end
      end
      base_2761253 = function(a_2761254)
        local b_2761256 = a_2761254.base
        local start_2761257 = a_2761254.start
        local length_2761258 = a_2761254.length
        local tmp_2761259 = {b_2761256, start_2761257, length_2761258}
        return tmp_2761259
      end
      copy_2761260 = function(a_2761261)
        local base_2761264, start_2761266, length_2761268, dst_2761269, di_2761270, tmp_2761272
        do
          local tmp_2761263 = a_2761261.src
          base_2761264 = tmp_2761263.base
          local tmp_2761265 = a_2761261.src
          start_2761266 = tmp_2761265.start
          local tmp_2761267 = a_2761261.src
          length_2761268 = tmp_2761267.length
          dst_2761269 = a_2761261.dst
          di_2761270 = a_2761261.di
          local tmp_2761271 = di_2761270 < 0
          do
            if tmp_2761271 then
              tmp_2761272 = true
              goto cont_2761298
            end
            local tmp_2761299 = length_2759933(dst_2761269)
            local tmp_2761300 = _Int_add(di_2761270, length_2761268)
            local tmp_2761301 = tmp_2761299 < tmp_2761300
            tmp_2761272 = tmp_2761301
          end
        end
        ::cont_2761298::
        do
          if tmp_2761272 then
            _raise(_Subscript, "mono-sequence.sml:684:14")
          end
          local tmp_2761274 = start_2761266 >= di_2761270
          if tmp_2761274 then
            goto then_2763347
          else
            goto else_2763348
          end
        end
        ::then_2763347::
        do
          local tmp_2763349 = 0
          ::cont_2761275::
          do
            local a_2761276 = tmp_2763349
            local tmp_2761277 = a_2761276 >= length_2761268
            if tmp_2761277 then
              return nil
            end
            local tmp_2761278 = _Int_add(di_2761270, a_2761276)
            local tmp_2761279 = _Int_add(start_2761266, a_2761276)
            local tmp_2761280 = {base_2761264, tmp_2761279}
            local tmp_2761281 = tmp_2759928(tmp_2761280)
            local tmp_2761282 = {dst_2761269, tmp_2761278, tmp_2761281}
            local tmp_2763350 = tmp_2759927(tmp_2761282)
            local tmp_2761283 = _Int_add(a_2761276, 1)
            tmp_2763349 = tmp_2761283
            goto cont_2761275
          end
        end
        ::else_2763348::
        local tmp_2763351
        do
          local tmp_2761286 = _Int_sub(length_2761268, 1)
          tmp_2763351 = tmp_2761286
        end
        ::cont_2761287::
        do
          local a_2761288 = tmp_2763351
          local tmp_2761289 = a_2761288 < 0
          if tmp_2761289 then
            return nil
          end
          local tmp_2761290 = _Int_add(di_2761270, a_2761288)
          local tmp_2761291 = _Int_add(start_2761266, a_2761288)
          local tmp_2761292 = {base_2761264, tmp_2761291}
          local tmp_2761293 = tmp_2759928(tmp_2761292)
          local tmp_2761294 = {dst_2761269, tmp_2761290, tmp_2761293}
          local tmp_2763352 = tmp_2759927(tmp_2761294)
          local tmp_2761295 = _Int_sub(a_2761288, 1)
          tmp_2763351 = tmp_2761295
          goto cont_2761287
        end
      end
      copyVec_2761303 = function(a_2761304)
        local base_2761307, start_2761309, length_2761311, dst_2761312, di_2761313, tmp_2761315
        do
          local tmp_2761306 = a_2761304.src
          base_2761307 = tmp_2761306.base
          local tmp_2761308 = a_2761304.src
          start_2761309 = tmp_2761308.start
          local tmp_2761310 = a_2761304.src
          length_2761311 = tmp_2761310.length
          dst_2761312 = a_2761304.dst
          di_2761313 = a_2761304.di
          local tmp_2761314 = di_2761313 < 0
          do
            if tmp_2761314 then
              tmp_2761315 = true
              goto cont_2761328
            end
            local tmp_2761329 = length_2759933(dst_2761312)
            local tmp_2761330 = _Int_add(di_2761313, length_2761311)
            local tmp_2761331 = tmp_2761329 < tmp_2761330
            tmp_2761315 = tmp_2761331
          end
        end
        ::cont_2761328::
        if tmp_2761315 then
          _raise(_Subscript, "mono-sequence.sml:699:14")
        end
        local tmp_2763353 = 0
        ::cont_2761317::
        do
          local a_2761318 = tmp_2763353
          local tmp_2761319 = a_2761318 >= length_2761311
          if tmp_2761319 then
            return nil
          end
          local tmp_2761320 = _Int_add(di_2761313, a_2761318)
          local tmp_2761321 = _Int_add(start_2761309, a_2761318)
          local tmp_2761322 = {base_2761307, tmp_2761321}
          local tmp_2761323 = tmp_2759918(tmp_2761322)
          local tmp_2761324 = {dst_2761312, tmp_2761320, tmp_2761323}
          local tmp_2763354 = tmp_2759927(tmp_2761324)
          local tmp_2761325 = _Int_add(a_2761318, 1)
          tmp_2763353 = tmp_2761325
          goto cont_2761317
        end
      end
      isEmpty_2761333 = function(a_2761334)
        local length_2761336 = a_2761334.length
        local tmp_2761337 = length_2761336 == 0
        return tmp_2761337
      end
      getItem_2761338 = function(a_2761339)
        local base_2761341, start_2761342, length_2761343
        do
          base_2761341 = a_2761339.base
          start_2761342 = a_2761339.start
          length_2761343 = a_2761339.length
          local tmp_2761344 = length_2761343 > 0
          if tmp_2761344 then
            goto then_2763355
          else
            return NONE_217
          end
        end
        ::then_2763355::
        do
          local tmp_2761345 = {base_2761341, start_2761342}
          local tmp_2761346 = tmp_2759928(tmp_2761345)
          local tmp_2761347 = _Int_add(start_2761342, 1)
          local tmp_2761348 = _Int_sub(length_2761343, 1)
          local tmp_2761349 = {base = base_2761341, length = tmp_2761348, start = tmp_2761347}
          local tmp_2761350 = {tmp_2761346, tmp_2761349}
          local tmp_2761351 = {tag = "SOME", payload = tmp_2761350}
          return tmp_2761351
        end
      end
      appi_2761353 = function(a_2761354)
        local tmp_2761356 = function(a_2761357)
          local base_2761359 = a_2761357.base
          local start_2761360 = a_2761357.start
          local length_2761361 = a_2761357.length
          local tmp_2763356 = 0
          ::cont_2761362::
          do
            local a_2761363 = tmp_2763356
            local tmp_2761364 = a_2761363 >= length_2761361
            if tmp_2761364 then
              return nil
            end
            local tmp_2761365 = _Int_add(start_2761360, a_2761363)
            local tmp_2761366 = {base_2761359, tmp_2761365}
            local tmp_2761367 = tmp_2759928(tmp_2761366)
            local tmp_2761368 = {a_2761363, tmp_2761367}
            local tmp_2763357 = a_2761354(tmp_2761368)
            local tmp_2761369 = _Int_add(a_2761363, 1)
            tmp_2763356 = tmp_2761369
            goto cont_2761362
          end
        end
        return tmp_2761356
      end
      app_2761372 = function(a_2761373)
        local tmp_2761375 = function(a_2761376)
          local base_2761378, tmp_2761381, tmp_2763358
          do
            base_2761378 = a_2761376.base
            local start_2761379 = a_2761376.start
            local length_2761380 = a_2761376.length
            tmp_2761381 = _Int_add(start_2761379, length_2761380)
            tmp_2763358 = start_2761379
          end
          ::cont_2761382::
          do
            local a_2761383 = tmp_2763358
            local tmp_2761384 = a_2761383 >= tmp_2761381
            if tmp_2761384 then
              return nil
            end
            local tmp_2761385 = {base_2761378, a_2761383}
            local tmp_2761386 = tmp_2759928(tmp_2761385)
            local tmp_2763359 = a_2761373(tmp_2761386)
            local tmp_2761387 = _Int_add(a_2761383, 1)
            tmp_2763358 = tmp_2761387
            goto cont_2761382
          end
        end
        return tmp_2761375
      end
      modifyi_2761390 = function(a_2761391)
        local tmp_2761393 = function(a_2761394)
          local base_2761396 = a_2761394.base
          local start_2761397 = a_2761394.start
          local length_2761398 = a_2761394.length
          local tmp_2763360 = 0
          ::cont_2761399::
          do
            local a_2761400 = tmp_2763360
            local tmp_2761401 = a_2761400 >= length_2761398
            if tmp_2761401 then
              return nil
            end
            local tmp_2761402 = _Int_add(start_2761397, a_2761400)
            local tmp_2761403 = {base_2761396, tmp_2761402}
            local x_2761404 = tmp_2759928(tmp_2761403)
            local tmp_2761405 = {a_2761400, x_2761404}
            local y_2761406 = a_2761391(tmp_2761405)
            local tmp_2761407 = {base_2761396, tmp_2761402, y_2761406}
            local tmp_2763361 = tmp_2759927(tmp_2761407)
            local tmp_2761408 = _Int_add(a_2761400, 1)
            tmp_2763360 = tmp_2761408
            goto cont_2761399
          end
        end
        return tmp_2761393
      end
      modify_2761412 = function(a_2761413)
        local tmp_2761415 = function(a_2761416)
          local base_2761418, tmp_2761421, tmp_2763362
          do
            base_2761418 = a_2761416.base
            local start_2761419 = a_2761416.start
            local length_2761420 = a_2761416.length
            tmp_2761421 = _Int_add(start_2761419, length_2761420)
            tmp_2763362 = start_2761419
          end
          ::cont_2761422::
          do
            local a_2761423 = tmp_2763362
            local tmp_2761424 = a_2761423 >= tmp_2761421
            if tmp_2761424 then
              return nil
            end
            local tmp_2761425 = {base_2761418, a_2761423}
            local x_2761426 = tmp_2759928(tmp_2761425)
            local y_2761427 = a_2761413(x_2761426)
            local tmp_2761428 = {base_2761418, a_2761423, y_2761427}
            local tmp_2763363 = tmp_2759927(tmp_2761428)
            local tmp_2761429 = _Int_add(a_2761423, 1)
            tmp_2763362 = tmp_2761429
            goto cont_2761422
          end
        end
        return tmp_2761415
      end
      foldli_2761433 = function(a_2761434)
        local tmp_2761436 = function(a_2761437)
          local tmp_2761439 = function(a_2761440)
            local base_2761442 = a_2761440.base
            local start_2761443 = a_2761440.start
            local length_2761444 = a_2761440.length
            local tmp_2763364, tmp_2763365 = 0, a_2761437
            ::cont_2761445::
            do
              local i_2761447, acc_2761446 = tmp_2763364, tmp_2763365
              local tmp_2761448 = i_2761447 >= length_2761444
              if tmp_2761448 then
                return acc_2761446
              end
              local tmp_2761449 = _Int_add(i_2761447, 1)
              local tmp_2761450 = _Int_add(start_2761443, i_2761447)
              local tmp_2761451 = {base_2761442, tmp_2761450}
              local tmp_2761452 = tmp_2759928(tmp_2761451)
              local tmp_2761453 = {i_2761447, tmp_2761452, acc_2761446}
              local tmp_2761454 = a_2761434(tmp_2761453)
              tmp_2763364 = tmp_2761449
              tmp_2763365 = tmp_2761454
              goto cont_2761445
            end
          end
          return tmp_2761439
        end
        return tmp_2761436
      end
      foldri_2761457 = function(a_2761458)
        local tmp_2761460 = function(a_2761461)
          local tmp_2761463 = function(a_2761464)
            local base_2761466, start_2761467, tmp_2763367, tmp_2763366
            do
              base_2761466 = a_2761464.base
              start_2761467 = a_2761464.start
              local length_2761468 = a_2761464.length
              local tmp_2761469 = _Int_sub(length_2761468, 1)
              tmp_2763366, tmp_2763367 = tmp_2761469, a_2761461
            end
            ::cont_2761470::
            do
              local i_2761472, acc_2761471 = tmp_2763366, tmp_2763367
              local tmp_2761473 = i_2761472 < 0
              if tmp_2761473 then
                return acc_2761471
              end
              local tmp_2761474 = _Int_sub(i_2761472, 1)
              local tmp_2761475 = _Int_add(start_2761467, i_2761472)
              local tmp_2761476 = {base_2761466, tmp_2761475}
              local tmp_2761477 = tmp_2759928(tmp_2761476)
              local tmp_2761478 = {i_2761472, tmp_2761477, acc_2761471}
              local tmp_2761479 = a_2761458(tmp_2761478)
              tmp_2763366 = tmp_2761474
              tmp_2763367 = tmp_2761479
              goto cont_2761470
            end
          end
          return tmp_2761463
        end
        return tmp_2761460
      end
      foldl_2761482 = function(a_2761483)
        local tmp_2761485 = function(a_2761486)
          local tmp_2761488 = function(a_2761489)
            local base_2761491, tmp_2761494, tmp_2763369, tmp_2763368
            do
              base_2761491 = a_2761489.base
              local start_2761492 = a_2761489.start
              local length_2761493 = a_2761489.length
              tmp_2761494 = _Int_add(start_2761492, length_2761493)
              tmp_2763368, tmp_2763369 = start_2761492, a_2761486
            end
            ::cont_2761495::
            do
              local i_2761497, acc_2761496 = tmp_2763368, tmp_2763369
              local tmp_2761498 = i_2761497 >= tmp_2761494
              if tmp_2761498 then
                return acc_2761496
              end
              local tmp_2761499 = _Int_add(i_2761497, 1)
              local tmp_2761500 = {base_2761491, i_2761497}
              local tmp_2761501 = tmp_2759928(tmp_2761500)
              local tmp_2761502 = {tmp_2761501, acc_2761496}
              local tmp_2761503 = a_2761483(tmp_2761502)
              tmp_2763368 = tmp_2761499
              tmp_2763369 = tmp_2761503
              goto cont_2761495
            end
          end
          return tmp_2761488
        end
        return tmp_2761485
      end
      foldr_2761506 = function(a_2761507)
        local tmp_2761509 = function(a_2761510)
          local tmp_2761512 = function(a_2761513)
            local base_2761515, start_2761516, tmp_2763371, tmp_2763370
            do
              base_2761515 = a_2761513.base
              start_2761516 = a_2761513.start
              local length_2761517 = a_2761513.length
              local tmp_2761518 = _Int_add(start_2761516, length_2761517)
              local tmp_2761519 = _Int_sub(tmp_2761518, 1)
              tmp_2763370, tmp_2763371 = tmp_2761519, a_2761510
            end
            ::cont_2761520::
            do
              local i_2761522, acc_2761521 = tmp_2763370, tmp_2763371
              local tmp_2761523 = i_2761522 < start_2761516
              if tmp_2761523 then
                return acc_2761521
              end
              local tmp_2761524 = _Int_sub(i_2761522, 1)
              local tmp_2761525 = {base_2761515, i_2761522}
              local tmp_2761526 = tmp_2759928(tmp_2761525)
              local tmp_2761527 = {tmp_2761526, acc_2761521}
              local tmp_2761528 = a_2761507(tmp_2761527)
              tmp_2763370 = tmp_2761524
              tmp_2763371 = tmp_2761528
              goto cont_2761520
            end
          end
          return tmp_2761512
        end
        return tmp_2761509
      end
      findi_2761531 = function(a_2761532)
        local tmp_2761534 = function(a_2761535)
          local base_2761537 = a_2761535.base
          local start_2761538 = a_2761535.start
          local length_2761539 = a_2761535.length
          local tmp_2763372 = 0
          ::cont_2761540::
          do
            local a_2761541 = tmp_2763372
            local tmp_2761542 = a_2761541 >= length_2761539
            if tmp_2761542 then
              return NONE_217
            end
            local tmp_2761543 = _Int_add(start_2761538, a_2761541)
            local tmp_2761544 = {base_2761537, tmp_2761543}
            local x_2761545 = tmp_2759928(tmp_2761544)
            local tmp_2761546 = {a_2761541, x_2761545}
            local tmp_2761547 = a_2761532(tmp_2761546)
            if tmp_2761547 then
              local tmp_2761548 = {a_2761541, x_2761545}
              local tmp_2761549 = {tag = "SOME", payload = tmp_2761548}
              return tmp_2761549
            else
              local tmp_2761550 = _Int_add(a_2761541, 1)
              tmp_2763372 = tmp_2761550
              goto cont_2761540
            end
          end
        end
        return tmp_2761534
      end
      find_2761553 = function(a_2761554)
        local tmp_2761556 = function(a_2761557)
          local base_2761559, tmp_2761562, tmp_2763373
          do
            base_2761559 = a_2761557.base
            local start_2761560 = a_2761557.start
            local length_2761561 = a_2761557.length
            tmp_2761562 = _Int_add(start_2761560, length_2761561)
            tmp_2763373 = start_2761560
          end
          ::cont_2761563::
          do
            local a_2761564 = tmp_2763373
            local tmp_2761565 = a_2761564 >= tmp_2761562
            if tmp_2761565 then
              return NONE_217
            end
            local tmp_2761566 = {base_2761559, a_2761564}
            local x_2761567 = tmp_2759928(tmp_2761566)
            local tmp_2761568 = a_2761554(x_2761567)
            if tmp_2761568 then
              local tmp_2761569 = {tag = "SOME", payload = x_2761567}
              return tmp_2761569
            else
              local tmp_2761570 = _Int_add(a_2761564, 1)
              tmp_2763373 = tmp_2761570
              goto cont_2761563
            end
          end
        end
        return tmp_2761556
      end
      exists_2761573 = function(a_2761574)
        local tmp_2761576 = function(a_2761577)
          local base_2761579, tmp_2761582, tmp_2763374
          do
            base_2761579 = a_2761577.base
            local start_2761580 = a_2761577.start
            local length_2761581 = a_2761577.length
            tmp_2761582 = _Int_add(start_2761580, length_2761581)
            tmp_2763374 = start_2761580
          end
          ::cont_2761583::
          do
            local a_2761584 = tmp_2763374
            local tmp_2761585 = a_2761584 >= tmp_2761582
            if tmp_2761585 then
              return false
            end
            local tmp_2761586 = {base_2761579, a_2761584}
            local tmp_2761587 = tmp_2759928(tmp_2761586)
            local tmp_2761588 = a_2761574(tmp_2761587)
            if tmp_2761588 then
              return true
            else
              local tmp_2761589 = _Int_add(a_2761584, 1)
              tmp_2763374 = tmp_2761589
              goto cont_2761583
            end
          end
        end
        return tmp_2761576
      end
      all_2761592 = function(a_2761593)
        local tmp_2761595 = function(a_2761596)
          local base_2761598, tmp_2761601, tmp_2763375
          do
            base_2761598 = a_2761596.base
            local start_2761599 = a_2761596.start
            local length_2761600 = a_2761596.length
            tmp_2761601 = _Int_add(start_2761599, length_2761600)
            tmp_2763375 = start_2761599
          end
          ::cont_2761602::
          do
            local a_2761603 = tmp_2763375
            local tmp_2761604 = a_2761603 >= tmp_2761601
            if tmp_2761604 then
              return true
            end
            local tmp_2761605 = {base_2761598, a_2761603}
            local tmp_2761606 = tmp_2759928(tmp_2761605)
            local tmp_2761607 = a_2761593(tmp_2761606)
            if tmp_2761607 then
              local tmp_2761608 = _Int_add(a_2761603, 1)
              tmp_2763375 = tmp_2761608
              goto cont_2761602
            else
              return false
            end
          end
        end
        return tmp_2761595
      end
      collate_2761611 = function(a_2761612)
        local tmp_2761614 = function(a_2761615)
          local base_2761618, base_PRIME_2761624, tmp_2761629, tmp_2761630, tmp_2763377, tmp_2763376
          do
            local tmp_2761617 = a_2761615[1]
            base_2761618 = tmp_2761617.base
            local tmp_2761619 = a_2761615[1]
            local start_2761620 = tmp_2761619.start
            local tmp_2761621 = a_2761615[1]
            local length_2761622 = tmp_2761621.length
            local tmp_2761623 = a_2761615[2]
            base_PRIME_2761624 = tmp_2761623.base
            local tmp_2761625 = a_2761615[2]
            local start_PRIME_2761626 = tmp_2761625.start
            local tmp_2761627 = a_2761615[2]
            local length_PRIME_2761628 = tmp_2761627.length
            tmp_2761629 = _Int_add(start_2761620, length_2761622)
            tmp_2761630 = _Int_add(start_PRIME_2761626, length_PRIME_2761628)
            tmp_2763376, tmp_2763377 = start_2761620, start_PRIME_2761626
          end
          ::cont_2761631::
          do
            local i_2761633, j_2761632 = tmp_2763376, tmp_2763377
            local tmp_2761634 = tmp_2761629 <= i_2761633
            local tmp_2761635 = tmp_2761630 <= j_2761632
            local tmp_2761636
            if tmp_2761634 then
              tmp_2761636 = tmp_2761635
            else
              tmp_2761636 = false
            end
            ::cont_2761661::
            if tmp_2761636 then
              return EQUAL_154
            end
            local tmp_2761637
            if tmp_2761634 then
              local tmp_2761660 = not tmp_2761635
              tmp_2761637 = tmp_2761660
            else
              tmp_2761637 = false
            end
            ::cont_2761659::
            local tmp_2761639
            do
              if tmp_2761637 then
                return LESS_155
              end
              local tmp_2761638 = not tmp_2761634
              if tmp_2761638 then
                tmp_2761639 = tmp_2761635
              else
                tmp_2761639 = false
              end
            end
            ::cont_2761658::
            local tmp_2761641
            do
              if tmp_2761639 then
                return GREATER_153
              end
              local tmp_2761640 = not tmp_2761634
              if tmp_2761640 then
                local tmp_2761657 = not tmp_2761635
                tmp_2761641 = tmp_2761657
              else
                tmp_2761641 = false
              end
            end
            ::cont_2761656::
            if tmp_2761641 then
              goto then_2763378
            else
              _raise(_Match, "mono-sequence.sml:812:29")
            end
            ::then_2763378::
            do
              local tmp_2761642 = {base_2761618, i_2761633}
              local tmp_2761643 = tmp_2759928(tmp_2761642)
              local tmp_2761644 = {base_PRIME_2761624, j_2761632}
              local tmp_2761645 = tmp_2759928(tmp_2761644)
              local tmp_2761646 = {tmp_2761643, tmp_2761645}
              local exp_2761647 = a_2761612(tmp_2761646)
              local tmp_2761648 = exp_2761647
              local tmp_2761649 = tmp_2761648 == "EQUAL"
              if tmp_2761649 then
                local tmp_2761650 = _Int_add(i_2761633, 1)
                local tmp_2761651 = _Int_add(j_2761632, 1)
                tmp_2763376 = tmp_2761650
                tmp_2763377 = tmp_2761651
                goto cont_2761631
              else
                return exp_2761647
              end
            end
          end
        end
        return tmp_2761614
      end
      vector_2761662 = function(a_2761663)
        local tmp_2761665 = a_2761663.length
        local tmp_2761666 = foldr_2761506(_COLON_COLON_1)
        local tmp_2761667 = tmp_2761666(nil)
        local tmp_2761668 = tmp_2761667(a_2761663)
        local tmp_2761669 = {tmp_2761665, tmp_2761668}
        return tmp_2759920(tmp_2761669)
      end
      UnsafeMonoVector_2761673 = {sub = tmp_2759918}
      UnsafeMonoArray_2761674 = {create = create_2759930, sub = tmp_2759928, update = tmp_2759927}
      MonoVectorSlice_2761675 = {all = all_2760654, app = app_2760432, appi = appi_2760413, base = base_2760379, collate = collate_2760673, concat = concat_2760386, exists = exists_2760635, find = find_2760615, findi = findi_2760593, foldl = foldl_2760544, foldli = foldli_2760495, foldr = foldr_2760568, foldri = foldri_2760519, full = full_2760295, getItem = getItem_2760398, isEmpty = isEmpty_2760393, length = length_2760274, map = map_2760473, mapi = mapi_2760450, slice = slice_2760301, sub = sub_2760278, subslice = subslice_2760336, vector = vector_2759921}
    end
    local MonoVector_2761676 = {all = all_2760191, app = app_2759995, append = append_2760256, appi = appi_2759978, collate = collate_2760208, concat = tmp_2759926, exists = exists_2760174, find = find_2760156, findi = findi_2760136, foldl = foldl_2760091, foldli = foldli_2760046, foldr = foldr_2760113, foldri = foldri_2760068, fromList = fromList_2759925, length = length_2759924, map = map_2760029, mapi = mapi_2760011, maxLen = maxLen_2759923, prepend = prepend_2760265, sub = sub_2759944, tabulate = tabulate_2759936, toList = toList_2760249, update = update_2759957}
    local MonoArraySlice_2761677 = {all = all_2761592, app = app_2761372, appi = appi_2761353, base = base_2761253, collate = collate_2761611, copy = copy_2761260, copyVec = copyVec_2761303, exists = exists_2761573, find = find_2761553, findi = findi_2761531, foldl = foldl_2761482, foldli = foldli_2761433, foldr = foldr_2761506, foldri = foldri_2761457, full = full_2761169, getItem = getItem_2761338, isEmpty = isEmpty_2761333, length = length_2761130, modify = modify_2761412, modifyi = modifyi_2761390, slice = slice_2761175, sub = sub_2761134, subslice = subslice_2761210, update = update_2761151, vector = vector_2761662}
    local MonoArray_2761678 = {all = all_2761041, app = app_2760841, appi = appi_2760824, array = array_2760724, collate = collate_2761058, copy = copy_2760772, copyVec = copyVec_2760798, exists = exists_2761024, find = find_2761006, findi = findi_2760986, foldl = foldl_2760941, foldli = foldli_2760896, foldr = foldr_2760963, foldri = foldri_2760918, fromList = fromList_2759934, fromVector = fromVector_2761118, length = length_2759933, maxLen = maxLen_2759932, modify = modify_2760877, modifyi = modifyi_2760857, sub = sub_2760745, tabulate = tabulate_2760735, toList = toList_2761099, toVector = vector_2761106, update = update_2760758, vector = vector_2761106}
    local tmp_2761679 = {_MonoArray = MonoArray_2761678, _MonoArraySlice = MonoArraySlice_2761677, _MonoVector = MonoVector_2761676, _MonoVectorSlice = MonoVectorSlice_2761675, _UnsafeMonoArray = UnsafeMonoArray_2761674, _UnsafeMonoVector = UnsafeMonoVector_2761673}
    return tmp_2761679
  end
  local unsafeFromListN_2761680 = function(a_2761681)
    local xs_2761683 = a_2761681[2]
    return implode_2759872(xs_2761683)
  end
  local unsafeFromListRevN_2761684 = function(a_2761685)
    local xs_2761687 = a_2761685[2]
    return implodeRev_2759887(xs_2761687)
  end
  local sliceToVector_2761688 = function(a_2761689)
    local base_2761691 = a_2761689.base
    local start_2761692 = a_2761689.start
    local length_2761693 = a_2761689.length
    return substring_2759850(base_2761691, start_2761692, length_2761693)
  end
  local unsafeCreateWithZero_2761694 = function(a_2761695)
    local tmp_2761697 = {a_2761695, 0}
    return _Array_array(tmp_2761697)
  end
  local unsafeFromListN_2761698 = function(a_2761699)
    local xs_2761701 = a_2761699[2]
    return _VectorOrArray_fromList(xs_2761701)
  end
  local LOCAL_2763445 = {}
  LOCAL_2763445[1] = MonoSequence_2759917(_VectorOrArray_fromList, length_856, n_2759914, _Array_array, unsafeCreateWithZero_2761694, unsafeFromListN_2761698, sub_602, update_606, concat_2759866, implode_2759872, size_1069, n_2759913, sliceToVector_2761688, sliceToVector_2761688, unsafeFromListN_2761680, unsafeFromListRevN_2761684, sub_2759837)
  LOCAL_2763445[2] = LOCAL_2763445[1]._MonoVector
  LOCAL_2763445[3] = LOCAL_2763445[1]._MonoVectorSlice
  LOCAL_2763445[4] = LOCAL_2763445[1]._MonoArray
  LOCAL_2763445[5] = LOCAL_2763445[1]._MonoArraySlice
  tmp_2761707 = LOCAL_2763445[3].all
  tmp_2761708 = LOCAL_2763445[3].app
  tmp_2761709 = LOCAL_2763445[3].appi
  tmp_2761710 = LOCAL_2763445[3].base
  tmp_2761711 = LOCAL_2763445[3].collate
  tmp_2761712 = LOCAL_2763445[3].concat
  tmp_2761713 = LOCAL_2763445[3].exists
  tmp_2761714 = LOCAL_2763445[3].find
  tmp_2761715 = LOCAL_2763445[3].findi
  tmp_2761716 = LOCAL_2763445[3].foldl
  tmp_2761717 = LOCAL_2763445[3].foldli
  tmp_2761718 = LOCAL_2763445[3].foldr
  tmp_2761719 = LOCAL_2763445[3].foldri
  tmp_2761720 = LOCAL_2763445[3].full
  tmp_2761721 = LOCAL_2763445[3].getItem
  tmp_2761722 = LOCAL_2763445[3].isEmpty
  tmp_2761723 = LOCAL_2763445[3].length
  tmp_2761724 = LOCAL_2763445[3].map
  tmp_2761725 = LOCAL_2763445[3].mapi
  tmp_2761726 = LOCAL_2763445[3].slice
  tmp_2761727 = LOCAL_2763445[3].sub
  tmp_2761728 = LOCAL_2763445[3].subslice
  tmp_2761729 = LOCAL_2763445[3].vector
  tmp_2761730 = LOCAL_2763445[2].all
  tmp_2761731 = LOCAL_2763445[2].app
  tmp_2761732 = LOCAL_2763445[2].append
  tmp_2761733 = LOCAL_2763445[2].appi
  tmp_2761734 = LOCAL_2763445[2].collate
  tmp_2761735 = LOCAL_2763445[2].concat
  tmp_2761736 = LOCAL_2763445[2].exists
  tmp_2761737 = LOCAL_2763445[2].find
  tmp_2761738 = LOCAL_2763445[2].findi
  tmp_2761739 = LOCAL_2763445[2].foldl
  tmp_2761740 = LOCAL_2763445[2].foldli
  tmp_2761741 = LOCAL_2763445[2].foldr
  tmp_2761742 = LOCAL_2763445[2].foldri
  tmp_2761743 = LOCAL_2763445[2].fromList
  tmp_2761744 = LOCAL_2763445[2].length
  tmp_2761745 = LOCAL_2763445[2].map
  tmp_2761746 = LOCAL_2763445[2].mapi
  tmp_2761747 = LOCAL_2763445[2].maxLen
  tmp_2761748 = LOCAL_2763445[2].prepend
  tmp_2761749 = LOCAL_2763445[2].sub
  tmp_2761750 = LOCAL_2763445[2].tabulate
  tmp_2761751 = LOCAL_2763445[2].toList
  tmp_2761752 = LOCAL_2763445[2].update
  tmp_2761753 = LOCAL_2763445[5].all
  tmp_2761754 = LOCAL_2763445[5].app
  tmp_2761755 = LOCAL_2763445[5].appi
  tmp_2761756 = LOCAL_2763445[5].base
  tmp_2761757 = LOCAL_2763445[5].collate
  tmp_2761758 = LOCAL_2763445[5].copy
  tmp_2761759 = LOCAL_2763445[5].copyVec
  tmp_2761760 = LOCAL_2763445[5].exists
  tmp_2761761 = LOCAL_2763445[5].find
  tmp_2761762 = LOCAL_2763445[5].findi
  tmp_2761763 = LOCAL_2763445[5].foldl
  tmp_2761764 = LOCAL_2763445[5].foldli
  tmp_2761765 = LOCAL_2763445[5].foldr
  tmp_2761766 = LOCAL_2763445[5].foldri
  tmp_2761767 = LOCAL_2763445[5].full
  tmp_2761768 = LOCAL_2763445[5].getItem
  tmp_2761769 = LOCAL_2763445[5].isEmpty
  tmp_2761770 = LOCAL_2763445[5].length
  tmp_2761771 = LOCAL_2763445[5].modify
  tmp_2761772 = LOCAL_2763445[5].modifyi
  tmp_2761773 = LOCAL_2763445[5].slice
  tmp_2761774 = LOCAL_2763445[5].sub
  tmp_2761775 = LOCAL_2763445[5].subslice
  tmp_2761776 = LOCAL_2763445[5].update
  tmp_2761777 = LOCAL_2763445[5].vector
  tmp_2761778 = LOCAL_2763445[4].all
  tmp_2761779 = LOCAL_2763445[4].app
  tmp_2761780 = LOCAL_2763445[4].appi
  tmp_2761781 = LOCAL_2763445[4].array
  tmp_2761782 = LOCAL_2763445[4].collate
  tmp_2761783 = LOCAL_2763445[4].copy
  tmp_2761784 = LOCAL_2763445[4].copyVec
  tmp_2761785 = LOCAL_2763445[4].exists
  tmp_2761786 = LOCAL_2763445[4].find
  tmp_2761787 = LOCAL_2763445[4].findi
  tmp_2761788 = LOCAL_2763445[4].foldl
  tmp_2761789 = LOCAL_2763445[4].foldli
  tmp_2761790 = LOCAL_2763445[4].foldr
  tmp_2761791 = LOCAL_2763445[4].foldri
  tmp_2761792 = LOCAL_2763445[4].fromList
  tmp_2761793 = LOCAL_2763445[4].fromVector
  tmp_2761794 = LOCAL_2763445[4].length
  tmp_2761795 = LOCAL_2763445[4].maxLen
  tmp_2761796 = LOCAL_2763445[4].modify
  tmp_2761797 = LOCAL_2763445[4].modifyi
  tmp_2761798 = LOCAL_2763445[4].sub
  tmp_2761799 = LOCAL_2763445[4].tabulate
  tmp_2761800 = LOCAL_2763445[4].toList
  tmp_2761801 = LOCAL_2763445[4].toVector
  tmp_2761802 = LOCAL_2763445[4].update
  tmp_2761803 = LOCAL_2763445[4].vector
end
local LOCAL_2763446 = {}
do
  LOCAL_2763446[1] = {"Io"}
  local BlockingNotSupported__tag_2761805 = {"BlockingNotSupported"}
  LOCAL_2763446[2] = {tag = BlockingNotSupported__tag_2761805}
  local ClosedStream__tag_2761807 = {"ClosedStream"}
  LOCAL_2763446[3] = {tag = ClosedStream__tag_2761807}
  LOCAL_2763446[4] = "LINE_BUF"
  local unsafeSub_2761810 = function(a_2761811)
    local v_2761813 = a_2761811[1]
    local i_2761814 = a_2761811[2]
    local tmp_2761815 = {v_2761813, i_2761814}
    local tmp_2761816 = sub_2759837(tmp_2761815)
    local tmp_2761817 = tmp_2761816
    local tmp_2761818 = tmp_2761817 & 0xFF
    return tmp_2761818
  end
  local fromList_2761820 = function(a_2761821)
    local tmp_2761823 = function(a_2761824)
      do
        local tmp_2761826 = a_2761824 < 0x0
        if tmp_2761826 then
          goto then_2763379
        else
          return chr_2759904(a_2761824)
        end
      end
      ::then_2763379::
      _raise(_Overflow, "word-1.sml:52:39")
    end
    local tmp_2761828 = map_454(tmp_2761823)
    local tmp_2761829 = tmp_2761828(a_2761821)
    return implode_2759872(tmp_2761829)
  end
  LOCAL_2763446[9] = function(a_2761833)
    local xs_2761835 = a_2761833[2]
    local tmp_2761836 = function(a_2761837)
      do
        local tmp_2761839 = a_2761837 < 0x0
        if tmp_2761839 then
          goto then_2763380
        else
          return chr_2759904(a_2761837)
        end
      end
      ::then_2763380::
      _raise(_Overflow, "word-1.sml:52:39")
    end
    local tmp_2761841 = map_454(tmp_2761836)
    local tmp_2761842 = tmp_2761841(xs_2761835)
    return implode_2759872(tmp_2761842)
  end
  LOCAL_2763446[10] = function(a_2761846)
    local xs_2761848 = a_2761846[2]
    local tmp_2761849 = function(a_2761850)
      do
        local tmp_2761852 = a_2761850 < 0x0
        if tmp_2761852 then
          goto then_2763381
        else
          return chr_2759904(a_2761850)
        end
      end
      ::then_2763381::
      _raise(_Overflow, "word-1.sml:52:39")
    end
    local tmp_2761854 = map_454(tmp_2761849)
    local tmp_2761855 = tmp_2761854(xs_2761848)
    return implodeRev_2759887(tmp_2761855)
  end
  LOCAL_2763446[11] = function(a_2761859)
    local base_2761861 = a_2761859.base
    local start_2761862 = a_2761859.start
    local length_2761863 = a_2761859.length
    return substring_2759850(base_2761861, start_2761862, length_2761863)
  end
  LOCAL_2763446[12] = function(a_2761865)
    local tmp_2761867 = 0x0 & 0xFF
    local tmp_2761868 = {a_2761865, tmp_2761867}
    return _Array_array(tmp_2761868)
  end
  LOCAL_2763446[13] = function(a_2761870)
    local xs_2761872 = a_2761870[2]
    return _VectorOrArray_fromList(xs_2761872)
  end
  LOCAL_2763446[14] = MonoSequence_2759917(_VectorOrArray_fromList, length_856, n_2759914, _Array_array, LOCAL_2763446[12], LOCAL_2763446[13], sub_602, update_606, concat_2759866, fromList_2761820, size_1069, n_2759913, LOCAL_2763446[11], LOCAL_2763446[11], LOCAL_2763446[9], LOCAL_2763446[10], unsafeSub_2761810)
  LOCAL_2763446[5] = LOCAL_2763446[14]._MonoVector
  LOCAL_2763446[6] = LOCAL_2763446[14]._MonoVectorSlice
  LOCAL_2763446[7] = LOCAL_2763446[14]._MonoArray
  LOCAL_2763446[8] = LOCAL_2763446[14]._MonoArraySlice
end
local tmp_2761878 = LOCAL_2763446[6].all
local tmp_2761879 = LOCAL_2763446[6].app
local tmp_2761880 = LOCAL_2763446[6].appi
local tmp_2761881 = LOCAL_2763446[6].base
LOCAL_2763446[15] = LOCAL_2763446[6].collate
LOCAL_2763446[16] = LOCAL_2763446[6].concat
LOCAL_2763446[17] = LOCAL_2763446[6].exists
LOCAL_2763446[18] = LOCAL_2763446[6].find
LOCAL_2763446[19] = LOCAL_2763446[6].findi
LOCAL_2763446[20] = LOCAL_2763446[6].foldl
LOCAL_2763446[21] = LOCAL_2763446[6].foldli
LOCAL_2763446[22] = LOCAL_2763446[6].foldr
LOCAL_2763446[23] = LOCAL_2763446[6].foldri
LOCAL_2763446[24] = LOCAL_2763446[6].full
LOCAL_2763446[25] = LOCAL_2763446[6].getItem
LOCAL_2763446[26] = LOCAL_2763446[6].isEmpty
LOCAL_2763446[27] = LOCAL_2763446[6].length
LOCAL_2763446[28] = LOCAL_2763446[6].map
LOCAL_2763446[29] = LOCAL_2763446[6].mapi
LOCAL_2763446[30] = LOCAL_2763446[6].slice
LOCAL_2763446[31] = LOCAL_2763446[6].sub
LOCAL_2763446[32] = LOCAL_2763446[6].subslice
LOCAL_2763446[33] = LOCAL_2763446[6].vector
LOCAL_2763446[34] = LOCAL_2763446[5].all
LOCAL_2763446[35] = LOCAL_2763446[5].app
LOCAL_2763446[36] = LOCAL_2763446[5].append
LOCAL_2763446[37] = LOCAL_2763446[5].appi
LOCAL_2763446[38] = LOCAL_2763446[5].collate
LOCAL_2763446[39] = LOCAL_2763446[5].concat
LOCAL_2763446[40] = LOCAL_2763446[5].exists
LOCAL_2763446[41] = LOCAL_2763446[5].find
LOCAL_2763446[42] = LOCAL_2763446[5].findi
LOCAL_2763446[43] = LOCAL_2763446[5].foldl
LOCAL_2763446[44] = LOCAL_2763446[5].foldli
LOCAL_2763446[45] = LOCAL_2763446[5].foldr
LOCAL_2763446[46] = LOCAL_2763446[5].foldri
LOCAL_2763446[47] = LOCAL_2763446[5].fromList
LOCAL_2763446[48] = LOCAL_2763446[5].length
LOCAL_2763446[49] = LOCAL_2763446[5].map
LOCAL_2763446[50] = LOCAL_2763446[5].mapi
LOCAL_2763446[51] = LOCAL_2763446[5].maxLen
LOCAL_2763446[52] = LOCAL_2763446[5].prepend
LOCAL_2763446[53] = LOCAL_2763446[5].sub
LOCAL_2763446[54] = LOCAL_2763446[5].tabulate
LOCAL_2763446[55] = LOCAL_2763446[5].toList
LOCAL_2763446[56] = LOCAL_2763446[5].update
LOCAL_2763446[57] = LOCAL_2763446[8].all
LOCAL_2763446[58] = LOCAL_2763446[8].app
LOCAL_2763446[59] = LOCAL_2763446[8].appi
LOCAL_2763446[60] = LOCAL_2763446[8].base
LOCAL_2763446[61] = LOCAL_2763446[8].collate
LOCAL_2763446[62] = LOCAL_2763446[8].copy
LOCAL_2763446[63] = LOCAL_2763446[8].copyVec
LOCAL_2763446[64] = LOCAL_2763446[8].exists
LOCAL_2763446[65] = LOCAL_2763446[8].find
LOCAL_2763446[66] = LOCAL_2763446[8].findi
LOCAL_2763446[67] = LOCAL_2763446[8].foldl
LOCAL_2763446[68] = LOCAL_2763446[8].foldli
LOCAL_2763446[69] = LOCAL_2763446[8].foldr
LOCAL_2763446[70] = LOCAL_2763446[8].foldri
LOCAL_2763446[71] = LOCAL_2763446[8].full
LOCAL_2763446[72] = LOCAL_2763446[8].getItem
LOCAL_2763446[73] = LOCAL_2763446[8].isEmpty
LOCAL_2763446[74] = LOCAL_2763446[8].length
LOCAL_2763446[75] = LOCAL_2763446[8].modify
LOCAL_2763446[76] = LOCAL_2763446[8].modifyi
LOCAL_2763446[77] = LOCAL_2763446[8].slice
LOCAL_2763446[78] = LOCAL_2763446[8].sub
LOCAL_2763446[79] = LOCAL_2763446[8].subslice
LOCAL_2763446[80] = LOCAL_2763446[8].update
LOCAL_2763446[81] = LOCAL_2763446[8].vector
LOCAL_2763446[82] = LOCAL_2763446[7].all
LOCAL_2763446[83] = LOCAL_2763446[7].app
LOCAL_2763446[84] = LOCAL_2763446[7].appi
LOCAL_2763446[85] = LOCAL_2763446[7].array
LOCAL_2763446[86] = LOCAL_2763446[7].collate
LOCAL_2763446[87] = LOCAL_2763446[7].copy
LOCAL_2763446[88] = LOCAL_2763446[7].copyVec
LOCAL_2763446[89] = LOCAL_2763446[7].exists
LOCAL_2763446[90] = LOCAL_2763446[7].find
LOCAL_2763446[91] = LOCAL_2763446[7].findi
LOCAL_2763446[92] = LOCAL_2763446[7].foldl
LOCAL_2763446[93] = LOCAL_2763446[7].foldli
LOCAL_2763446[94] = LOCAL_2763446[7].foldr
LOCAL_2763446[95] = LOCAL_2763446[7].foldri
LOCAL_2763446[96] = LOCAL_2763446[7].fromList
LOCAL_2763446[97] = LOCAL_2763446[7].fromVector
LOCAL_2763446[98] = LOCAL_2763446[7].length
LOCAL_2763446[99] = LOCAL_2763446[7].maxLen
LOCAL_2763446[100] = LOCAL_2763446[7].modify
LOCAL_2763446[101] = LOCAL_2763446[7].modifyi
LOCAL_2763446[102] = LOCAL_2763446[7].sub
LOCAL_2763446[103] = LOCAL_2763446[7].tabulate
LOCAL_2763446[104] = LOCAL_2763446[7].toList
LOCAL_2763446[105] = LOCAL_2763446[7].toVector
LOCAL_2763446[106] = LOCAL_2763446[7].update
LOCAL_2763446[107] = LOCAL_2763446[7].vector
LOCAL_2763446[108] = function()
  local tmp_2761977 = function(eq_2761978)
    local tmp_2761980 = function(param_2761981)
      local compare_2761983 = param_2761981.compare
      local RD_2761984 = function(payload_2761985)
        local tmp_2761987 = payload_2761985
        return tmp_2761987
      end
      local WR_2761988 = function(payload_2761989)
        local tmp_2761991 = payload_2761989
        return tmp_2761991
      end
      local openVector_2761992 = function(a_2761993)
        local tmp_2761995, tmp_2761996, tmp_2762055, tmp_2762062, tmp_2762069, tmp_2762082, tmp_2762095, tmp_2762103, tmp_2762110
        do
          tmp_2761995 = {0}
          tmp_2761996 = {false}
          local readVec_2761997 = function(a_2761998)
            local x_2762002, newPos_2762007
            do
              local tmp_2762000 = a_2761998 < 0
              if tmp_2762000 then
                _raise(_Size, "prim-io.sml:112:31")
              end
              x_2762002 = tmp_2761995[1]
              local tmp_2762003 = param_2761981._Vector
              local tmp_2762004 = tmp_2762003.length
              local total_2762005 = tmp_2762004(a_2761993)
              local tmp_2762006 = _Int_add(x_2762002, a_2761998)
              do
                local tmp_2762018 = tmp_2762006 < total_2762005
                if tmp_2762018 then
                  newPos_2762007 = tmp_2762006
                else
                  newPos_2762007 = total_2762005
                end
              end
            end
            ::cont_2762017::
            tmp_2761995[1] = newPos_2762007
            local tmp_2762008 = param_2761981._VectorSlice
            local tmp_2762009 = tmp_2762008.vector
            local tmp_2762010 = param_2761981._VectorSlice
            local tmp_2762011 = tmp_2762010.slice
            local tmp_2762012 = _Int_sub(newPos_2762007, x_2762002)
            local tmp_2762013 = {tag = "SOME", payload = tmp_2762012}
            local tmp_2762014 = {a_2761993, x_2762002, tmp_2762013}
            local tmp_2762015 = tmp_2762011(tmp_2762014)
            return tmp_2762009(tmp_2762015)
          end
          local readArr_2762020 = function(a_2762021)
            local x_2762023, newPos_2762031
            do
              x_2762023 = tmp_2761995[1]
              local tmp_2762024 = param_2761981._Vector
              local tmp_2762025 = tmp_2762024.length
              local total_2762026 = tmp_2762025(a_2761993)
              local tmp_2762027 = param_2761981._ArraySlice
              local tmp_2762028 = tmp_2762027.length
              local tmp_2762029 = tmp_2762028(a_2762021)
              local tmp_2762030 = _Int_add(x_2762023, tmp_2762029)
              do
                local tmp_2762050 = tmp_2762030 < total_2762026
                if tmp_2762050 then
                  newPos_2762031 = tmp_2762030
                else
                  newPos_2762031 = total_2762026
                end
              end
            end
            ::cont_2762049::
            local tmp_2762037, tmp_2762039, tmp_2762045
            do
              local tmp_2762032 = param_2761981._ArraySlice
              local tmp_2762033 = tmp_2762032.base
              local exp_2762034 = tmp_2762033(a_2762021)
              local baseArr_2762035 = exp_2762034[1]
              local start_2762036 = exp_2762034[2]
              tmp_2762037 = _Int_sub(newPos_2762031, x_2762023)
              tmp_2761995[1] = newPos_2762031
              local tmp_2762038 = param_2761981._ArraySlice
              tmp_2762039 = tmp_2762038.copyVec
              local tmp_2762040 = param_2761981._VectorSlice
              local tmp_2762041 = tmp_2762040.slice
              local tmp_2762042 = {tag = "SOME", payload = tmp_2762037}
              local tmp_2762043 = {a_2761993, x_2762023, tmp_2762042}
              local tmp_2762044 = tmp_2762041(tmp_2762043)
              tmp_2762045 = {di = start_2762036, dst = baseArr_2762035, src = tmp_2762044}
            end
            local tmp_2763382 = tmp_2762039(tmp_2762045)
            return tmp_2762037
          end
          local tmp_2762053 = param_2761981._Vector
          local tmp_2762054 = tmp_2762053.length
          tmp_2762055 = tmp_2762054(a_2761993)
          local tmp_2762056 = function(n_2762057)
            do
              local x_2762059 = tmp_2761996[1]
              if x_2762059 then
                goto then_2763383
              else
                return readVec_2761997(n_2762057)
              end
            end
            ::then_2763383::
            do
              local tmp_2762060 = {cause = LOCAL_2763446[3], ["function"] = "readVec", name = "<openVector>"}
              local tmp_2762061 = {tag = LOCAL_2763446[1], payload = tmp_2762060}
              _raise(tmp_2762061, "prim-io.sml:108:36")
            end
          end
          tmp_2762062 = {tag = "SOME", payload = tmp_2762056}
          local tmp_2762063 = function(slice_2762064)
            do
              local x_2762066 = tmp_2761996[1]
              if x_2762066 then
                goto then_2763384
              else
                return readArr_2762020(slice_2762064)
              end
            end
            ::then_2763384::
            do
              local tmp_2762067 = {cause = LOCAL_2763446[3], ["function"] = "readArr", name = "<openVector>"}
              local tmp_2762068 = {tag = LOCAL_2763446[1], payload = tmp_2762067}
              _raise(tmp_2762068, "prim-io.sml:108:36")
            end
          end
          tmp_2762069 = {tag = "SOME", payload = tmp_2762063}
          local tmp_2762070 = function(n_2762071)
            do
              local x_2762073 = tmp_2761996[1]
              if x_2762073 then
                goto then_2763385
              else
                goto else_2763386
              end
            end
            ::then_2763385::
            do
              local tmp_2762074 = {cause = LOCAL_2763446[3], ["function"] = "readVecNB", name = "<openVector>"}
              local tmp_2762075 = {tag = LOCAL_2763446[1], payload = tmp_2762074}
              _raise(tmp_2762075, "prim-io.sml:108:36")
            end
            ::else_2763386::
            local tmp_2762079 = readVec_2761997(n_2762071)
            local tmp_2762080 = {tag = "SOME", payload = tmp_2762079}
            return tmp_2762080
          end
          tmp_2762082 = {tag = "SOME", payload = tmp_2762070}
          local tmp_2762083 = function(slice_2762084)
            do
              local x_2762086 = tmp_2761996[1]
              if x_2762086 then
                goto then_2763387
              else
                goto else_2763388
              end
            end
            ::then_2763387::
            do
              local tmp_2762087 = {cause = LOCAL_2763446[3], ["function"] = "readArrNB", name = "<openVector>"}
              local tmp_2762088 = {tag = LOCAL_2763446[1], payload = tmp_2762087}
              _raise(tmp_2762088, "prim-io.sml:108:36")
            end
            ::else_2763388::
            local tmp_2762092 = readArr_2762020(slice_2762084)
            local tmp_2762093 = {tag = "SOME", payload = tmp_2762092}
            return tmp_2762093
          end
          tmp_2762095 = {tag = "SOME", payload = tmp_2762083}
          local tmp_2762096 = function(a_2762097)
            local x_2762099 = tmp_2761996[1]
            if x_2762099 then
              local tmp_2762100 = {cause = LOCAL_2763446[3], ["function"] = "block", name = "<openVector>"}
              local tmp_2762101 = {tag = LOCAL_2763446[1], payload = tmp_2762100}
              _raise(tmp_2762101, "prim-io.sml:108:36")
            else
              return nil
            end
          end
          tmp_2762103 = {tag = "SOME", payload = tmp_2762096}
          local tmp_2762104 = function(a_2762105)
            local x_2762107 = tmp_2761996[1]
            if x_2762107 then
              local tmp_2762108 = {cause = LOCAL_2763446[3], ["function"] = "canInput", name = "<openVector>"}
              local tmp_2762109 = {tag = LOCAL_2763446[1], payload = tmp_2762108}
              _raise(tmp_2762109, "prim-io.sml:108:36")
            else
              return true
            end
          end
          tmp_2762110 = {tag = "SOME", payload = tmp_2762104}
        end
        local tmp_2762111 = function(a_2762112)
          do
            local x_2762122 = tmp_2761996[1]
            if x_2762122 then
              local tmp_2762123 = {cause = LOCAL_2763446[3], ["function"] = "avail", name = "<openVector>"}
              local tmp_2762124 = {tag = LOCAL_2763446[1], payload = tmp_2762123}
              _raise(tmp_2762124, "prim-io.sml:108:36")
            end
          end
          ::cont_2762121::
          local tmp_2762114 = param_2761981._Vector
          local tmp_2762115 = tmp_2762114.length
          local tmp_2762116 = tmp_2762115(a_2761993)
          local x_2762117 = tmp_2761995[1]
          local tmp_2762118 = _Int_sub(tmp_2762116, x_2762117)
          local tmp_2762119 = {tag = "SOME", payload = tmp_2762118}
          return tmp_2762119
        end
        local tmp_2762125 = function(a_2762126)
          tmp_2761996[1] = true
          return nil
        end
        local tmp_2762128 = {avail = tmp_2762111, block = tmp_2762103, canInput = tmp_2762110, chunkSize = tmp_2762055, close = tmp_2762125, endPos = NONE_217, getPos = NONE_217, ioDesc = NONE_217, name = "<openVector>", readArr = tmp_2762069, readArrNB = tmp_2762095, readVec = tmp_2762062, readVecNB = tmp_2762082, setPos = NONE_217, verifyPos = NONE_217}
        local tmp_2762129 = tmp_2762128
        return tmp_2762129
      end
      local nullRd_2762131 = function(a_2762132)
        local tmp_2762147, tmp_2762154, tmp_2762163, tmp_2762172, tmp_2762180, tmp_2762187, tmp_2762188, tmp_2762192
        do
          local tmp_2762134 = {false}
          local tmp_2762135 = param_2761981._Vector
          local tmp_2762136 = tmp_2762135.fromList
          local empty_2762137 = tmp_2762136(nil)
          local tmp_2762138 = function(n_2762139)
            do
              local x_2762144 = tmp_2762134[1]
              if x_2762144 then
                local tmp_2762145 = {cause = LOCAL_2763446[3], ["function"] = "readVec", name = "<nullRd>"}
                local tmp_2762146 = {tag = LOCAL_2763446[1], payload = tmp_2762145}
                _raise(tmp_2762146, "prim-io.sml:149:46")
              end
            end
            ::cont_2762143::
            local tmp_2762141 = n_2762139 < 0
            if tmp_2762141 then
              _raise(_Size, "prim-io.sml:155:81")
            else
              return empty_2762137
            end
          end
          tmp_2762147 = {tag = "SOME", payload = tmp_2762138}
          local tmp_2762148 = function(slice_2762149)
            local x_2762151 = tmp_2762134[1]
            if x_2762151 then
              local tmp_2762152 = {cause = LOCAL_2763446[3], ["function"] = "readArr", name = "<nullRd>"}
              local tmp_2762153 = {tag = LOCAL_2763446[1], payload = tmp_2762152}
              _raise(tmp_2762153, "prim-io.sml:149:46")
            else
              return 0
            end
          end
          tmp_2762154 = {tag = "SOME", payload = tmp_2762148}
          local tmp_2762155 = function(n_2762156)
            local x_2762158 = tmp_2762134[1]
            if x_2762158 then
              local tmp_2762159 = {cause = LOCAL_2763446[3], ["function"] = "readVecNB", name = "<nullRd>"}
              local tmp_2762160 = {tag = LOCAL_2763446[1], payload = tmp_2762159}
              _raise(tmp_2762160, "prim-io.sml:149:46")
            else
              local tmp_2762162 = {tag = "SOME", payload = empty_2762137}
              return tmp_2762162
            end
          end
          tmp_2762163 = {tag = "SOME", payload = tmp_2762155}
          local tmp_2762164 = function(slice_2762165)
            local x_2762167 = tmp_2762134[1]
            if x_2762167 then
              local tmp_2762168 = {cause = LOCAL_2763446[3], ["function"] = "readArrNB", name = "<nullRd>"}
              local tmp_2762169 = {tag = LOCAL_2763446[1], payload = tmp_2762168}
              _raise(tmp_2762169, "prim-io.sml:149:46")
            else
              local tmp_2762171 = {tag = "SOME", payload = 0}
              return tmp_2762171
            end
          end
          tmp_2762172 = {tag = "SOME", payload = tmp_2762164}
          local tmp_2762173 = function(a_2762174)
            local x_2762176 = tmp_2762134[1]
            if x_2762176 then
              local tmp_2762177 = {cause = LOCAL_2763446[3], ["function"] = "block", name = "<nullRd>"}
              local tmp_2762178 = {tag = LOCAL_2763446[1], payload = tmp_2762177}
              _raise(tmp_2762178, "prim-io.sml:149:46")
            else
              return nil
            end
          end
          tmp_2762180 = {tag = "SOME", payload = tmp_2762173}
          local tmp_2762181 = function(a_2762182)
            local x_2762184 = tmp_2762134[1]
            if x_2762184 then
              local tmp_2762185 = {cause = LOCAL_2763446[3], ["function"] = "canInput", name = "<nullRd>"}
              local tmp_2762186 = {tag = LOCAL_2763446[1], payload = tmp_2762185}
              _raise(tmp_2762186, "prim-io.sml:149:46")
            else
              return true
            end
          end
          tmp_2762187 = {tag = "SOME", payload = tmp_2762181}
          tmp_2762188 = function(a_2762189)
            local tmp_2762191 = {tag = "SOME", payload = 0}
            return tmp_2762191
          end
          tmp_2762192 = function(a_2762193)
            tmp_2762134[1] = true
            return nil
          end
        end
        local tmp_2762195 = {avail = tmp_2762188, block = tmp_2762180, canInput = tmp_2762187, chunkSize = 1, close = tmp_2762192, endPos = NONE_217, getPos = NONE_217, ioDesc = NONE_217, name = "<nullRd>", readArr = tmp_2762154, readArrNB = tmp_2762172, readVec = tmp_2762147, readVecNB = tmp_2762163, setPos = NONE_217, verifyPos = NONE_217}
        local tmp_2762196 = tmp_2762195
        return tmp_2762196
      end
      local nullWr_2762198 = function(a_2762199)
        local tmp_2762268
        do
          local tmp_2762201 = {false}
          local tmp_2762202 = function(slice_2762203)
            do
              local x_2762205 = tmp_2762201[1]
              if x_2762205 then
                goto then_2763389
              else
                local tmp_2762210 = param_2761981._VectorSlice
                local tmp_2762211 = tmp_2762210.length
                return tmp_2762211(slice_2762203)
              end
            end
            ::then_2763389::
            do
              local tmp_2762206 = {cause = LOCAL_2763446[3], ["function"] = "writeVec", name = "<nullWr>"}
              local tmp_2762207 = {tag = LOCAL_2763446[1], payload = tmp_2762206}
              _raise(tmp_2762207, "prim-io.sml:173:46")
            end
          end
          local tmp_2762212 = {tag = "SOME", payload = tmp_2762202}
          local tmp_2762213 = function(slice_2762214)
            do
              local x_2762216 = tmp_2762201[1]
              if x_2762216 then
                goto then_2763390
              else
                local tmp_2762221 = param_2761981._ArraySlice
                local tmp_2762222 = tmp_2762221.length
                return tmp_2762222(slice_2762214)
              end
            end
            ::then_2763390::
            do
              local tmp_2762217 = {cause = LOCAL_2763446[3], ["function"] = "writeArr", name = "<nullWr>"}
              local tmp_2762218 = {tag = LOCAL_2763446[1], payload = tmp_2762217}
              _raise(tmp_2762218, "prim-io.sml:173:46")
            end
          end
          local tmp_2762223 = {tag = "SOME", payload = tmp_2762213}
          local tmp_2762224 = function(slice_2762225)
            do
              local x_2762233 = tmp_2762201[1]
              if x_2762233 then
                local tmp_2762234 = {cause = LOCAL_2763446[3], ["function"] = "writeVecNB", name = "<nullWr>"}
                local tmp_2762235 = {tag = LOCAL_2763446[1], payload = tmp_2762234}
                _raise(tmp_2762235, "prim-io.sml:173:46")
              end
            end
            ::cont_2762232::
            local tmp_2762227 = param_2761981._VectorSlice
            local tmp_2762228 = tmp_2762227.length
            local tmp_2762229 = tmp_2762228(slice_2762225)
            local tmp_2762230 = {tag = "SOME", payload = tmp_2762229}
            return tmp_2762230
          end
          local tmp_2762236 = {tag = "SOME", payload = tmp_2762224}
          local tmp_2762237 = function(slice_2762238)
            do
              local x_2762246 = tmp_2762201[1]
              if x_2762246 then
                local tmp_2762247 = {cause = LOCAL_2763446[3], ["function"] = "writeArrNB", name = "<nullWr>"}
                local tmp_2762248 = {tag = LOCAL_2763446[1], payload = tmp_2762247}
                _raise(tmp_2762248, "prim-io.sml:173:46")
              end
            end
            ::cont_2762245::
            local tmp_2762240 = param_2761981._ArraySlice
            local tmp_2762241 = tmp_2762240.length
            local tmp_2762242 = tmp_2762241(slice_2762238)
            local tmp_2762243 = {tag = "SOME", payload = tmp_2762242}
            return tmp_2762243
          end
          local tmp_2762249 = {tag = "SOME", payload = tmp_2762237}
          local tmp_2762250 = function(a_2762251)
            local x_2762253 = tmp_2762201[1]
            if x_2762253 then
              local tmp_2762254 = {cause = LOCAL_2763446[3], ["function"] = "block", name = "<nullWr>"}
              local tmp_2762255 = {tag = LOCAL_2763446[1], payload = tmp_2762254}
              _raise(tmp_2762255, "prim-io.sml:173:46")
            else
              return nil
            end
          end
          local tmp_2762257 = {tag = "SOME", payload = tmp_2762250}
          local tmp_2762258 = function(a_2762259)
            local x_2762261 = tmp_2762201[1]
            if x_2762261 then
              local tmp_2762262 = {cause = LOCAL_2763446[3], ["function"] = "canOutput", name = "<nullWr>"}
              local tmp_2762263 = {tag = LOCAL_2763446[1], payload = tmp_2762262}
              _raise(tmp_2762263, "prim-io.sml:173:46")
            else
              return true
            end
          end
          local tmp_2762264 = {tag = "SOME", payload = tmp_2762258}
          local tmp_2762265 = function(a_2762266)
            tmp_2762201[1] = true
            return nil
          end
          tmp_2762268 = {block = tmp_2762257, canOutput = tmp_2762264, chunkSize = 1, close = tmp_2762265, endPos = NONE_217, getPos = NONE_217, ioDesc = NONE_217, name = "<nullWr>", setPos = NONE_217, verifyPos = NONE_217, writeArr = tmp_2762223, writeArrNB = tmp_2762249, writeVec = tmp_2762212, writeVecNB = tmp_2762236}
        end
        local tmp_2762269 = tmp_2762268
        return tmp_2762269
      end
      local augmentReader_2762270 = function(a_2762271)
        local name_2762274, chunkSize_2762276, readVec_2762278, readArr_2762280, readVecNB_2762282, readArrNB_2762284, block_2762286, canInput_2762288, avail_2762290, getPos_2762292
        do
          local tmp_2762273 = a_2762271
          name_2762274 = tmp_2762273.name
          local tmp_2762275 = a_2762271
          chunkSize_2762276 = tmp_2762275.chunkSize
          local tmp_2762277 = a_2762271
          readVec_2762278 = tmp_2762277.readVec
          local tmp_2762279 = a_2762271
          readArr_2762280 = tmp_2762279.readArr
          local tmp_2762281 = a_2762271
          readVecNB_2762282 = tmp_2762281.readVecNB
          local tmp_2762283 = a_2762271
          readArrNB_2762284 = tmp_2762283.readArrNB
          local tmp_2762285 = a_2762271
          block_2762286 = tmp_2762285.block
          local tmp_2762287 = a_2762271
          canInput_2762288 = tmp_2762287.canInput
          local tmp_2762289 = a_2762271
          avail_2762290 = tmp_2762289.avail
          local tmp_2762291 = a_2762271
          getPos_2762292 = tmp_2762291.getPos
        end
        local setPos_2762294, endPos_2762296, verifyPos_2762298, close_2762300, ioDesc_2762302, readVec_PRIME_2762308
        do
          local tmp_2762293 = a_2762271
          setPos_2762294 = tmp_2762293.setPos
          local tmp_2762295 = a_2762271
          endPos_2762296 = tmp_2762295.endPos
          local tmp_2762297 = a_2762271
          verifyPos_2762298 = tmp_2762297.verifyPos
          local tmp_2762299 = a_2762271
          close_2762300 = tmp_2762299.close
          local tmp_2762301 = a_2762271
          ioDesc_2762302 = tmp_2762301.ioDesc
          local tmp_2762303 = param_2761981._Vector
          local tmp_2762304 = tmp_2762303.fromList
          local empty_2762305 = tmp_2762304(nil)
          local tmp_2762306 = readVec_2762278.tag
          local tmp_2762307 = tmp_2762306 == "SOME"
          do
            if tmp_2762307 then
              readVec_PRIME_2762308 = readVec_2762278
              goto cont_2762632
            end
            local tmp_2762633 = readVec_2762278.tag
            local tmp_2762634 = tmp_2762633 == "NONE"
            if tmp_2762634 then
              local tmp_2762635 = readArr_2762280.tag
              local tmp_2762636 = tmp_2762635 == "SOME"
              if tmp_2762636 then
                local ra_2762637 = readArr_2762280.payload
                local tmp_2762638 = function(n_2762639)
                  local arr_2762645, tmp_2762651, tmp_2762653, tmp_2762654
                  do
                    local tmp_2762641 = param_2761981._Array
                    local tmp_2762642 = tmp_2762641.array
                    local tmp_2762643 = param_2761981.someElem
                    local tmp_2762644 = {n_2762639, tmp_2762643}
                    arr_2762645 = tmp_2762642(tmp_2762644)
                    local tmp_2762646 = param_2761981._ArraySlice
                    local tmp_2762647 = tmp_2762646.full
                    local tmp_2762648 = tmp_2762647(arr_2762645)
                    local actual_2762649 = ra_2762637(tmp_2762648)
                    local tmp_2762650 = param_2761981._ArraySlice
                    tmp_2762651 = tmp_2762650.vector
                    local tmp_2762652 = param_2761981._ArraySlice
                    tmp_2762653 = tmp_2762652.slice
                    tmp_2762654 = {tag = "SOME", payload = actual_2762649}
                  end
                  local tmp_2762655 = {arr_2762645, 0, tmp_2762654}
                  local tmp_2762656 = tmp_2762653(tmp_2762655)
                  return tmp_2762651(tmp_2762656)
                end
                local tmp_2762661 = {tag = "SOME", payload = tmp_2762638}
                readVec_PRIME_2762308 = tmp_2762661
                goto cont_2762632
              end
              local tmp_2762662 = readArr_2762280.tag
              local tmp_2762663 = tmp_2762662 == "NONE"
              if tmp_2762663 then
                local tmp_2762666
                do
                  local tmp_2762664 = block_2762286.tag
                  local tmp_2762665 = tmp_2762664 == "SOME"
                  if tmp_2762665 then
                    local tmp_2762752 = readVecNB_2762282.tag
                    local tmp_2762753 = tmp_2762752 == "SOME"
                    tmp_2762666 = tmp_2762753
                  else
                    tmp_2762666 = false
                  end
                end
                ::cont_2762751::
                local tmp_2762694
                do
                  if tmp_2762666 then
                    local block_PRIME_2762667 = block_2762286.payload
                    local rvNB_2762668 = readVecNB_2762282.payload
                    local tmp_2762669 = function(n_2762670)
                      do
                        local tmp_2762672 = n_2762670 < 0
                        if tmp_2762672 then
                          _raise(_Size, "prim-io.sml:205:72")
                        end
                        local exp_2762674 = rvNB_2762668(n_2762670)
                        local tmp_2762675 = exp_2762674.tag
                        local tmp_2762676 = tmp_2762675 == "SOME"
                        if tmp_2762676 then
                          local content_2762677 = exp_2762674.payload
                          return content_2762677
                        end
                        local tmp_2762678 = exp_2762674.tag
                        local tmp_2762679 = tmp_2762678 == "NONE"
                        if tmp_2762679 then
                          goto then_2763391
                        else
                          _raise(_Match, "prim-io.sml:207:72")
                        end
                      end
                      ::then_2763391::
                      do
                        local tmp_2763392 = block_PRIME_2762667(nil)
                        local exp_2762680 = rvNB_2762668(n_2762670)
                        local tmp_2762681 = exp_2762680.tag
                        local tmp_2762682 = tmp_2762681 == "SOME"
                        if tmp_2762682 then
                          local content_2762683 = exp_2762680.payload
                          return content_2762683
                        end
                        local tmp_2762684 = exp_2762680.tag
                        local tmp_2762685 = tmp_2762684 == "NONE"
                        if tmp_2762685 then
                          return empty_2762305
                        else
                          _raise(_Match, "prim-io.sml:210:86")
                        end
                      end
                    end
                    local tmp_2762691 = {tag = "SOME", payload = tmp_2762669}
                    readVec_PRIME_2762308 = tmp_2762691
                    goto cont_2762632
                  end
                  local tmp_2762692 = block_2762286.tag
                  local tmp_2762693 = tmp_2762692 == "SOME"
                  if tmp_2762693 then
                    local tmp_2762747 = readVecNB_2762282.tag
                    local tmp_2762748 = tmp_2762747 == "NONE"
                    if tmp_2762748 then
                      local tmp_2762749 = readArrNB_2762284.tag
                      local tmp_2762750 = tmp_2762749 == "SOME"
                      tmp_2762694 = tmp_2762750
                    else
                      tmp_2762694 = false
                    end
                  else
                    tmp_2762694 = false
                  end
                end
                ::cont_2762746::
                if tmp_2762694 then
                  local block_PRIME_2762695 = block_2762286.payload
                  local raNB_2762696 = readArrNB_2762284.payload
                  local tmp_2762697 = function(n_2762698)
                    local arr_2762706, aslice_2762709, exp_2762710
                    do
                      local tmp_2762700 = n_2762698 < 0
                      if tmp_2762700 then
                        _raise(_Size, "prim-io.sml:217:72")
                      end
                      local tmp_2762702 = param_2761981._Array
                      local tmp_2762703 = tmp_2762702.array
                      local tmp_2762704 = param_2761981.someElem
                      local tmp_2762705 = {n_2762698, tmp_2762704}
                      arr_2762706 = tmp_2762703(tmp_2762705)
                      local tmp_2762707 = param_2761981._ArraySlice
                      local tmp_2762708 = tmp_2762707.full
                      aslice_2762709 = tmp_2762708(arr_2762706)
                      exp_2762710 = raNB_2762696(aslice_2762709)
                      local tmp_2762711 = exp_2762710.tag
                      local tmp_2762712 = tmp_2762711 == "SOME"
                      if tmp_2762712 then
                        goto then_2763393
                      else
                        goto else_2763394
                      end
                    end
                    ::then_2763393::
                    do
                      local actual_2762713 = exp_2762710.payload
                      local tmp_2762714 = param_2761981._ArraySlice
                      local tmp_2762715 = tmp_2762714.vector
                      local tmp_2762716 = param_2761981._ArraySlice
                      local tmp_2762717 = tmp_2762716.slice
                      local tmp_2762718 = {tag = "SOME", payload = actual_2762713}
                      local tmp_2762719 = {arr_2762706, 0, tmp_2762718}
                      local tmp_2762720 = tmp_2762717(tmp_2762719)
                      return tmp_2762715(tmp_2762720)
                    end
                    ::else_2763394::
                    do
                      local tmp_2762722 = exp_2762710.tag
                      local tmp_2762723 = tmp_2762722 == "NONE"
                      if tmp_2762723 then
                        goto then_2763395
                      else
                        _raise(_Match, "prim-io.sml:221:75")
                      end
                    end
                    ::then_2763395::
                    do
                      local exp_2762724
                      do
                        local tmp_2763396 = block_PRIME_2762695(nil)
                        exp_2762724 = raNB_2762696(aslice_2762709)
                        local tmp_2762725 = exp_2762724.tag
                        local tmp_2762726 = tmp_2762725 == "SOME"
                        if tmp_2762726 then
                          goto then_2763397
                        else
                          goto else_2763398
                        end
                      end
                      ::then_2763397::
                      do
                        local actual_2762727 = exp_2762724.payload
                        local tmp_2762728 = param_2761981._ArraySlice
                        local tmp_2762729 = tmp_2762728.vector
                        local tmp_2762730 = param_2761981._ArraySlice
                        local tmp_2762731 = tmp_2762730.slice
                        local tmp_2762732 = {tag = "SOME", payload = actual_2762727}
                        local tmp_2762733 = {arr_2762706, 0, tmp_2762732}
                        local tmp_2762734 = tmp_2762731(tmp_2762733)
                        return tmp_2762729(tmp_2762734)
                      end
                      ::else_2763398::
                      local tmp_2762736 = exp_2762724.tag
                      local tmp_2762737 = tmp_2762736 == "NONE"
                      if tmp_2762737 then
                        return empty_2762305
                      else
                        _raise(_Match, "prim-io.sml:224:89")
                      end
                    end
                  end
                  local tmp_2762745 = {tag = "SOME", payload = tmp_2762697}
                  readVec_PRIME_2762308 = tmp_2762745
                else
                  readVec_PRIME_2762308 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:196:38")
              end
            else
              _raise(_Match, "prim-io.sml:194:26")
            end
          end
        end
        ::cont_2762632::
        local readArr_PRIME_2762311
        do
          local tmp_2762309 = readArr_2762280.tag
          local tmp_2762310 = tmp_2762309 == "SOME"
          do
            if tmp_2762310 then
              readArr_PRIME_2762311 = readArr_2762280
              goto cont_2762518
            end
            local tmp_2762519 = readArr_2762280.tag
            local tmp_2762520 = tmp_2762519 == "NONE"
            if tmp_2762520 then
              local tmp_2762521 = readVec_2762278.tag
              local tmp_2762522 = tmp_2762521 == "SOME"
              if tmp_2762522 then
                local rv_2762523 = readVec_2762278.payload
                local tmp_2762524 = function(slice_2762525)
                  local v_2762530
                  do
                    local tmp_2762527 = param_2761981._ArraySlice
                    local tmp_2762528 = tmp_2762527.length
                    local tmp_2762529 = tmp_2762528(slice_2762525)
                    v_2762530 = rv_2762523(tmp_2762529)
                    local tmp_2762531 = param_2761981._ArraySlice
                    local tmp_2762532 = tmp_2762531.base
                    local exp_2762533 = tmp_2762532(slice_2762525)
                    local base_2762534 = exp_2762533[1]
                    local start_2762535 = exp_2762533[2]
                    local tmp_2762536 = param_2761981._Array
                    local tmp_2762537 = tmp_2762536.copyVec
                    local tmp_2762538 = {di = start_2762535, dst = base_2762534, src = v_2762530}
                    local tmp_2763399 = tmp_2762537(tmp_2762538)
                  end
                  local tmp_2762539 = param_2761981._Vector
                  local tmp_2762540 = tmp_2762539.length
                  return tmp_2762540(v_2762530)
                end
                local tmp_2762545 = {tag = "SOME", payload = tmp_2762524}
                readArr_PRIME_2762311 = tmp_2762545
                goto cont_2762518
              end
              local tmp_2762546 = readVec_2762278.tag
              local tmp_2762547 = tmp_2762546 == "NONE"
              if tmp_2762547 then
                local tmp_2762550
                do
                  local tmp_2762548 = block_2762286.tag
                  local tmp_2762549 = tmp_2762548 == "SOME"
                  if tmp_2762549 then
                    local tmp_2762628 = readArrNB_2762284.tag
                    local tmp_2762629 = tmp_2762628 == "SOME"
                    tmp_2762550 = tmp_2762629
                  else
                    tmp_2762550 = false
                  end
                end
                ::cont_2762627::
                local tmp_2762576
                do
                  if tmp_2762550 then
                    local block_PRIME_2762551 = block_2762286.payload
                    local raNB_2762552 = readArrNB_2762284.payload
                    local tmp_2762553 = function(slice_2762554)
                      do
                        local exp_2762556 = raNB_2762552(slice_2762554)
                        local tmp_2762557 = exp_2762556.tag
                        local tmp_2762558 = tmp_2762557 == "SOME"
                        if tmp_2762558 then
                          local actual_2762559 = exp_2762556.payload
                          return actual_2762559
                        end
                        local tmp_2762560 = exp_2762556.tag
                        local tmp_2762561 = tmp_2762560 == "NONE"
                        if tmp_2762561 then
                          goto then_2763400
                        else
                          _raise(_Match, "prim-io.sml:242:72")
                        end
                      end
                      ::then_2763400::
                      do
                        local tmp_2763401 = block_PRIME_2762551(nil)
                        local exp_2762562 = raNB_2762552(slice_2762554)
                        local tmp_2762563 = exp_2762562.tag
                        local tmp_2762564 = tmp_2762563 == "SOME"
                        if tmp_2762564 then
                          local actual_2762565 = exp_2762562.payload
                          return actual_2762565
                        end
                        local tmp_2762566 = exp_2762562.tag
                        local tmp_2762567 = tmp_2762566 == "NONE"
                        if tmp_2762567 then
                          return 0
                        else
                          _raise(_Match, "prim-io.sml:245:86")
                        end
                      end
                    end
                    local tmp_2762573 = {tag = "SOME", payload = tmp_2762553}
                    readArr_PRIME_2762311 = tmp_2762573
                    goto cont_2762518
                  end
                  local tmp_2762574 = block_2762286.tag
                  local tmp_2762575 = tmp_2762574 == "SOME"
                  if tmp_2762575 then
                    local tmp_2762623 = readVecNB_2762282.tag
                    local tmp_2762624 = tmp_2762623 == "SOME"
                    if tmp_2762624 then
                      local tmp_2762625 = readArrNB_2762284.tag
                      local tmp_2762626 = tmp_2762625 == "NONE"
                      tmp_2762576 = tmp_2762626
                    else
                      tmp_2762576 = false
                    end
                  else
                    tmp_2762576 = false
                  end
                end
                ::cont_2762622::
                if tmp_2762576 then
                  local block_PRIME_2762577 = block_2762286.payload
                  local rvNB_2762578 = readVecNB_2762282.payload
                  local tmp_2762579 = function(slice_2762580)
                    local n_2762584, base_2762588, start_2762589, exp_2762590
                    do
                      local tmp_2762582 = param_2761981._ArraySlice
                      local tmp_2762583 = tmp_2762582.length
                      n_2762584 = tmp_2762583(slice_2762580)
                      local tmp_2762585 = param_2761981._ArraySlice
                      local tmp_2762586 = tmp_2762585.base
                      local exp_2762587 = tmp_2762586(slice_2762580)
                      base_2762588 = exp_2762587[1]
                      start_2762589 = exp_2762587[2]
                      exp_2762590 = rvNB_2762578(n_2762584)
                      local tmp_2762591 = exp_2762590.tag
                      local tmp_2762592 = tmp_2762591 == "SOME"
                      if tmp_2762592 then
                        goto then_2763402
                      else
                        goto else_2763403
                      end
                    end
                    ::then_2763402::
                    do
                      local v_2762593 = exp_2762590.payload
                      local tmp_2762594 = param_2761981._Array
                      local tmp_2762595 = tmp_2762594.copyVec
                      local tmp_2762596 = {di = start_2762589, dst = base_2762588, src = v_2762593}
                      local tmp_2763404 = tmp_2762595(tmp_2762596)
                      local tmp_2762597 = param_2761981._Vector
                      local tmp_2762598 = tmp_2762597.length
                      return tmp_2762598(v_2762593)
                    end
                    ::else_2763403::
                    do
                      local tmp_2762600 = exp_2762590.tag
                      local tmp_2762601 = tmp_2762600 == "NONE"
                      if tmp_2762601 then
                        goto then_2763405
                      else
                        _raise(_Match, "prim-io.sml:253:75")
                      end
                    end
                    ::then_2763405::
                    do
                      local exp_2762602
                      do
                        local tmp_2763406 = block_PRIME_2762577(nil)
                        exp_2762602 = rvNB_2762578(n_2762584)
                        local tmp_2762603 = exp_2762602.tag
                        local tmp_2762604 = tmp_2762603 == "SOME"
                        if tmp_2762604 then
                          goto then_2763407
                        else
                          goto else_2763408
                        end
                      end
                      ::then_2763407::
                      do
                        local v_2762605 = exp_2762602.payload
                        local tmp_2762606 = param_2761981._Array
                        local tmp_2762607 = tmp_2762606.copyVec
                        local tmp_2762608 = {di = start_2762589, dst = base_2762588, src = v_2762605}
                        local tmp_2763409 = tmp_2762607(tmp_2762608)
                        local tmp_2762609 = param_2761981._Vector
                        local tmp_2762610 = tmp_2762609.length
                        return tmp_2762610(v_2762605)
                      end
                      ::else_2763408::
                      local tmp_2762612 = exp_2762602.tag
                      local tmp_2762613 = tmp_2762612 == "NONE"
                      if tmp_2762613 then
                        return 0
                      else
                        _raise(_Match, "prim-io.sml:258:89")
                      end
                    end
                  end
                  local tmp_2762621 = {tag = "SOME", payload = tmp_2762579}
                  readArr_PRIME_2762311 = tmp_2762621
                else
                  readArr_PRIME_2762311 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:233:38")
              end
            else
              _raise(_Match, "prim-io.sml:231:26")
            end
          end
        end
        ::cont_2762518::
        local readVecNB_PRIME_2762314
        do
          local tmp_2762312 = readVecNB_2762282.tag
          local tmp_2762313 = tmp_2762312 == "SOME"
          do
            if tmp_2762313 then
              readVecNB_PRIME_2762314 = readVecNB_2762282
              goto cont_2762415
            end
            local tmp_2762416 = readVecNB_2762282.tag
            local tmp_2762417 = tmp_2762416 == "NONE"
            if tmp_2762417 then
              local tmp_2762418 = readArrNB_2762284.tag
              local tmp_2762419 = tmp_2762418 == "SOME"
              if tmp_2762419 then
                local raNB_2762420 = readArrNB_2762284.payload
                local tmp_2762421 = function(n_2762422)
                  local arr_2762430, exp_2762434
                  do
                    local tmp_2762424 = n_2762422 < 0
                    if tmp_2762424 then
                      _raise(_Size, "prim-io.sml:271:75")
                    end
                    local tmp_2762426 = param_2761981._Array
                    local tmp_2762427 = tmp_2762426.array
                    local tmp_2762428 = param_2761981.someElem
                    local tmp_2762429 = {n_2762422, tmp_2762428}
                    arr_2762430 = tmp_2762427(tmp_2762429)
                    local tmp_2762431 = param_2761981._ArraySlice
                    local tmp_2762432 = tmp_2762431.full
                    local tmp_2762433 = tmp_2762432(arr_2762430)
                    exp_2762434 = raNB_2762420(tmp_2762433)
                    local tmp_2762435 = exp_2762434.tag
                    local tmp_2762436 = tmp_2762435 == "SOME"
                    if tmp_2762436 then
                      goto then_2763410
                    else
                      goto else_2763411
                    end
                  end
                  ::then_2763410::
                  do
                    local actual_2762437 = exp_2762434.payload
                    local tmp_2762438 = param_2761981._ArraySlice
                    local tmp_2762439 = tmp_2762438.vector
                    local tmp_2762440 = param_2761981._ArraySlice
                    local tmp_2762441 = tmp_2762440.slice
                    local tmp_2762442 = {tag = "SOME", payload = actual_2762437}
                    local tmp_2762443 = {arr_2762430, 0, tmp_2762442}
                    local tmp_2762444 = tmp_2762441(tmp_2762443)
                    local tmp_2762445 = tmp_2762439(tmp_2762444)
                    local tmp_2762446 = {tag = "SOME", payload = tmp_2762445}
                    return tmp_2762446
                  end
                  ::else_2763411::
                  local tmp_2762449 = exp_2762434.tag
                  local tmp_2762450 = tmp_2762449 == "NONE"
                  if tmp_2762450 then
                    return NONE_217
                  else
                    _raise(_Match, "prim-io.sml:274:78")
                  end
                end
                local tmp_2762455 = {tag = "SOME", payload = tmp_2762421}
                readVecNB_PRIME_2762314 = tmp_2762455
                goto cont_2762415
              end
              local tmp_2762456 = readArrNB_2762284.tag
              local tmp_2762457 = tmp_2762456 == "NONE"
              if tmp_2762457 then
                local tmp_2762460
                do
                  local tmp_2762458 = canInput_2762288.tag
                  local tmp_2762459 = tmp_2762458 == "SOME"
                  if tmp_2762459 then
                    local tmp_2762514 = readVec_2762278.tag
                    local tmp_2762515 = tmp_2762514 == "SOME"
                    tmp_2762460 = tmp_2762515
                  else
                    tmp_2762460 = false
                  end
                end
                ::cont_2762513::
                local tmp_2762474
                do
                  if tmp_2762460 then
                    local canInput_PRIME_2762461 = canInput_2762288.payload
                    local rv_2762462 = readVec_2762278.payload
                    local tmp_2762463 = function(n_2762464)
                      do
                        local tmp_2762466 = canInput_PRIME_2762461(nil)
                        if tmp_2762466 then
                          goto then_2763412
                        else
                          return NONE_217
                        end
                      end
                      ::then_2763412::
                      do
                        local tmp_2762467 = rv_2762462(n_2762464)
                        local tmp_2762468 = {tag = "SOME", payload = tmp_2762467}
                        return tmp_2762468
                      end
                    end
                    local tmp_2762471 = {tag = "SOME", payload = tmp_2762463}
                    readVecNB_PRIME_2762314 = tmp_2762471
                    goto cont_2762415
                  end
                  local tmp_2762472 = canInput_2762288.tag
                  local tmp_2762473 = tmp_2762472 == "SOME"
                  if tmp_2762473 then
                    local tmp_2762509 = readVec_2762278.tag
                    local tmp_2762510 = tmp_2762509 == "NONE"
                    if tmp_2762510 then
                      local tmp_2762511 = readArr_2762280.tag
                      local tmp_2762512 = tmp_2762511 == "SOME"
                      tmp_2762474 = tmp_2762512
                    else
                      tmp_2762474 = false
                    end
                  else
                    tmp_2762474 = false
                  end
                end
                ::cont_2762508::
                if tmp_2762474 then
                  local canInput_PRIME_2762475 = canInput_2762288.payload
                  local ra_2762476 = readArr_2762280.payload
                  local tmp_2762477 = function(n_2762478)
                    do
                      local tmp_2762480 = canInput_PRIME_2762475(nil)
                      if tmp_2762480 then
                        goto then_2763413
                      else
                        return NONE_217
                      end
                    end
                    ::then_2763413::
                    do
                      local arr_2762487, actual_2762491, tmp_2762493, tmp_2762495
                      do
                        local tmp_2762481 = n_2762478 < 0
                        if tmp_2762481 then
                          _raise(_Size, "prim-io.sml:289:78")
                        end
                        local tmp_2762483 = param_2761981._Array
                        local tmp_2762484 = tmp_2762483.array
                        local tmp_2762485 = param_2761981.someElem
                        local tmp_2762486 = {n_2762478, tmp_2762485}
                        arr_2762487 = tmp_2762484(tmp_2762486)
                        local tmp_2762488 = param_2761981._ArraySlice
                        local tmp_2762489 = tmp_2762488.full
                        local tmp_2762490 = tmp_2762489(arr_2762487)
                        actual_2762491 = ra_2762476(tmp_2762490)
                        local tmp_2762492 = param_2761981._ArraySlice
                        tmp_2762493 = tmp_2762492.vector
                        local tmp_2762494 = param_2761981._ArraySlice
                        tmp_2762495 = tmp_2762494.slice
                      end
                      local tmp_2762496 = {tag = "SOME", payload = actual_2762491}
                      local tmp_2762497 = {arr_2762487, 0, tmp_2762496}
                      local tmp_2762498 = tmp_2762495(tmp_2762497)
                      local tmp_2762499 = tmp_2762493(tmp_2762498)
                      local tmp_2762500 = {tag = "SOME", payload = tmp_2762499}
                      return tmp_2762500
                    end
                  end
                  local tmp_2762507 = {tag = "SOME", payload = tmp_2762477}
                  readVecNB_PRIME_2762314 = tmp_2762507
                else
                  readVecNB_PRIME_2762314 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:269:40")
              end
            else
              _raise(_Match, "prim-io.sml:267:28")
            end
          end
        end
        ::cont_2762415::
        local readArrNB_PRIME_2762317
        do
          local tmp_2762315 = readArrNB_2762284.tag
          local tmp_2762316 = tmp_2762315 == "SOME"
          do
            if tmp_2762316 then
              readArrNB_PRIME_2762317 = readArrNB_2762284
              goto cont_2762320
            end
            local tmp_2762321 = readArrNB_2762284.tag
            local tmp_2762322 = tmp_2762321 == "NONE"
            if tmp_2762322 then
              local tmp_2762323 = readVecNB_2762282.tag
              local tmp_2762324 = tmp_2762323 == "SOME"
              if tmp_2762324 then
                local rvNB_2762325 = readVecNB_2762282.payload
                local tmp_2762326 = function(slice_2762327)
                  local exp_2762332
                  do
                    local tmp_2762329 = param_2761981._ArraySlice
                    local tmp_2762330 = tmp_2762329.length
                    local tmp_2762331 = tmp_2762330(slice_2762327)
                    exp_2762332 = rvNB_2762325(tmp_2762331)
                    local tmp_2762333 = exp_2762332.tag
                    local tmp_2762334 = tmp_2762333 == "SOME"
                    if tmp_2762334 then
                      goto then_2763414
                    else
                      goto else_2763415
                    end
                  end
                  ::then_2763414::
                  do
                    local v_2762335, tmp_2762345
                    do
                      v_2762335 = exp_2762332.payload
                      local tmp_2762336 = param_2761981._ArraySlice
                      local tmp_2762337 = tmp_2762336.base
                      local exp_2762338 = tmp_2762337(slice_2762327)
                      local base_2762339 = exp_2762338[1]
                      local start_2762340 = exp_2762338[2]
                      local tmp_2762341 = param_2761981._Array
                      local tmp_2762342 = tmp_2762341.copyVec
                      local tmp_2762343 = {di = start_2762340, dst = base_2762339, src = v_2762335}
                      local tmp_2763416 = tmp_2762342(tmp_2762343)
                      local tmp_2762344 = param_2761981._Vector
                      tmp_2762345 = tmp_2762344.length
                    end
                    local tmp_2762346 = tmp_2762345(v_2762335)
                    local tmp_2762347 = {tag = "SOME", payload = tmp_2762346}
                    return tmp_2762347
                  end
                  ::else_2763415::
                  local tmp_2762351 = exp_2762332.tag
                  local tmp_2762352 = tmp_2762351 == "NONE"
                  if tmp_2762352 then
                    return NONE_217
                  else
                    _raise(_Match, "prim-io.sml:303:62")
                  end
                end
                local tmp_2762356 = {tag = "SOME", payload = tmp_2762326}
                readArrNB_PRIME_2762317 = tmp_2762356
                goto cont_2762320
              end
              local tmp_2762357 = readVecNB_2762282.tag
              local tmp_2762358 = tmp_2762357 == "NONE"
              if tmp_2762358 then
                local tmp_2762361
                do
                  local tmp_2762359 = canInput_2762288.tag
                  local tmp_2762360 = tmp_2762359 == "SOME"
                  if tmp_2762360 then
                    local tmp_2762411 = readArr_2762280.tag
                    local tmp_2762412 = tmp_2762411 == "SOME"
                    tmp_2762361 = tmp_2762412
                  else
                    tmp_2762361 = false
                  end
                end
                ::cont_2762410::
                local tmp_2762375
                do
                  if tmp_2762361 then
                    local canInput_PRIME_2762362 = canInput_2762288.payload
                    local ra_2762363 = readArr_2762280.payload
                    local tmp_2762364 = function(slice_2762365)
                      do
                        local tmp_2762367 = canInput_PRIME_2762362(nil)
                        if tmp_2762367 then
                          goto then_2763417
                        else
                          return NONE_217
                        end
                      end
                      ::then_2763417::
                      do
                        local tmp_2762368 = ra_2762363(slice_2762365)
                        local tmp_2762369 = {tag = "SOME", payload = tmp_2762368}
                        return tmp_2762369
                      end
                    end
                    local tmp_2762372 = {tag = "SOME", payload = tmp_2762364}
                    readArrNB_PRIME_2762317 = tmp_2762372
                    goto cont_2762320
                  end
                  local tmp_2762373 = canInput_2762288.tag
                  local tmp_2762374 = tmp_2762373 == "SOME"
                  if tmp_2762374 then
                    local tmp_2762406 = readVec_2762278.tag
                    local tmp_2762407 = tmp_2762406 == "SOME"
                    if tmp_2762407 then
                      local tmp_2762408 = readArr_2762280.tag
                      local tmp_2762409 = tmp_2762408 == "NONE"
                      tmp_2762375 = tmp_2762409
                    else
                      tmp_2762375 = false
                    end
                  else
                    tmp_2762375 = false
                  end
                end
                ::cont_2762405::
                if tmp_2762375 then
                  local canInput_PRIME_2762376 = canInput_2762288.payload
                  local rv_2762377 = readVec_2762278.payload
                  local tmp_2762378 = function(slice_2762379)
                    do
                      local tmp_2762381 = canInput_PRIME_2762376(nil)
                      if tmp_2762381 then
                        goto then_2763418
                      else
                        return NONE_217
                      end
                    end
                    ::then_2763418::
                    do
                      local v_2762385
                      do
                        local tmp_2762382 = param_2761981._ArraySlice
                        local tmp_2762383 = tmp_2762382.length
                        local tmp_2762384 = tmp_2762383(slice_2762379)
                        v_2762385 = rv_2762377(tmp_2762384)
                        local tmp_2762386 = param_2761981._ArraySlice
                        local tmp_2762387 = tmp_2762386.base
                        local exp_2762388 = tmp_2762387(slice_2762379)
                        local base_2762389 = exp_2762388[1]
                        local start_2762390 = exp_2762388[2]
                        local tmp_2762391 = param_2761981._Array
                        local tmp_2762392 = tmp_2762391.copyVec
                        local tmp_2762393 = {di = start_2762390, dst = base_2762389, src = v_2762385}
                        local tmp_2763419 = tmp_2762392(tmp_2762393)
                      end
                      local tmp_2762394 = param_2761981._Vector
                      local tmp_2762395 = tmp_2762394.length
                      local tmp_2762396 = tmp_2762395(v_2762385)
                      local tmp_2762397 = {tag = "SOME", payload = tmp_2762396}
                      return tmp_2762397
                    end
                  end
                  local tmp_2762404 = {tag = "SOME", payload = tmp_2762378}
                  readArrNB_PRIME_2762317 = tmp_2762404
                else
                  readArrNB_PRIME_2762317 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:301:40")
              end
            else
              _raise(_Match, "prim-io.sml:299:28")
            end
          end
        end
        ::cont_2762320::
        local tmp_2762318 = {avail = avail_2762290, block = block_2762286, canInput = canInput_2762288, chunkSize = chunkSize_2762276, close = close_2762300, endPos = endPos_2762296, getPos = getPos_2762292, ioDesc = ioDesc_2762302, name = name_2762274, readArr = readArr_PRIME_2762311, readArrNB = readArrNB_PRIME_2762317, readVec = readVec_PRIME_2762308, readVecNB = readVecNB_PRIME_2762314, setPos = setPos_2762294, verifyPos = verifyPos_2762298}
        local tmp_2762319 = tmp_2762318
        return tmp_2762319
      end
      local augmentWriter_2762757 = function(a_2762758)
        local name_2762761, chunkSize_2762763, writeVec_2762765, writeArr_2762767, writeVecNB_2762769, writeArrNB_2762771, block_2762773, canOutput_2762775, getPos_2762777, setPos_2762779
        do
          local tmp_2762760 = a_2762758
          name_2762761 = tmp_2762760.name
          local tmp_2762762 = a_2762758
          chunkSize_2762763 = tmp_2762762.chunkSize
          local tmp_2762764 = a_2762758
          writeVec_2762765 = tmp_2762764.writeVec
          local tmp_2762766 = a_2762758
          writeArr_2762767 = tmp_2762766.writeArr
          local tmp_2762768 = a_2762758
          writeVecNB_2762769 = tmp_2762768.writeVecNB
          local tmp_2762770 = a_2762758
          writeArrNB_2762771 = tmp_2762770.writeArrNB
          local tmp_2762772 = a_2762758
          block_2762773 = tmp_2762772.block
          local tmp_2762774 = a_2762758
          canOutput_2762775 = tmp_2762774.canOutput
          local tmp_2762776 = a_2762758
          getPos_2762777 = tmp_2762776.getPos
          local tmp_2762778 = a_2762758
          setPos_2762779 = tmp_2762778.setPos
        end
        local endPos_2762781, verifyPos_2762783, close_2762785, ioDesc_2762787, writeVec_PRIME_2762790
        do
          local tmp_2762780 = a_2762758
          endPos_2762781 = tmp_2762780.endPos
          local tmp_2762782 = a_2762758
          verifyPos_2762783 = tmp_2762782.verifyPos
          local tmp_2762784 = a_2762758
          close_2762785 = tmp_2762784.close
          local tmp_2762786 = a_2762758
          ioDesc_2762787 = tmp_2762786.ioDesc
          local tmp_2762788 = writeVec_2762765.tag
          local tmp_2762789 = tmp_2762788 == "SOME"
          do
            if tmp_2762789 then
              writeVec_PRIME_2762790 = writeVec_2762765
              goto cont_2763044
            end
            local tmp_2763045 = writeVec_2762765.tag
            local tmp_2763046 = tmp_2763045 == "NONE"
            if tmp_2763046 then
              local tmp_2763047 = writeArr_2762767.tag
              local tmp_2763048 = tmp_2763047 == "SOME"
              if tmp_2763048 then
                local wa_2763049 = writeArr_2762767.payload
                local tmp_2763050 = function(slice_2763051)
                  local arr_2763060
                  do
                    local tmp_2763053 = param_2761981._Array
                    local tmp_2763054 = tmp_2763053.array
                    local tmp_2763055 = param_2761981._VectorSlice
                    local tmp_2763056 = tmp_2763055.length
                    local tmp_2763057 = tmp_2763056(slice_2763051)
                    local tmp_2763058 = param_2761981.someElem
                    local tmp_2763059 = {tmp_2763057, tmp_2763058}
                    arr_2763060 = tmp_2763054(tmp_2763059)
                    local tmp_2763061 = param_2761981._ArraySlice
                    local tmp_2763062 = tmp_2763061.copyVec
                    local tmp_2763063 = {di = 0, dst = arr_2763060, src = slice_2763051}
                    local tmp_2763420 = tmp_2763062(tmp_2763063)
                  end
                  local tmp_2763064 = param_2761981._ArraySlice
                  local tmp_2763065 = tmp_2763064.full
                  local tmp_2763066 = tmp_2763065(arr_2763060)
                  return wa_2763049(tmp_2763066)
                end
                local tmp_2763071 = {tag = "SOME", payload = tmp_2763050}
                writeVec_PRIME_2762790 = tmp_2763071
                goto cont_2763044
              end
              local tmp_2763072 = writeArr_2762767.tag
              local tmp_2763073 = tmp_2763072 == "NONE"
              if tmp_2763073 then
                local tmp_2763076
                do
                  local tmp_2763074 = block_2762773.tag
                  local tmp_2763075 = tmp_2763074 == "SOME"
                  if tmp_2763075 then
                    local tmp_2763150 = writeVecNB_2762769.tag
                    local tmp_2763151 = tmp_2763150 == "SOME"
                    tmp_2763076 = tmp_2763151
                  else
                    tmp_2763076 = false
                  end
                end
                ::cont_2763149::
                local tmp_2763102
                do
                  if tmp_2763076 then
                    local block_PRIME_2763077 = block_2762773.payload
                    local wvNB_2763078 = writeVecNB_2762769.payload
                    local tmp_2763079 = function(slice_2763080)
                      do
                        local exp_2763082 = wvNB_2763078(slice_2763080)
                        local tmp_2763083 = exp_2763082.tag
                        local tmp_2763084 = tmp_2763083 == "SOME"
                        if tmp_2763084 then
                          local n_2763085 = exp_2763082.payload
                          return n_2763085
                        end
                        local tmp_2763086 = exp_2763082.tag
                        local tmp_2763087 = tmp_2763086 == "NONE"
                        if tmp_2763087 then
                          goto then_2763421
                        else
                          _raise(_Match, "prim-io.sml:359:64")
                        end
                      end
                      ::then_2763421::
                      do
                        local tmp_2763422 = block_PRIME_2763077(nil)
                        local exp_2763088 = wvNB_2763078(slice_2763080)
                        local tmp_2763089 = exp_2763088.tag
                        local tmp_2763090 = tmp_2763089 == "SOME"
                        if tmp_2763090 then
                          local n_2763091 = exp_2763088.payload
                          return n_2763091
                        end
                        local tmp_2763092 = exp_2763088.tag
                        local tmp_2763093 = tmp_2763092 == "NONE"
                        if tmp_2763093 then
                          return 0
                        else
                          _raise(_Match, "prim-io.sml:362:78")
                        end
                      end
                    end
                    local tmp_2763099 = {tag = "SOME", payload = tmp_2763079}
                    writeVec_PRIME_2762790 = tmp_2763099
                    goto cont_2763044
                  end
                  local tmp_2763100 = block_2762773.tag
                  local tmp_2763101 = tmp_2763100 == "SOME"
                  if tmp_2763101 then
                    local tmp_2763145 = writeVecNB_2762769.tag
                    local tmp_2763146 = tmp_2763145 == "NONE"
                    if tmp_2763146 then
                      local tmp_2763147 = writeArrNB_2762771.tag
                      local tmp_2763148 = tmp_2763147 == "SOME"
                      tmp_2763102 = tmp_2763148
                    else
                      tmp_2763102 = false
                    end
                  else
                    tmp_2763102 = false
                  end
                end
                ::cont_2763144::
                if tmp_2763102 then
                  local block_PRIME_2763103 = block_2762773.payload
                  local waNB_2763104 = writeArrNB_2762771.payload
                  local tmp_2763105 = function(slice_2763106)
                    local arr_2763115, aslice_2763118, tmp_2763120
                    do
                      local tmp_2763108 = param_2761981._Array
                      local tmp_2763109 = tmp_2763108.array
                      local tmp_2763110 = param_2761981._VectorSlice
                      local tmp_2763111 = tmp_2763110.length
                      local tmp_2763112 = tmp_2763111(slice_2763106)
                      local tmp_2763113 = param_2761981.someElem
                      local tmp_2763114 = {tmp_2763112, tmp_2763113}
                      arr_2763115 = tmp_2763109(tmp_2763114)
                      local tmp_2763116 = param_2761981._ArraySlice
                      local tmp_2763117 = tmp_2763116.full
                      aslice_2763118 = tmp_2763117(arr_2763115)
                      local tmp_2763119 = param_2761981._ArraySlice
                      tmp_2763120 = tmp_2763119.copyVec
                    end
                    do
                      local tmp_2763121 = {di = 0, dst = arr_2763115, src = slice_2763106}
                      local tmp_2763423 = tmp_2763120(tmp_2763121)
                      local exp_2763122 = waNB_2763104(aslice_2763118)
                      local tmp_2763123 = exp_2763122.tag
                      local tmp_2763124 = tmp_2763123 == "SOME"
                      if tmp_2763124 then
                        local n_2763125 = exp_2763122.payload
                        return n_2763125
                      end
                      local tmp_2763126 = exp_2763122.tag
                      local tmp_2763127 = tmp_2763126 == "NONE"
                      if tmp_2763127 then
                        goto then_2763424
                      else
                        _raise(_Match, "prim-io.sml:372:67")
                      end
                    end
                    ::then_2763424::
                    do
                      local tmp_2763425 = block_PRIME_2763103(nil)
                      local exp_2763128 = waNB_2763104(aslice_2763118)
                      local tmp_2763129 = exp_2763128.tag
                      local tmp_2763130 = tmp_2763129 == "SOME"
                      if tmp_2763130 then
                        local n_2763131 = exp_2763128.payload
                        return n_2763131
                      end
                      local tmp_2763132 = exp_2763128.tag
                      local tmp_2763133 = tmp_2763132 == "NONE"
                      if tmp_2763133 then
                        return 0
                      else
                        _raise(_Match, "prim-io.sml:375:81")
                      end
                    end
                  end
                  local tmp_2763143 = {tag = "SOME", payload = tmp_2763105}
                  writeVec_PRIME_2762790 = tmp_2763143
                else
                  writeVec_PRIME_2762790 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:348:39")
              end
            else
              _raise(_Match, "prim-io.sml:346:27")
            end
          end
        end
        ::cont_2763044::
        local writeArr_PRIME_2762793
        do
          local tmp_2762791 = writeArr_2762767.tag
          local tmp_2762792 = tmp_2762791 == "SOME"
          do
            if tmp_2762792 then
              writeArr_PRIME_2762793 = writeArr_2762767
              goto cont_2762954
            end
            local tmp_2762955 = writeArr_2762767.tag
            local tmp_2762956 = tmp_2762955 == "NONE"
            if tmp_2762956 then
              local tmp_2762957 = writeVec_2762765.tag
              local tmp_2762958 = tmp_2762957 == "SOME"
              if tmp_2762958 then
                local wv_2762959 = writeVec_2762765.payload
                local tmp_2762960 = function(slice_2762961)
                  local tmp_2762963 = param_2761981._ArraySlice
                  local tmp_2762964 = tmp_2762963.vector
                  local v_2762965 = tmp_2762964(slice_2762961)
                  local tmp_2762966 = param_2761981._VectorSlice
                  local tmp_2762967 = tmp_2762966.full
                  local tmp_2762968 = tmp_2762967(v_2762965)
                  return wv_2762959(tmp_2762968)
                end
                local tmp_2762971 = {tag = "SOME", payload = tmp_2762960}
                writeArr_PRIME_2762793 = tmp_2762971
                goto cont_2762954
              end
              local tmp_2762972 = writeVec_2762765.tag
              local tmp_2762973 = tmp_2762972 == "NONE"
              if tmp_2762973 then
                local tmp_2762976
                do
                  local tmp_2762974 = block_2762773.tag
                  local tmp_2762975 = tmp_2762974 == "SOME"
                  if tmp_2762975 then
                    local tmp_2763040 = writeArrNB_2762771.tag
                    local tmp_2763041 = tmp_2763040 == "SOME"
                    tmp_2762976 = tmp_2763041
                  else
                    tmp_2762976 = false
                  end
                end
                ::cont_2763039::
                local tmp_2763002
                do
                  if tmp_2762976 then
                    local block_PRIME_2762977 = block_2762773.payload
                    local waNB_2762978 = writeArrNB_2762771.payload
                    local tmp_2762979 = function(slice_2762980)
                      do
                        local exp_2762982 = waNB_2762978(slice_2762980)
                        local tmp_2762983 = exp_2762982.tag
                        local tmp_2762984 = tmp_2762983 == "SOME"
                        if tmp_2762984 then
                          local n_2762985 = exp_2762982.payload
                          return n_2762985
                        end
                        local tmp_2762986 = exp_2762982.tag
                        local tmp_2762987 = tmp_2762986 == "NONE"
                        if tmp_2762987 then
                          goto then_2763426
                        else
                          _raise(_Match, "prim-io.sml:393:64")
                        end
                      end
                      ::then_2763426::
                      do
                        local tmp_2763427 = block_PRIME_2762977(nil)
                        local exp_2762988 = waNB_2762978(slice_2762980)
                        local tmp_2762989 = exp_2762988.tag
                        local tmp_2762990 = tmp_2762989 == "SOME"
                        if tmp_2762990 then
                          local n_2762991 = exp_2762988.payload
                          return n_2762991
                        end
                        local tmp_2762992 = exp_2762988.tag
                        local tmp_2762993 = tmp_2762992 == "NONE"
                        if tmp_2762993 then
                          return 0
                        else
                          _raise(_Match, "prim-io.sml:396:78")
                        end
                      end
                    end
                    local tmp_2762999 = {tag = "SOME", payload = tmp_2762979}
                    writeArr_PRIME_2762793 = tmp_2762999
                    goto cont_2762954
                  end
                  local tmp_2763000 = block_2762773.tag
                  local tmp_2763001 = tmp_2763000 == "SOME"
                  if tmp_2763001 then
                    local tmp_2763035 = writeVecNB_2762769.tag
                    local tmp_2763036 = tmp_2763035 == "SOME"
                    if tmp_2763036 then
                      local tmp_2763037 = writeArrNB_2762771.tag
                      local tmp_2763038 = tmp_2763037 == "NONE"
                      tmp_2763002 = tmp_2763038
                    else
                      tmp_2763002 = false
                    end
                  else
                    tmp_2763002 = false
                  end
                end
                ::cont_2763034::
                if tmp_2763002 then
                  local block_PRIME_2763003 = block_2762773.payload
                  local wvNB_2763004 = writeVecNB_2762769.payload
                  local tmp_2763005 = function(slice_2763006)
                    local vslice_2763013
                    do
                      local tmp_2763008 = param_2761981._VectorSlice
                      local tmp_2763009 = tmp_2763008.full
                      local tmp_2763010 = param_2761981._ArraySlice
                      local tmp_2763011 = tmp_2763010.vector
                      local tmp_2763012 = tmp_2763011(slice_2763006)
                      vslice_2763013 = tmp_2763009(tmp_2763012)
                      local exp_2763014 = wvNB_2763004(vslice_2763013)
                      local tmp_2763015 = exp_2763014.tag
                      local tmp_2763016 = tmp_2763015 == "SOME"
                      if tmp_2763016 then
                        local n_2763017 = exp_2763014.payload
                        return n_2763017
                      end
                      local tmp_2763018 = exp_2763014.tag
                      local tmp_2763019 = tmp_2763018 == "NONE"
                      if tmp_2763019 then
                        goto then_2763428
                      else
                        _raise(_Match, "prim-io.sml:404:67")
                      end
                    end
                    ::then_2763428::
                    do
                      local tmp_2763429 = block_PRIME_2763003(nil)
                      local exp_2763020 = wvNB_2763004(vslice_2763013)
                      local tmp_2763021 = exp_2763020.tag
                      local tmp_2763022 = tmp_2763021 == "SOME"
                      if tmp_2763022 then
                        local n_2763023 = exp_2763020.payload
                        return n_2763023
                      end
                      local tmp_2763024 = exp_2763020.tag
                      local tmp_2763025 = tmp_2763024 == "NONE"
                      if tmp_2763025 then
                        return 0
                      else
                        _raise(_Match, "prim-io.sml:407:81")
                      end
                    end
                  end
                  local tmp_2763033 = {tag = "SOME", payload = tmp_2763005}
                  writeArr_PRIME_2762793 = tmp_2763033
                else
                  writeArr_PRIME_2762793 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:384:39")
              end
            else
              _raise(_Match, "prim-io.sml:382:27")
            end
          end
        end
        ::cont_2762954::
        local writeVecNB_PRIME_2762796
        do
          local tmp_2762794 = writeVecNB_2762769.tag
          local tmp_2762795 = tmp_2762794 == "SOME"
          do
            if tmp_2762795 then
              writeVecNB_PRIME_2762796 = writeVecNB_2762769
              goto cont_2762868
            end
            local tmp_2762869 = writeVecNB_2762769.tag
            local tmp_2762870 = tmp_2762869 == "NONE"
            if tmp_2762870 then
              local tmp_2762871 = writeArrNB_2762771.tag
              local tmp_2762872 = tmp_2762871 == "SOME"
              if tmp_2762872 then
                local waNB_2762873 = writeArrNB_2762771.payload
                local tmp_2762874 = function(slice_2762875)
                  local arr_2762884
                  do
                    local tmp_2762877 = param_2761981._Array
                    local tmp_2762878 = tmp_2762877.array
                    local tmp_2762879 = param_2761981._VectorSlice
                    local tmp_2762880 = tmp_2762879.length
                    local tmp_2762881 = tmp_2762880(slice_2762875)
                    local tmp_2762882 = param_2761981.someElem
                    local tmp_2762883 = {tmp_2762881, tmp_2762882}
                    arr_2762884 = tmp_2762878(tmp_2762883)
                    local tmp_2762885 = param_2761981._ArraySlice
                    local tmp_2762886 = tmp_2762885.copyVec
                    local tmp_2762887 = {di = 0, dst = arr_2762884, src = slice_2762875}
                    local tmp_2763430 = tmp_2762886(tmp_2762887)
                  end
                  local tmp_2762888 = param_2761981._ArraySlice
                  local tmp_2762889 = tmp_2762888.full
                  local tmp_2762890 = tmp_2762889(arr_2762884)
                  return waNB_2762873(tmp_2762890)
                end
                local tmp_2762895 = {tag = "SOME", payload = tmp_2762874}
                writeVecNB_PRIME_2762796 = tmp_2762895
                goto cont_2762868
              end
              local tmp_2762896 = writeArrNB_2762771.tag
              local tmp_2762897 = tmp_2762896 == "NONE"
              if tmp_2762897 then
                local tmp_2762900
                do
                  local tmp_2762898 = canOutput_2762775.tag
                  local tmp_2762899 = tmp_2762898 == "SOME"
                  if tmp_2762899 then
                    local tmp_2762950 = writeVec_2762765.tag
                    local tmp_2762951 = tmp_2762950 == "SOME"
                    tmp_2762900 = tmp_2762951
                  else
                    tmp_2762900 = false
                  end
                end
                ::cont_2762949::
                local tmp_2762914
                do
                  if tmp_2762900 then
                    local canOutput_PRIME_2762901 = canOutput_2762775.payload
                    local wv_2762902 = writeVec_2762765.payload
                    local tmp_2762903 = function(slice_2762904)
                      do
                        local tmp_2762906 = canOutput_PRIME_2762901(nil)
                        if tmp_2762906 then
                          goto then_2763431
                        else
                          return NONE_217
                        end
                      end
                      ::then_2763431::
                      do
                        local tmp_2762907 = wv_2762902(slice_2762904)
                        local tmp_2762908 = {tag = "SOME", payload = tmp_2762907}
                        return tmp_2762908
                      end
                    end
                    local tmp_2762911 = {tag = "SOME", payload = tmp_2762903}
                    writeVecNB_PRIME_2762796 = tmp_2762911
                    goto cont_2762868
                  end
                  local tmp_2762912 = canOutput_2762775.tag
                  local tmp_2762913 = tmp_2762912 == "SOME"
                  if tmp_2762913 then
                    local tmp_2762945 = writeVec_2762765.tag
                    local tmp_2762946 = tmp_2762945 == "NONE"
                    if tmp_2762946 then
                      local tmp_2762947 = writeArr_2762767.tag
                      local tmp_2762948 = tmp_2762947 == "SOME"
                      tmp_2762914 = tmp_2762948
                    else
                      tmp_2762914 = false
                    end
                  else
                    tmp_2762914 = false
                  end
                end
                ::cont_2762944::
                if tmp_2762914 then
                  local canOutput_PRIME_2762915 = canOutput_2762775.payload
                  local wa_2762916 = writeArr_2762767.payload
                  local tmp_2762917 = function(slice_2762918)
                    do
                      local tmp_2762920 = canOutput_PRIME_2762915(nil)
                      if tmp_2762920 then
                        goto then_2763432
                      else
                        return NONE_217
                      end
                    end
                    ::then_2763432::
                    do
                      local arr_2762928
                      do
                        local tmp_2762921 = param_2761981._Array
                        local tmp_2762922 = tmp_2762921.array
                        local tmp_2762923 = param_2761981._VectorSlice
                        local tmp_2762924 = tmp_2762923.length
                        local tmp_2762925 = tmp_2762924(slice_2762918)
                        local tmp_2762926 = param_2761981.someElem
                        local tmp_2762927 = {tmp_2762925, tmp_2762926}
                        arr_2762928 = tmp_2762922(tmp_2762927)
                        local tmp_2762929 = param_2761981._ArraySlice
                        local tmp_2762930 = tmp_2762929.copyVec
                        local tmp_2762931 = {di = 0, dst = arr_2762928, src = slice_2762918}
                        local tmp_2763433 = tmp_2762930(tmp_2762931)
                      end
                      local tmp_2762932 = param_2761981._ArraySlice
                      local tmp_2762933 = tmp_2762932.full
                      local tmp_2762934 = tmp_2762933(arr_2762928)
                      local tmp_2762935 = wa_2762916(tmp_2762934)
                      local tmp_2762936 = {tag = "SOME", payload = tmp_2762935}
                      return tmp_2762936
                    end
                  end
                  local tmp_2762943 = {tag = "SOME", payload = tmp_2762917}
                  writeVecNB_PRIME_2762796 = tmp_2762943
                else
                  writeVecNB_PRIME_2762796 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:416:41")
              end
            else
              _raise(_Match, "prim-io.sml:414:29")
            end
          end
        end
        ::cont_2762868::
        local writeArrNB_PRIME_2762799
        do
          local tmp_2762797 = writeArrNB_2762771.tag
          local tmp_2762798 = tmp_2762797 == "SOME"
          do
            if tmp_2762798 then
              writeArrNB_PRIME_2762799 = writeArrNB_2762771
              goto cont_2762802
            end
            local tmp_2762803 = writeArrNB_2762771.tag
            local tmp_2762804 = tmp_2762803 == "NONE"
            if tmp_2762804 then
              local tmp_2762805 = writeVecNB_2762769.tag
              local tmp_2762806 = tmp_2762805 == "SOME"
              if tmp_2762806 then
                local wvNB_2762807 = writeVecNB_2762769.payload
                local tmp_2762808 = function(slice_2762809)
                  local tmp_2762811 = param_2761981._VectorSlice
                  local tmp_2762812 = tmp_2762811.full
                  local tmp_2762813 = param_2761981._ArraySlice
                  local tmp_2762814 = tmp_2762813.vector
                  local tmp_2762815 = tmp_2762814(slice_2762809)
                  local vslice_2762816 = tmp_2762812(tmp_2762815)
                  return wvNB_2762807(vslice_2762816)
                end
                local tmp_2762819 = {tag = "SOME", payload = tmp_2762808}
                writeArrNB_PRIME_2762799 = tmp_2762819
                goto cont_2762802
              end
              local tmp_2762820 = writeVecNB_2762769.tag
              local tmp_2762821 = tmp_2762820 == "NONE"
              if tmp_2762821 then
                local tmp_2762824
                do
                  local tmp_2762822 = canOutput_2762775.tag
                  local tmp_2762823 = tmp_2762822 == "SOME"
                  if tmp_2762823 then
                    local tmp_2762864 = writeArr_2762767.tag
                    local tmp_2762865 = tmp_2762864 == "SOME"
                    tmp_2762824 = tmp_2762865
                  else
                    tmp_2762824 = false
                  end
                end
                ::cont_2762863::
                local tmp_2762838
                do
                  if tmp_2762824 then
                    local canOutput_PRIME_2762825 = canOutput_2762775.payload
                    local wa_2762826 = writeArr_2762767.payload
                    local tmp_2762827 = function(slice_2762828)
                      do
                        local tmp_2762830 = canOutput_PRIME_2762825(nil)
                        if tmp_2762830 then
                          goto then_2763434
                        else
                          return NONE_217
                        end
                      end
                      ::then_2763434::
                      do
                        local tmp_2762831 = wa_2762826(slice_2762828)
                        local tmp_2762832 = {tag = "SOME", payload = tmp_2762831}
                        return tmp_2762832
                      end
                    end
                    local tmp_2762835 = {tag = "SOME", payload = tmp_2762827}
                    writeArrNB_PRIME_2762799 = tmp_2762835
                    goto cont_2762802
                  end
                  local tmp_2762836 = canOutput_2762775.tag
                  local tmp_2762837 = tmp_2762836 == "SOME"
                  if tmp_2762837 then
                    local tmp_2762859 = writeVec_2762765.tag
                    local tmp_2762860 = tmp_2762859 == "SOME"
                    if tmp_2762860 then
                      local tmp_2762861 = writeArr_2762767.tag
                      local tmp_2762862 = tmp_2762861 == "NONE"
                      tmp_2762838 = tmp_2762862
                    else
                      tmp_2762838 = false
                    end
                  else
                    tmp_2762838 = false
                  end
                end
                ::cont_2762858::
                if tmp_2762838 then
                  local canOutput_PRIME_2762839 = canOutput_2762775.payload
                  local wv_2762840 = writeVec_2762765.payload
                  local tmp_2762841 = function(slice_2762842)
                    do
                      local tmp_2762844 = canOutput_PRIME_2762839(nil)
                      if tmp_2762844 then
                        goto then_2763435
                      else
                        return NONE_217
                      end
                    end
                    ::then_2763435::
                    do
                      local tmp_2762845 = param_2761981._VectorSlice
                      local tmp_2762846 = tmp_2762845.full
                      local tmp_2762847 = param_2761981._ArraySlice
                      local tmp_2762848 = tmp_2762847.vector
                      local tmp_2762849 = tmp_2762848(slice_2762842)
                      local vslice_2762850 = tmp_2762846(tmp_2762849)
                      local tmp_2762851 = wv_2762840(vslice_2762850)
                      local tmp_2762852 = {tag = "SOME", payload = tmp_2762851}
                      return tmp_2762852
                    end
                  end
                  local tmp_2762857 = {tag = "SOME", payload = tmp_2762841}
                  writeArrNB_PRIME_2762799 = tmp_2762857
                else
                  writeArrNB_PRIME_2762799 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:445:41")
              end
            else
              _raise(_Match, "prim-io.sml:443:29")
            end
          end
        end
        ::cont_2762802::
        local tmp_2762800 = {block = block_2762773, canOutput = canOutput_2762775, chunkSize = chunkSize_2762763, close = close_2762785, endPos = endPos_2762781, getPos = getPos_2762777, ioDesc = ioDesc_2762787, name = name_2762761, setPos = setPos_2762779, verifyPos = verifyPos_2762783, writeArr = writeArr_PRIME_2762793, writeArrNB = writeArrNB_PRIME_2762799, writeVec = writeVec_PRIME_2762790, writeVecNB = writeVecNB_PRIME_2762796}
        local tmp_2762801 = tmp_2762800
        return tmp_2762801
      end
      local tmp_2763154 = {RD = RD_2761984, WR = WR_2761988, augmentReader = augmentReader_2762270, augmentWriter = augmentWriter_2762757, compare = compare_2761983, nullRd = nullRd_2762131, nullWr = nullWr_2762198, openVector = openVector_2761992}
      return tmp_2763154
    end
    return tmp_2761980
  end
  return tmp_2761977
end
LOCAL_2763446[109] = 0x0 & 0xFF
LOCAL_2763446[110] = {all = tmp_2761878, app = tmp_2761879, appi = tmp_2761880, base = tmp_2761881, collate = LOCAL_2763446[15], concat = LOCAL_2763446[16], exists = LOCAL_2763446[17], find = LOCAL_2763446[18], findi = LOCAL_2763446[19], foldl = LOCAL_2763446[20], foldli = LOCAL_2763446[21], foldr = LOCAL_2763446[22], foldri = LOCAL_2763446[23], full = LOCAL_2763446[24], getItem = LOCAL_2763446[25], isEmpty = LOCAL_2763446[26], length = LOCAL_2763446[27], map = LOCAL_2763446[28], mapi = LOCAL_2763446[29], slice = LOCAL_2763446[30], sub = LOCAL_2763446[31], subslice = LOCAL_2763446[32], vector = LOCAL_2763446[33]}
LOCAL_2763446[111] = {all = LOCAL_2763446[34], app = LOCAL_2763446[35], append = LOCAL_2763446[36], appi = LOCAL_2763446[37], collate = LOCAL_2763446[38], concat = LOCAL_2763446[39], exists = LOCAL_2763446[40], find = LOCAL_2763446[41], findi = LOCAL_2763446[42], foldl = LOCAL_2763446[43], foldli = LOCAL_2763446[44], foldr = LOCAL_2763446[45], foldri = LOCAL_2763446[46], fromList = LOCAL_2763446[47], length = LOCAL_2763446[48], map = LOCAL_2763446[49], mapi = LOCAL_2763446[50], maxLen = LOCAL_2763446[51], prepend = LOCAL_2763446[52], sub = LOCAL_2763446[53], tabulate = LOCAL_2763446[54], toList = LOCAL_2763446[55], update = LOCAL_2763446[56]}
LOCAL_2763446[112] = {all = LOCAL_2763446[57], app = LOCAL_2763446[58], appi = LOCAL_2763446[59], base = LOCAL_2763446[60], collate = LOCAL_2763446[61], copy = LOCAL_2763446[62], copyVec = LOCAL_2763446[63], exists = LOCAL_2763446[64], find = LOCAL_2763446[65], findi = LOCAL_2763446[66], foldl = LOCAL_2763446[67], foldli = LOCAL_2763446[68], foldr = LOCAL_2763446[69], foldri = LOCAL_2763446[70], full = LOCAL_2763446[71], getItem = LOCAL_2763446[72], isEmpty = LOCAL_2763446[73], length = LOCAL_2763446[74], modify = LOCAL_2763446[75], modifyi = LOCAL_2763446[76], slice = LOCAL_2763446[77], sub = LOCAL_2763446[78], subslice = LOCAL_2763446[79], update = LOCAL_2763446[80], vector = LOCAL_2763446[81]}
LOCAL_2763446[113] = {all = LOCAL_2763446[82], app = LOCAL_2763446[83], appi = LOCAL_2763446[84], array = LOCAL_2763446[85], collate = LOCAL_2763446[86], copy = LOCAL_2763446[87], copyVec = LOCAL_2763446[88], exists = LOCAL_2763446[89], find = LOCAL_2763446[90], findi = LOCAL_2763446[91], foldl = LOCAL_2763446[92], foldli = LOCAL_2763446[93], foldr = LOCAL_2763446[94], foldri = LOCAL_2763446[95], fromList = LOCAL_2763446[96], fromVector = LOCAL_2763446[97], length = LOCAL_2763446[98], maxLen = LOCAL_2763446[99], modify = LOCAL_2763446[100], modifyi = LOCAL_2763446[101], sub = LOCAL_2763446[102], tabulate = LOCAL_2763446[103], toList = LOCAL_2763446[104], toVector = LOCAL_2763446[105], update = LOCAL_2763446[106], vector = LOCAL_2763446[107]}
LOCAL_2763446[114] = LOCAL_2763446[108]()
LOCAL_2763446[115] = LOCAL_2763446[114](eq_132)
LOCAL_2763446[116] = {_Array = LOCAL_2763446[113], _ArraySlice = LOCAL_2763446[112], _Vector = LOCAL_2763446[111], _VectorSlice = LOCAL_2763446[110], compare = compare_2759828, someElem = LOCAL_2763446[109]}
LOCAL_2763446[117] = LOCAL_2763446[115](LOCAL_2763446[116])
LOCAL_2763446[118] = {all = tmp_2761707, app = tmp_2761708, appi = tmp_2761709, base = tmp_2761710, collate = tmp_2761711, concat = tmp_2761712, exists = tmp_2761713, find = tmp_2761714, findi = tmp_2761715, foldl = tmp_2761716, foldli = tmp_2761717, foldr = tmp_2761718, foldri = tmp_2761719, full = tmp_2761720, getItem = tmp_2761721, isEmpty = tmp_2761722, length = tmp_2761723, map = tmp_2761724, mapi = tmp_2761725, slice = tmp_2761726, sub = tmp_2761727, subslice = tmp_2761728, vector = tmp_2761729}
LOCAL_2763446[119] = {all = tmp_2761730, app = tmp_2761731, append = tmp_2761732, appi = tmp_2761733, collate = tmp_2761734, concat = tmp_2761735, exists = tmp_2761736, find = tmp_2761737, findi = tmp_2761738, foldl = tmp_2761739, foldli = tmp_2761740, foldr = tmp_2761741, foldri = tmp_2761742, fromList = tmp_2761743, length = tmp_2761744, map = tmp_2761745, mapi = tmp_2761746, maxLen = tmp_2761747, prepend = tmp_2761748, sub = tmp_2761749, tabulate = tmp_2761750, toList = tmp_2761751, update = tmp_2761752}
LOCAL_2763446[120] = {all = tmp_2761753, app = tmp_2761754, appi = tmp_2761755, base = tmp_2761756, collate = tmp_2761757, copy = tmp_2761758, copyVec = tmp_2761759, exists = tmp_2761760, find = tmp_2761761, findi = tmp_2761762, foldl = tmp_2761763, foldli = tmp_2761764, foldr = tmp_2761765, foldri = tmp_2761766, full = tmp_2761767, getItem = tmp_2761768, isEmpty = tmp_2761769, length = tmp_2761770, modify = tmp_2761771, modifyi = tmp_2761772, slice = tmp_2761773, sub = tmp_2761774, subslice = tmp_2761775, update = tmp_2761776, vector = tmp_2761777}
LOCAL_2763446[121] = {all = tmp_2761778, app = tmp_2761779, appi = tmp_2761780, array = tmp_2761781, collate = tmp_2761782, copy = tmp_2761783, copyVec = tmp_2761784, exists = tmp_2761785, find = tmp_2761786, findi = tmp_2761787, foldl = tmp_2761788, foldli = tmp_2761789, foldr = tmp_2761790, foldri = tmp_2761791, fromList = tmp_2761792, fromVector = tmp_2761793, length = tmp_2761794, maxLen = tmp_2761795, modify = tmp_2761796, modifyi = tmp_2761797, sub = tmp_2761798, tabulate = tmp_2761799, toList = tmp_2761800, toVector = tmp_2761801, update = tmp_2761802, vector = tmp_2761803}
LOCAL_2763446[122] = LOCAL_2763446[108]()
LOCAL_2763446[123] = LOCAL_2763446[122](eq_132)
LOCAL_2763446[124] = {_Array = LOCAL_2763446[121], _ArraySlice = LOCAL_2763446[120], _Vector = LOCAL_2763446[119], _VectorSlice = LOCAL_2763446[118], compare = compare_2759828, someElem = 0}
LOCAL_2763446[125] = LOCAL_2763446[123](LOCAL_2763446[124])
LOCAL_2763446[126] = {LOCAL_2763446[4]}
LOCAL_2763446[127] = {buffer_mode = LOCAL_2763446[126], name = "<stdout>", writable = tmp_2759820}
LOCAL_2763446[128] = {tag = "LUA_WRITABLE", payload = LOCAL_2763446[127]}
LOCAL_2763446[129] = {LOCAL_2763446[128]}
LOCAL_2763446[130] = LOCAL_2763446[129][1]
LOCAL_2763446[131] = LOCAL_2763446[130].tag
LOCAL_2763446[132] = LOCAL_2763446[131] == "LUA_WRITABLE"
if LOCAL_2763446[132] then
  goto then_2763438
else
  goto else_2763439
end
::then_2763438::
do
  LOCAL_2763446[133] = LOCAL_2763446[130].payload
  LOCAL_2763446[134] = LOCAL_2763446[133].writable
  LOCAL_2763446[135] = LOCAL_2763446[130].payload
  LOCAL_2763446[136] = LOCAL_2763446[135].name
  LOCAL_2763446[137] = table_pack(LOCAL_2763446[134]:write("Hello, World\n"))
  LOCAL_2763446[138] = sub_2739427(LOCAL_2763446[137], 0)
  LOCAL_2763446[139] = not LOCAL_2763446[138]
  if LOCAL_2763446[139] then
    goto then_2763440
  else
    LOCAL_2763446[134]:flush()
    return
  end
  ::then_2763440::
  do
    LOCAL_2763446[140] = sub_2739427(LOCAL_2763446[137], 1)
    LOCAL_2763446[141] = _Fail(LOCAL_2763446[140])
    LOCAL_2763446[142] = {cause = LOCAL_2763446[141], ["function"] = "output", name = LOCAL_2763446[136]}
    LOCAL_2763446[143] = {tag = LOCAL_2763446[1], payload = LOCAL_2763446[142]}
    _raise(LOCAL_2763446[143], "text-io.sml:266:46")
  end
end
::else_2763439::
LOCAL_2763446[144] = LOCAL_2763446[130].tag
LOCAL_2763446[145] = LOCAL_2763446[144] == "PRIM_WRITER"
if LOCAL_2763446[145] then
  goto then_2763441
else
  _raise(_Match, "text-io.sml:372:9")
end
::then_2763441::
do
  LOCAL_2763446[146] = LOCAL_2763446[130].payload
  LOCAL_2763446[147] = LOCAL_2763446[146].writer
  LOCAL_2763446[148] = LOCAL_2763446[147]
  LOCAL_2763446[149] = LOCAL_2763446[148].name
  LOCAL_2763446[150] = LOCAL_2763446[130].payload
  LOCAL_2763446[151] = LOCAL_2763446[150].writer
  LOCAL_2763446[152] = LOCAL_2763446[151]
  LOCAL_2763446[153] = LOCAL_2763446[152].writeVec
  LOCAL_2763446[154] = LOCAL_2763446[130].payload
  LOCAL_2763446[155] = LOCAL_2763446[154].buffer
  LOCAL_2763446[156] = LOCAL_2763446[155][1]
  LOCAL_2763446[157] = {"Hello, World\n", LOCAL_2763446[156]}
  LOCAL_2763446[158] = revAppend_1832942(LOCAL_2763446[157], nil)
  do
    LOCAL_2763446[160] = _VectorOrArray_fromList(LOCAL_2763446[158])
    LOCAL_2763446[161] = tmp_2759826(LOCAL_2763446[160])
    LOCAL_2763446[159] = LOCAL_2763446[161]
  end
  ::cont_2763217::
  LOCAL_2763446[162] = LOCAL_2763446[153].tag
  LOCAL_2763446[163] = LOCAL_2763446[162] == "SOME"
  if LOCAL_2763446[163] then
    goto then_2763442
  else
    goto else_2763443
  end
  ::then_2763442::
  do
    LOCAL_2763446[164] = LOCAL_2763446[153].payload
    LOCAL_2763446[165] = tmp_2761720(LOCAL_2763446[159])
    LOCAL_2763446[166] = LOCAL_2763446[164](LOCAL_2763446[165])
    LOCAL_2763446[155][1] = nil
    return
  end
  ::else_2763443::
  LOCAL_2763446[167] = LOCAL_2763446[153].tag
  LOCAL_2763446[168] = LOCAL_2763446[167] == "NONE"
  if LOCAL_2763446[168] then
    LOCAL_2763446[169] = {cause = LOCAL_2763446[2], ["function"] = "output", name = LOCAL_2763446[149]}
    LOCAL_2763446[170] = {tag = LOCAL_2763446[1], payload = LOCAL_2763446[169]}
    _raise(LOCAL_2763446[170], "text-io.sml:377:26")
  else
    _raise(_Match, "text-io.sml:375:14")
  end
end
