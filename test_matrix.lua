local matrix, complex = require "matrix"

local mtx, m1,m2,m3,m4,m5, ms,ms1,ms2,ms3,ms4

-- test matrix:new/matrix call function
-- normal matrix
mtx = matrix {{1,2},{3,4}}
assert( tostring(mtx) == "1\t2\n3\t4" )
-- vector
mtx = matrix {1,2,3}
assert( tostring(mtx) == "1\n2\n3" )
-- matrix with size 2x2
mtx = matrix (2,2)
assert( tostring(mtx) == "0\t0\n0\t0" )
-- matrix with size 2x2 and default value 1/3
mtx = matrix (2,2,1/3)
assert( tostring(mtx) == "0.33333333333333\t0.33333333333333\n0.33333333333333\t0.33333333333333" )
-- identity matrix with size 2x2
mtx = matrix (2,"I")
assert( tostring(mtx) == "1\t0\n0\t1" )

-- matrix.add; number
m1 = matrix{{8,4,1},{6,8,3}}
m2 = matrix{{-8,1,3},{5,2,1}}
assert(m1 + m2 == matrix{{0,5,4},{11,10,4}})
-- matrix.add; complex
m1 = matrix{{10,"2+6i",1},{5,1,"4-2i"}}:tocomplex()
m2 = matrix{{3,4,5},{"2+3i",4,"6i"}}:tocomplex()
assert(m1 + m2 == matrix{{13,"6+6i",6},{"7+3i",5,"4+4i"}}:tocomplex())
-- matrix.add; symbol
m1 = matrix{{8,4,1},{6,8,3}}:tosymbol()
m2 = matrix{{-8,1,3},{5,2,1}}:tosymbol()
assert(m1 + m2 == matrix{{"8+-8","4+1","1+3"},{"6+5","8+2","3+1"}}:tosymbol())

-- matrix.sub; number
m1 = matrix{{8,4,1},{6,8,3}}
m2 = matrix{{-8,1,3},{5,2,1}}
assert(m1 - m2 == matrix{{16,3,-2},{1,6,2}})
-- matrix.sub; complex
m1 = matrix{{10,"2+6i",1},{5,1,"4-2i"}}:tocomplex()
m2 = matrix{{3,4,5},{"2+3i",4,"6i"}}:tocomplex()
assert(m1 - m2 == matrix{{7,"-2+6i",-4},{"3-3i",-3,"4-8i"}}:tocomplex())
-- matrix.sub; symbol
m1 = matrix{{8,4,1},{6,8,3}}:tosymbol()
m2 = matrix{{-8,1,3},{5,2,1}}:tosymbol()
assert(m1 - m2 == matrix{{"8--8","4-1","1-3"},{"6-5","8-2","3-1"}}:tosymbol())

-- matrix.mul; number
m1 = matrix{{8,4,1},{6,8,3}}
m2 = matrix{{3,1},{2,5},{7,4}}
assert(m1 * m2 == matrix{{39,32},{55,58}})
-- matrix.mul; complex
m1 = matrix{{"1+2i","3-i"},{"2-2i","1+i"}}:tocomplex()
m2 = matrix{{"i","5-i"},{2,"1-i"}}:tocomplex()
assert( m1*m2 == matrix{{"4-i","9+5i"},{"4+4i","10-12i"}}:tocomplex() )
-- matrix.mul; symbol
m1 = matrix{{8,4,1},{6,8,3}}:tosymbol()
m2 = matrix{{3,1},{2,5},{7,4}}:tosymbol()
assert(m1 * m2 == matrix{
  {"(8)*(3)+(4)*(2)+(1)*(7)", "(8)*(1)+(4)*(5)+(1)*(4)"},
  {"(6)*(3)+(8)*(2)+(3)*(7)", "(6)*(1)+(8)*(5)+(3)*(4)"}
}:tosymbol())

-- matrix.div; number, same for complex, not for symbol
m1 = matrix {{1,2},{3,4}}
m2 = matrix {{4,5},{6,7}}
assert( m1*m2^-1 == m1/m2 )

