component {

  variables.verbose = false;

	function run() {
		var fileName = "input.txt";
		var tickCount = getTickCount();
    variables.verbose = true;
		partOne( fileName );
    variables.verbose = false;
		partTwo( fileName );
		print.yellowLine( "Solved in #getTickCount() - tickcount# ms" );
	}

	function example() {
		var fileName = "example.txt";
    variables.verbose = true;
		partOne( fileName );
    variables.verbose = false;
		partTwo( fileName );
	}

	function partOne( required string fileName ) {
    // Get grid
    var grid = readGrid( arguments.fileName );

    // Get start
    var src = getStartPosition( grid );
    
    // Get destination
    var dst = getEndPosition( grid );

    // Execute
    var res = solve( src, dst, grid );

    // Done
    print.green( "Part one: the fewest steps required to move from your current position to the location that should get the best signal is " ).yellowLine( count( res ) );

    // Print solution
    printSolution( res, grid );
	}

	function partTwo( required string fileName ) {
		// Get grid
    var grid = readGrid( arguments.fileName );

    // Get start positions
    var src = getStartPositions( grid );

    // Get destination
    var dst = getEndPosition( grid );

    // Execute
    var res = createObject( "java", "java.util.TreeSet" ).init();
    src.each( function( s ) {
      var g = grid.duplicate();
      var r = solve( arguments.s, dst, g );
      if( isDefined( "r" ) ) res.add( count( r ) );
    } );

    // Done
    print.green( "Part two: the fewest steps required to move starting from any square with elevation a to the location that should get the best signal is " ).yellowLine( res.first() );
	}

  function readGrid( required string fileName ) {
    // Init
    var grid = arrayNew( 2 );

    // Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Process
    while( !fileIsEOF( file ) ) {
      // Read line
      var line = fileReadLine( file );
      // Get characters
      var row = [];
      for( var i = 1; i <= len( line ); i++ ) {
        row.append( { "x": i, "y": grid.len() + 1, "f": 9999, "g": 9999, "h": 9999, "v": mid( line, i, 1 ) } );
      }
      // Done
      grid.append( row );
    }

    // Close file
    fileClose( file );

    // Done
    return grid;
  }

  function locate( required array grid, array chars = [], any constraint ) {
    // Default constrain (return all nodes)
    if( !arguments.keyExists( "constraint" ) || !isClosure( arguments.constraint ) ) {
      arguments.constraint = function( i, j ) {
        return true;
      }
    }

    // Init
    var res = [];

    // Process
    for( var i = 1; i <= arguments.grid.len(); i++ ) {
      for( var j = 1; j <= arguments.grid[ i ].len(); j++ ) {
        if( arguments.constraint( i, j ) && arguments.chars.find( arguments.grid[ i ][ j ].v ) != 0 ) {
          res.append( { "x": j, "y" : i } );
        }
      }
    }

    // Done
    return res;
  }

  function getStartPosition( required array grid ) {
    return locate( arguments.grid, [ "S" ] ).first();
  }

  function getStartPositions( required array grid ) {
    return locate( arguments.grid, [ "S", "a" ], function( i, j ) {
      return arguments.i == 1 || arguments.j == 1;
    } );
  }

  function getEndPosition( required array grid ) {
    return locate( grid, [ "E" ] ).first();
  }
  
  function printSolution( required struct pos, required array grid ) {
    // Traverse
    var path = {};
    while( arguments.pos.keyExists( "parent" ) ) {
      path[ arguments.pos.y ][ arguments.pos.x ] = arguments.pos;
      arguments.pos = arguments.pos.parent;
    }

    // Add start node
    path[ arguments.pos.y ][ arguments.pos.x ] = arguments.pos;

    // Output
    print.line();
    for( var i = 1; i <= arguments.grid.len(); i++ ) {
      for( var j = 1; j <= arguments.grid[ i ].len(); j++ ) {
        if( isDefined( "path[#i#][#j#]" ) ) print.text( "X" );
        else print.text( "." );
      }
      print.line();
    }
    print.line();
  }
  
  /* Solve the problem using A* search algorithm
   * https://en.wikipedia.org/wiki/A*_search_algorithm
   */
  function solve( required struct src, required struct dst, required array grid ) {
    // Get start node
    var start = arguments.grid[ arguments.src.y ][ arguments.src.x ];
    start.g = 0;
    start.h = h( arguments.src, arguments.dst );
    start.f = start.g + start.h;

    // Initialize
    var openList = [ start ];
    var closedList = [];

    // Process
    while( !openList.isEmpty() ) {
      // Get location with lowest F-score
      var pos = openList
        .sort( function( one, two ) {
          return two.f.compareTo( one.f );
        })
        .pop();
        
      // Destination was reached
      if( pos.x == arguments.dst.x && pos.y == arguments.dst.y ) return pos;

      // Remove from processing
      closedList.append( pos );

      // Get adjacent squares
      var neighbours = findNeighbours( pos, arguments.grid );
      
      // Process neighbours
      neighbours.each( function( n ) {
        // Check if in closed list
        var index = closedList.find( function( e ) {
          return arguments.e.x == n.x && arguments.e.y == n.y;
        });

        // In the closed list
        if( index != 0 ) continue;

        // Current g-score + distance between current & neighbour
        var g = pos.g + 1;
        
        // Path needs updating
        if( g < arguments.n.g ) {
          arguments.n.g = g;
          arguments.n.f = g + arguments.n.h;
          arguments.n.parent = pos;

          // Check if in open list
          index = openList.find( function( e ) {
            return arguments.e.x == n.x && arguments.e.y == n.y;
          });

          // Add if needed
          if( index == 0 ) openList.add( arguments.n );
        }
      });
    }
  }

  /* Heuristic function using taxicab distance
   * https://en.wikipedia.org/wiki/Taxicab_geometry
   */
  function h( required struct pos, required struct dst ) {
    return abs( arguments.pos.x - arguments.dst.x ) + abs( arguments.pos.y - arguments.dst.y );
  }

  function findNeighbours( required struct pos, required array grid ) {
    // Init
    var res = [];

    // Top
    var t = { "x": arguments.pos.x, "y": arguments.pos.y - 1 };
    if ( valid( t, arguments.pos, arguments.grid ) ) res.append( t );
    
    // Right
    var r = { "x": arguments.pos.x + 1, "y": arguments.pos.y };
    if( valid( r, arguments.pos, arguments.grid ) ) res.append( r );

    // Bottom
    var b = { "x": arguments.pos.x, "y": arguments.pos.y + 1 };
    if( valid( b, arguments.pos, arguments.grid ) ) res.append( b ) ;

    // Left
    var l = { "x": arguments.pos.x - 1, "y": arguments.pos.y };
    if( valid( l, arguments.pos, arguments.grid ) ) res.append( l );
   
    // Done
    return res.map( function( n ) {
      return grid[ arguments.n.y ][ arguments.n.x ];
    } );
  }

  function valid( required struct newPos, required struct curPos, required array grid ) {
    // x-pos between boundaries
    if( !( arguments.newPos.x >= 1 && arguments.newPos.x <= arguments.grid[ arguments.curPos.y ].len() ) ) return false; 

    // y-pos between boundaries
    if( !( arguments.newPos.y >= 1 && arguments.newPos.y <= arguments.grid.len() ) ) return false;

    // Default
    return value( arguments.grid[ arguments.newPos.y ][ arguments.newPos.x ].v ) <= value( arguments.grid[ arguments.curPos.y ][ arguments.curPos.x ].v ) + 1;
  }

  function value( required string char ) {
    if( compare( arguments.char, "S" ) == 0 ) arguments.char = "a";
    else if( compare( arguments.char, "E" ) == 0 ) arguments.char = "z";
    return asc( arguments.char ) - 96;
  }

  function count( required struct pos ) {
    // Init
    var count = 0;
    // Traverse
    while( pos.keyExists( "parent" ) ) {
      count++;
      pos = pos.parent;
    }
    // Done
    return count;
  }
}
