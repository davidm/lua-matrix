-- require fit
package.path = "samples/?.lua;" .. package.path
local fit = require "fit"

-- Fit a straight line
-- x(i) = 2  | 3  | 4  | 5
-- y(i) = 5  | 9  | 15 | 21
-- model = y = a +  b * x
-- r(i) = y(i) - ( a + b * x(i) )
local a,b = fit.linear(	{ 2,3, 4, 5 }, { 5,9,15,21 } )
assert(math.abs(a - -6.4) < 0.001)
assert(math.abs(b - 5.4) < 0.001)

-- Fit a parabola
local a, b, c = fit.parabola(	{ 0,1,2,4,6 }, { 3,1,0,1,4 } )
assert(math.abs(a - 2.8251599147122) < 0.001)
assert(math.abs(b - -2.0490405117271) < 0.001)
assert(math.abs(c - 0.3773987206823) < 0.001)

-- Fit exponential
local a, b = fit.exponential( {1,  2,  3,  4,   5}, {1,3.1,5.6,9.1,12.9} )
assert(math.abs(a - 1.0077958966968) < 0.001)
assert(math.abs(b - 1.5834684450364) < 0.001)

print 'PASSED'