-- matrix.divnum; number, same complex
m2 = matrix {{4,5},{6,7}}
assert( m2/2 == matrix{{2,2.5},{3,3.5}} )
mtx = matrix {{3,5,1},{2,4,5},{1,2,2}}
assert( 2 / mtx == matrix{{4,16,-42},{-2,-10,26},{0,2,-4}} )
-- matrix.mulnum; symbol
m1 = m1:tosymbol()
assert( m1*2 == matrix{{"(1)*(2)","(2)*(2)"},{"(3)*(2)","(4)*(2)"}}:tosymbol() )
assert( m1/2 == matrix{{"(1)/(2)","(2)/(2)"},{"(3)/(2)","(4)/(2)"}}:tosymbol() )

-- matrix.pow; number, same complex
mtx = matrix{{3,5,1},{2,4,5},{1,2,2}}
assert(mtx^3 == matrix{{164,308,265},{161,303,263},{76,143,124}})
assert(mtx^1 == mtx)
assert(mtx^0 == matrix{{1,0,0},{0,1,0},{0,0,1}} )
assert(mtx^-1 == mtx:invert())
assert(mtx^-3 == (mtx^-1)^3)
mtx = matrix{{1,2,3},{1,2,3},{3,2,1}} -- singular
assert(mtx^-1 == nil)
local m1,rank = mtx:invert(); assert(m1 == nil and rank == 2)
mtx = matrix{{1,2},{3,4},{5,6}} -- non-square
assert(select(2, pcall(function() return mtx^-1 end))
       :find("matrix not square"))

-- matrix.det; number
mtx = matrix {{1,4,3,2},{2,1,-1,-1},{-3,2,2,-2},{-1,-5,-4,1}}
assert( mtx:det() == 78 )
-- matrix.det; complex
m1 = matrix{{"1+2i","3-i"},{"2-2i","1+i"}}:tocomplex()
m2 = matrix{{"i","5-i"},{2,"1-i"}}:tocomplex()
m3 = m1*m2
-- (checked in maple)
assert( m3:det() == complex "12-114i" )
mtx = {{"2+3i","1+4i","-2i",3,2},
	{"2i",3,"2+3i",0,3},
	{3,"-2i",6,"4+5i",0},
	{1,"1+2i",3,5,7},
	{"-3+3i","3+3i",3,-8,2}}
matrix(mtx):tocomplex()
-- (checked in maple)
assert( mtx:det():round(10) == complex "5527+2687i" )

-- matrix.invert; number
--1
mtx = matrix{{3,5,1},{2,4,5},{1,2,2}}
local mtxinv = matrix{{2,8,-21},{-1,-5,13},{0,1,-2}}
assert( mtx^-1 == mtxinv )
--2
mtx = matrix{{1,0,2},{4,1,1},{3,2,-7}} 
local mtxinv = matrix{{-9,4,-2},{31,-13,7},{5,-2,1}}
assert( mtx^-1 == mtxinv )
-- matrix.invert; complex
mtx = {
{ 3,"4-3i",1},
{3,"-1+5i",-3},
{4,0,7},
}
matrix.tocomplex( mtx )
local mtxinv = mtx^-1
local mtxinvcomp = {
{"0.13349-0.07005i","0.14335+0.03609i","0.04237+0.02547i"},
{"0.08771+0.10832i","-0.04519-0.0558i","-0.0319-0.03939i"},
{"-0.07628+0.04003i","-0.08192-0.02062i","0.11865-0.01456i"},}
mtxinvcomp = matrix( mtxinvcomp )
mtxinv:round( 5 )
mtxinv:remcomplex()
assert( mtxinvcomp == mtxinv  )

-- matrix.sqrt; number
local m1 = matrix{{4,2,1},{1,5,4},{1,5,2}}
local m2 = m1*m1
local msqrt = m2:sqrt()
assert((m2 - msqrt^2):normmax() < 1E-12)
-- matrix.sqrt; complex
local m1 = matrix{{4,"2+i",1},{1,5,"4-2i"},{1,"5+3i",2}}:tocomplex()
local m2 = m1*m1
local msqrt = m2:sqrt()
assert((m2 - msqrt^2):normmax() < 1E-12)

-- matrix.root; number
local p = 3
local m1 = matrix {{4,2,3},{1,9,7},{6,5,8}}
local m2 = m1^p
local mroot = m2:root(p)
assert((m2 - mroot^p):normmax() < 1E-7)
-- matrix.root; complex
local m1 = matrix{{4,"2+i",1},{1,5,"4-2i"},{1,"5+3i",2}}:tocomplex()
local m2 = m1^p
local mroot = m2:root(p)
assert((m2 - mroot^p):normmax() < 1E-7)

