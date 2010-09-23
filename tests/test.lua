-- test suite (run from parent directory).

package.path = './lua/?.lua;' .. package.path

dofile 'tests/test_complex.lua'
dofile 'tests/test_matrix.lua'
dofile 'tests/test_fit.lua'
print 'ALL PASSED'
