-- require fit
local fit = require "fit"

print( "Fit a straight line " )
-- x(i) = 2  | 3  | 4  | 5
-- y(i) = 5  | 9  | 15 | 21
-- model = y = a +  b * x
-- r(i) = y(i) - ( a + b * x(i) )
local a,b = fit.linear(	{ 2,3, 4, 5 },
								{ 5,9,15,21 } )
print( "=>    y = ( "..a.." )  +  ( "..b.." ) * x")

print( "Fit a parabola " )
local a, b, c = fit.parabola(	{ 0,1,2,4,6 },
											{ 3,1,0,1,4 } )
print( "=>    y = ( "..a.." )  +  ( "..b.." ) * x  +  ( "..c.." ) * x²")

print( "Fit exponential" )
local a, b = fit.exponential( {1,  2,  3,  4,   5},
										{1,3.1,5.6,9.1,12.9} )
print( "=>    y = ( "..a.." )  *  x^( "..b.." )")
	