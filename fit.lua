--///////////////////--
--// Curve Fitting //--
--///////////////////--

-- v 0.2

-- Lua 5.1 compatible

-- little add-on to the matrix module, to show some curve fitting

-- http://luaforge.net/projects/LuaMatrix
-- http://lua-users.org/wiki/SimpleFit

-- Licensed under the same terms as Lua itself.

-- requires matrix module
local matrix = require "matrix"

-- The Fit Table
local fit = {}

-- Note all these Algos use the Gauss-Jordan Method to caculate equation systems

-- function to get the results
local function getresults( mtx )
	assert( #mtx+1 == #mtx[1], "Cannot calculate Results" )
	mtx:dogauss()
	-- tresults
	local cols = #mtx[1]
	local tres = {}
	for i = 1,#mtx do
		tres[i] = mtx[i][cols]
	end
	return unpack( tres )
end

-- fit.linear ( x_values, y_values )
-- fit a straight line
-- model (  y = a + b * x  )
-- returns a, b
function fit.linear( x_values,y_values )
	-- x_values = { x1,x2,x3,...,xn }
	-- y_values = { y1,y2,y3,...,yn }
	
	-- values for A matrix
	local a_vals = {}
	-- values for Y vector
	local y_vals = {}

	for i,v in ipairs( x_values ) do
		a_vals[i] = { 1, v }
		y_vals[i] = { y_values[i] }
	end

	-- create both Matrixes
	local A = matrix:new( a_vals )
	local Y = matrix:new( y_vals )

	local ATA = matrix.mul( matrix.transpose(A), A )
	local ATY = matrix.mul( matrix.transpose(A), Y )

	local ATAATY = matrix.concath(ATA,ATY)

	return getresults( ATAATY )
end

-- fit.parabola ( x_values, y_values )
-- Fit a parabola
-- model (  y = a + b * x + c * x² )
-- returns a, b, c
function fit.parabola( x_values,y_values )
	-- x_values = { x1,x2,x3,...,xn }
	-- y_values = { y1,y2,y3,...,yn }

	-- values for A matrix
	local a_vals = {}
	-- values for Y vector
	local y_vals = {}

	for i,v in ipairs( x_values ) do
		a_vals[i] = { 1, v, v*v }
		y_vals[i] = { y_values[i] }
	end

	-- create both Matrixes
	local A = matrix:new( a_vals )
	local Y = matrix:new( y_vals )

	local ATA = matrix.mul( matrix.transpose(A), A )
	local ATY = matrix.mul( matrix.transpose(A), Y )

	local ATAATY = matrix.concath(ATA,ATY)

	return getresults( ATAATY )
end

-- fit.exponential ( x_values, y_values )
-- Fit exponential
-- model (  y = a * x^b )
-- returns a, b
function fit.exponential( x_values,y_values )
	-- convert to linear problem
	-- ln(y) = ln(a) + b * ln(x)
	for i,v in ipairs( x_values ) do
		x_values[i] = math.log( v )
		y_values[i] = math.log( y_values[i] )
	end

	local a,b = fit.linear( x_values,y_values )

	return math.exp(a), b
end

return fit

--///////////////--
--// chillcode //--
--///////////////--