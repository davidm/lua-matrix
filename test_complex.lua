local complex = require "complex"

local cx,cx1,cx2,re,im

-- complex.to / complex call
cx = complex { 2,3 }
assert( tostring( cx ) == "2+3i" )
cx = complex ( 2 )
assert( tostring( cx ) == "2" )
assert( cx:tostring() == 2 )
cx = complex "2^2+3/2i"
assert( tostring( cx ) == "4+1.5i" )
cx = complex ".5-2E-3i"
assert( tostring( cx ) == "0.5-0.002i" )
cx = complex "3i"
assert( tostring( cx ) == "3i" )
cx = complex "2"
assert( tostring( cx ) == "2" )
assert( cx:tostring() == 2 )
assert( complex "2 + 4i" == nil )

-- complex.new
cx = complex.new( 2,3 )
assert( tostring( cx ) == "2+3i" )

-- complex.type
assert( complex.type( cx ) == "complex" )
assert( complex.type( {} ) == nil )

-- complex.convpolar( radius, phi )
assert( complex.convpolar( 3, 0 ):round(10) == complex "3" )
assert( complex.convpolar( 3, math.pi/2 ):round(10) == complex "3i" )
assert( complex.convpolar( 3, math.pi ):round(10) == complex "-3" )
assert( complex.convpolar( 3, math.pi*3/2 ):round(10) == complex "-3i" )
assert( complex.convpolar( 3, math.pi*2 ):round(10) == complex "3" )

-- complex.convpolardeg( radius, phi )
assert( complex.convpolardeg( 3, 0 ):round(10) == complex "3" )
assert( complex.convpolardeg( 3, 90 ):round(10) == complex "3i" )
assert( complex.convpolardeg( 3, 180 ):round(10) == complex "-3" )
assert( complex.convpolardeg( 3, 270 ):round(10) == complex "-3i" )
assert( complex.convpolardeg( 3, 360 ):round(10) == complex "3" )

-- complex.tostring( cx,formatstr )
cx = complex "2+3i"
assert( complex.tostring( cx ) == "2+3i" )
assert( complex.tostring( cx, "%.2f" ) == "2.00+3.00i" )
-- does not support a second argument
assert( tostring( cx, "%.2f" ) == "2+3i" )

-- complex.polar( cx )
local r,phi = complex.polar( {3,0} )
assert( r == 3 )
assert( phi == 0 )

local r,phi = complex.polar( {0,3} )
assert( r == 3 )
assert( phi == math.pi/2 )

local r,phi = complex.polar( {-3,0} )
assert( r == 3 )
assert( phi == math.pi )

local r,phi = complex.polar( {0,-3} )
assert( r == 3 )
assert( phi == -math.pi/2 )

-- complex.polardeg( cx )
local r,phi = complex.polardeg( {3,0} )
assert( r == 3 )
assert( phi == 0 )

local r,phi = complex.polardeg( {0,3} )
assert( r == 3 )
assert( phi == 90 )

local r,phi = complex.polardeg( {-3,0} )
assert( r == 3 )
assert( phi == 180 )

local r,phi = complex.polardeg( {0,-3} )
assert( r == 3 )
assert( phi == -90 )

-- complex.mulconjugate( cx )
cx = complex "2+3i"
assert( complex.mulconjugate( cx ) == 13 )

-- complex.abs( cx )
cx = complex "3+4i"
assert( complex.abs( cx ) == 5 )

-- complex.get( cx )
cx = complex "2+3i"
re,im = complex.get( cx )
assert( re == 2 )
assert( im == 3 )

-- complex.set( cx, re, im )
cx = complex "2+3i"
complex.set( cx, 3, 2 )
assert( cx == complex "3+2i" )

-- complex.is( cx, re, im )
cx = complex "2+3i"
assert( complex.is( cx, 2, 3 ) == true )
assert( complex.is( cx, 3, 2 ) == false )

-- complex.copy( cx )
cx = complex "2+3i"
cx1 = complex.copy( cx )
complex.set( cx, 1, 1 )
assert( cx1 == complex "2+3i" )

-- complex.add( cx1, cx2 )
cx1 = complex "2+3i"
cx2 = complex "3+2i"
assert( complex.add(cx1,cx2) == complex "5+5i" )

-- complex.sub( cx1, cx2 )
cx1 = complex "2+3i"
cx2 = complex "3+2i"
assert( complex.sub(cx1,cx2) == complex "-1+1i" )

-- complex.mul( cx1, cx2 )
cx1 = complex "2+3i"
cx2 = complex "3+2i"
assert( complex.mul(cx1,cx2) == complex "13i" )

-- complex.mulnum( cx, num )
cx = complex "2+3i"
assert( complex.mulnum( cx, 2 ) == complex "4+6i" )

-- complex.div( cx1, cx2 )
cx1 = complex "2+3i"
cx2 = complex "3-2i"
assert( complex.div(cx1,cx2) == complex "i" )

-- complex.divnum( cx, num )
cx = complex "2+3i"
assert( complex.divnum( cx, 2 ) == complex "1+1.5i" )

-- complex.pow( cx, num )
cx = complex "2+3i"
assert( complex.pow( cx, 3 ) == complex "-46+9i" )

cx = complex( -121 )
cx = cx^.5
-- we have to round here due to the polar calculation of the squareroot
cx = cx:round( 10 )
assert( cx == complex "11i" )

cx = complex"2+3i"
assert( cx^-2 ~= 1/cx^2 )
assert( cx^-2 == (cx^-1)^2 )
assert( tostring( cx^-2 ) == tostring( 1/cx^2 ) )

-- complex.sqrt( cx )
cx = complex( -121 )
assert( complex.sqrt( cx ) == complex "11i" )
cx = complex "2-3i"
cx = cx^2
assert( cx:sqrt() == complex "2-3i" )

-- complex.ln( cx )
cx = complex "3+4i"
assert( cx:ln():round( 4 ) == complex "1.6094+0.9273i" )

-- complex.exp( cx )
cx = complex "2+3i"
assert( cx:ln():exp() == complex "2+3i" )

-- complex.conjugate( cx )
cx = complex "2+3i"
assert( cx:conjugate() == complex "2-3i" )

-- metatable

-- __add
cx = complex "2+3i"
assert( cx+2 == complex "4+3i" )

-- __unm
cx = complex "2+3i"
assert( -cx == complex "-2-3i" )