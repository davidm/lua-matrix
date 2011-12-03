-- test suite (run from parent directory).

local here = arg[0]:gsub('[^/\\]+$', '')
package.path = here .. '../lua/?.lua;' .. package.path
package.path = here .. '../samples/?.lua;' .. package.path

dofile(here .. 'test_complex.lua')
dofile(here .. 'test_matrix.lua')
dofile(here .. 'test_fit.lua')
print 'ALL PASSED'