-- matrix.normf
mtx = matrix{{2,3},{-2,-3}}
assert(mtx:normf() == math.sqrt(2^2+3^2+2^2+3^2))
mtx = matrix{{'2i','3'},{'-2i','-3'}}:tocomplex()
assert(mtx:normf() == math.sqrt(2^2+3^2+2^2+3^2))
mtx = matrix{{'a','b'},{'c','d'}}:tosymbol()
assert(tostring(mtx:normf()) == "(0+((a):abs())^(2)+((b):abs())^(2)+((c):abs())^(2)+((d):abs())^(2)):sqrt()")

-- matrix.normmax
-- note: symbolic matrices not supported
mtx = matrix{{2,3},{-2,-4}}
assert(mtx:normmax() == 4)
mtx = matrix{{'2i','3'},{'-2i','-4i'}}:tocomplex()
assert(mtx:normmax() == 4)

-- matrix.transpose
-- test transpose; number, same for all others
mtx = matrix{{3,5,1},{2,4,5},{1,2,2}}
assert(mtx^'T' == matrix{{3,2,1},{5,4,2},{1,5,2}})

-- matrix.rotl; number, same for all others
local m1 = matrix{{2,3},{4,5},{6,7}}
assert( m1:rotl() == matrix{{3,5,7},{2,4,6}} )
-- matris.rotr; number, same for all others
assert( m1:rotr() == matrix{{6,4,2},{7,5,3}} )

-- matrix.tostring; number
mtx = matrix{{4,2,-3},{3,-5,2}}
assert(tostring(mtx) == "4\t2\t-3\n3\t-5\t2" )
-- matrix.tostring; complex
mtx = matrix{{4,"2+i"},{"3-4i",5}}:tocomplex()
assert(tostring(mtx) == "4\t2+i\n3-4i\t5" )
-- matrix.tostring; tensor
local mt = matrix {{{1,2},{3,4}},{{5,6},{7,8}}}
assert( tostring(mt) == "[1,2]\t[3,4]\n[5,6]\t[7,8]" )
local i,j,k = mt:size()
assert( i == 2 ); assert( j == 2 );assert( k == 2 )

-- matrix.latex; tensor
local mt = matrix {{{1,2},{3,4}},{{5,6},{7,8}}}
assert( mt:latex() == "$\\left( \\begin{array}{cc}\n\t[1,2] & [3,4] \\\\\n\t[5,6] & [7,8]\n\\end{array} \\right)$" )

-- matrix.cross
local e1 = matrix{ 1,0,0 }
local e2 = matrix{ 0,1,0 }
local e3 = e1:cross( e2 )
assert( e3 == matrix{ 0,0,1 } )

-- matrix.scalar
local v1 = matrix{ 2,3,0, }
local v2 = matrix{ 0,3,4 }
local vx = v1:cross( v2 )
assert( v1:scalar( vx ) == 0 )
assert( vx:scalar( v2 ) == 0 )

-- matrix.len
assert( v2:len() == math.sqrt( 3^2+4^2 ) )

--// test symbolic
ms = matrix {{ "a",1 },{2,"b"}}:tosymbol()
ms2 = matrix {{ "a",2 },{"b",3}}:tosymbol()
ms3 = ms2+ms
ms3 = ms3:replace( "a",4,"b",2 )
ms3 = ms3:solve()
assert( ms3 == matrix {{8,3},{4,5}} )
ms4 = ms2*ms
ms4 = ms4:replace( "a",4,"b",2 )
ms4 = ms4:solve()
assert( ms4 == matrix {{20,8},{14,8}} )

-- __unm
mtx = matrix{{4,2},{3,5}}
assert(-mtx == matrix{{-4,-2},{-3,-5}})

-- test inverted with big table
--[[mtx = matrix:new( 100,100 )
mtx:random( -100,100 )
--mtx:print()
t1 = os.clock()
identm = mtx*mtx^-1
print("Diff:",os.clock()-t1 )
-- round to 8 decimal points
-- this depends on the numbers used, small, big, range
-- the average error in this calculation was 10^-9
identm:round( 8 )
--identm:print()
ident = matrix:new( 100, "I" )
assert( identm == ident )--]]



local t = {}
for i,v in pairs( matrix ) do
	table.insert( t, i )
end
table.sort( t )
for i,v in ipairs( t ) do
	--print( "matrix."..v )
end