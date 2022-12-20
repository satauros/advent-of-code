component {

  variables.verbose = false;
  variables.INFINITY = 9999;

	function run() {
		var fileName = "input.txt";
		var tickCount = getTickCount();
		partOne( fileName );
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
    // Get input
    var cave = readCoordinates( arguments.fileName );

    // Drop position
    var origin = { "x": 500, "y": 0 };

    // Drop
    var count = 0;
    while( drop( origin, cave, local ) ) {
      if ( variables.verbose ) {
        printCave( cave, origin );
      }
    }

    // Verbose
    printCave( cave, origin );

    // Done
    print.green( "Part one: " ).yellowText( count ).greenLine( " units of sand came to rest before sand starts flowing into the abyss below" );
	}

	function partTwo( required string fileName ) {
    // Get input
    var cave = readCoordinates( arguments.fileName );

    // Add floor
    cave.max.y += 2;
    for( var x = cave.min.x - 500; x <= cave.max.x + 500; x++ ) {
      cave.stones[ "#x#,#cave.max.y#" ] = "##";
    }

    // Drop position
    var origin = { "x": 500, "y": 0 };

    // Drop
    var count = 1;
    while( drop( origin, cave, local ) ) {
      if ( variables.verbose ) {
        printCave( cave, origin );
      }
    }

    // Add sand
    cave.sand[ "#origin.x#,#origin.y#" ] = "o";

    // Verbose
    // printCave( cave, origin );

    // Done
    print.greenText( "Part two: ").yellowText( count ).greenLine( " units of sand come to rest before the input becomes blocked" );
	}

  function drop( required struct origin, required struct cave, required struct context ) {
    // Move
    var pos = move( arguments.origin, arguments.cave );

    // Check if we can still drop
    if( !abyss( pos ) && pos.y != arguments.origin.y ) {
      arguments.context.count++;
      arguments.cave.sand[ "#pos.x#,#pos.y#" ] = "o";
      return true;
    }

    // Done
    return false;
  }

  function move( required struct pos, required struct cave ) {
    // Into the abyss => infinity
    if( arguments.pos.y >= arguments.cave.max.y ) {
      // print.red( "To infinity ... AND BEYOND " ).text( arguments.pos );
      return { "x": arguments.pos.x, "y": variables.INFINITY };
    } 
    // Path down is not blocked, continue down
    var downPos = { "x": arguments.pos.x, "y": arguments.pos.y + 1 };
    if( !blocked( downPos, arguments.cave ) ) {
      return move( downPos, arguments.cave );
    }
    // Path left is not blocked, continue left
    var leftPos = { "x": arguments.pos.x - 1, "y": arguments.pos.y + 1 };
    if( !blocked( leftPos, arguments.cave ) ) {
      return move( leftPos, arguments.cave );
    }
    // Path right is not blocked, continue right
    var rightPos = { "x": arguments.pos.x + 1, "y": arguments.pos.y + 1 };
    if( !blocked( rightPos, arguments.cave ) ) {
      return move( rightPos, arguments.cave );
    }
    // Rest
    return arguments.pos;
  }

  function blocked( required struct pos, required struct cave ) {
    // Blocked by stone
    if( arguments.cave.stones.keyExists( "#arguments.pos.x#,#arguments.pos.y#" ) ) return true;
    
    // Blocked by sand 
    if( arguments.cave.sand.keyExists( "#arguments.pos.x#,#arguments.pos.y#" ) ) return true;

    // Default
    return false;
  }

  function readCoordinates( required string fileName ) {
    // Init
    var res = { "sand" : {} };
    var x = createObject( "java", "java.util.TreeSet" );
    var y = createObject( "java", "java.util.TreeSet" );

    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Process
    res.stones = {};
    while( !fileIsEOF( file ) ) {
      line = fileReadLine( file );
      listToArray( line, " -> " ).each( function( e, i, src ) {
        // Skip first element
        if( i == 1 ) continue; 
        // Get stone coordinates
        var s = { "x": val( listFirst( arguments.src[ arguments.i - 1 ], "," ) ), "y": val( listLast( arguments.src[ arguments.i - 1 ], "," ) ) };
        var e = { "x": val( listFirst( arguments.e, "," ) ), "y": val( listLast( arguments.e, "," ) ) };
        // Down
        if( s.x == e.x && s.y <= e.y) {
          for( var i = s.y; i <= e.y; i++ ) {
            var stone = { "x": s.x, "y": i };
            x.add( stone.x );
            y.add( stone.y );
            res.stones[ "#stone.x#,#stone.y#" ] = stone;
          } 
        }
        // Up
        else if( s.x == e.x && s.y >= e.y ) {
          for( var i = e.y; i <= s.y; i++ ) {
            var stone = { "x": s.x, "y": i };
            x.add( stone.x );
            y.add( stone.y );
            res.stones[ "#stone.x#,#stone.y#" ] = stone;
          }
        }
        // Left
        else if( s.x >= e.x && s.y == e.y ) {
          for( var i = e.x; i <= s.x; i++ ) {
            var stone = { "x": i, "y": s.y };
            x.add( stone.x );
            y.add( stone.y );
            res.stones[ "#stone.x#,#stone.y#" ] = stone;
          }
        }
        // Right
        else if( s.x <= e.x && s.y == e.y ) {
          for( var i = s.x; i <= e.x; i++ ) {
            var stone = { "x": i, "y": s.y };
            x.add( stone.x );
            y.add( stone.y );
            res.stones[ "#stone.x#,#stone.y#" ] = stone;
          }
        }
      } );
    }

    // Close file
    fileClose( file );

    // Add metadata
    res.min = { "x" : x.first() , "y": y.first() };
    res.max = { "x" : x.last(), "y": y.last() };

    // Done
    return res;
  }

  function printCave( required struct cave, struct origin = { "x" : 500, "y": 0 } ) {
    // Determine padding
    var padding = len( arguments.cave.max.y ) + 1;
    
    // First line
    print.text( "#padRight( "", padding )##left( arguments.cave.min.x, 1 )##repeatString( " ", arguments.origin.x - arguments.cave.min.x - 1 )#" );
    print.text( "#left( arguments.origin.x, 1 )##repeatString( " ", arguments.cave.max.x - arguments.origin.x - 1 )#" );
    print.line( "#left( arguments.cave.max.x, 1 )#" );

    // Second line
    print.text( "#padRight( "", padding )##mid( arguments.cave.min.x, 2, 1 )##repeatString( " ", arguments.origin.x - arguments.cave.min.x - 1 )#" );
    print.text( "#mid( arguments.origin.x, 2, 1 )##repeatString( " ", arguments.cave.max.x - arguments.origin.x - 1 )#" );
    print.line( "#mid( arguments.cave.max.x, 2, 1 )#" );

    // Third line
    print.text( "#padRight( "", padding )##right( arguments.cave.min.x, 1 )##repeatString( " ", arguments.origin.x - arguments.cave.min.x - 1 )#" );
    print.text( "#right( arguments.origin.x, 1 )##repeatString( " ", arguments.cave.max.x - arguments.origin.x - 1 )#" );
    print.line( "#right( arguments.cave.max.x, 1 )#" );
    
    // Output
    for( var i = 0; i <= arguments.cave.max.y; i++ ) {
      print.text( padRight( padLeft( i, len( arguments.cave.max.y ) ), padding ) );
      for( var j = arguments.cave.min.x; j <= arguments.cave.max.x; j++ ) {
        if ( arguments.cave.sand.keyExists( "#j#,#i#" ) ) print.text( "o" );
        else if ( i == arguments.origin.y && j == arguments.origin.x ) print.text( "+" );
        else if ( arguments.cave.stones.keyExists( "#j#,#i#" ) ) print.text( "##" );
        else print.text( "." );
      }
      print.line();
    }
    print.line();
  }

  function padLeft( required string text, numeric length = 3 ) {
    var res = arguments.text;
    while( len( res ) <= arguments.length ) res = " " & res;
    return res;
  }

  function padRight( required string text, numeric length = 4 ) {
    var res = arguments.text;
    while( len( res ) <= arguments.length ) res &= " ";
    return res;
  }

  function abyss( required struct pos ) {
    return arguments.pos.y == variables.INFINITY;
  }
}
