component {
  function run() {
    var tick = getTickCount();
    partOne( "input.txt" );
    print.yellowLine( "Solved in #getTickCount() - tick# ms" );
  }

  function example() {
    partOne( "example.txt" );
  }

  function spawn( required numeric type, numeric x = 0, numeric y = 0 ) {
    // init
    var res = [];

    // Process
    switch( arguments.type ) {
      case 1: 
        // XXXX
        res = [ p( arguments.x, arguments.y ), p( arguments.x + 1, arguments.y ), p( arguments.x + 2, arguments.y ), p( arguments.x + 3, arguments.y ) ];
        break;
      case 2:
        // .X.
        // XXX
        // .X.
        res = [ p( arguments.x + 1, arguments.y ), p( arguments.x, arguments.y + 1 ), p( arguments.x + 1, arguments.y + 1 ), p( arguments.x + 2, arguments.y + 1 ), p( arguments.x + 1, arguments.y + 2 ) ];
        break;
      case 3:
        // ..X
        // ..X
        // XXX
        res = [ p( arguments.x, arguments.y ), p( arguments.x + 1, arguments.y ), p( arguments.x + 2, arguments.y ), p( arguments.x + 2, arguments.y + 1 ), p( arguments.x + 2, arguments.y + 2 ) ];
        break;
      case 4:
        // X
        // X
        // X
        // X
        res = [ p( arguments.x, arguments.y ), p( arguments.x, arguments.y + 1 ), p( arguments.x, arguments.y + 2 ), p( arguments.x, arguments.y + 3 ) ];
        break;
      case 0:
        // XX
        // XX
        res = [ p( arguments.x, arguments.y ), p( arguments.x + 1, arguments.y ), p( arguments.x, arguments.y + 1 ), p( arguments.x + 1, arguments.y + 1 ) ];
        break;
    }
    
    // Done
    return res;
  }

  function left( required array piece ) {
    // Verify left boundary
    var filter = arguments.piece.filter( function( e ) {
      return arguments.e.x == 0;
    });

    // Can't go out of bounds
    if( filter.len() != 0 ) return arguments.piece;

    // Shift left
    return arguments.piece.map( function( e ) {
      return p( arguments.e.x - 1, arguments.e.y );
    } );    
  }

  function right( required array piece ) {
    // Verify right boundary
    var filter = arguments.piece.filter( function( e ) {
      return arguments.e.x == 6;
    } );

    // Can't go out of bounds
    if( filter.len() != 0 ) return arguments.piece;

    // Shift right
    return arguments.piece.map( function( e ) {
      return p( arguments.e.x + 1, arguments.e.y );
    } );
  }

  function down( required array piece ) {
    return arguments.piece.map( function( e ) { 
      return p( arguments.e.x, arguments.e.y - 1 );
    } );
  }

  function up( required array piece ) {
    return arguments.piece.map( function( e ) {
      return p( arguments.e.x, arguments.e.y + 1 );
    } );
  }

  function partOne( required string fileName ) {
    // Init
    var pieces = [];

    // Get jets
    var jets = readJets( arguments.fileName );

    // Define floor
    var floor = [];
    for( var i = 1; i <= 7; i++ ) {
      floor.append( p( i - 1, 0 ) );
    }

    // Floor height
    var fy = 0;

    // Execute
    for( var n = 1; n <= 10; n++ ) {
      // Get floor y
      fy = floor
        .map( function( e ) {
          return arguments.e.y;
        } )
        .max();

      // Get new piece
      var piece = spawn( n % 5, 2, fy + 3 );

      // Let the bodies hit ...
      while( true ) {
        // Get direction
        var direction = jets.pop();

        // Add direction
        jets.prepend( direction );

        // Left or right
        piece = invoke( this, direction == "<" ? "left" : "right", [ piece ] );

        // Down
        piece = down( piece );
       
        // Verify
        var filter = piece.filter( function( e ) {
          return arguments.e.y <= fy;
        } );

        // ... THE FLOOOOR
        if( filter.len() != 0 ) {
          floor = up( piece );
          pieces.add( piece );
          printPieces( pieces );
          break;
        }
      }
    }

    print.line( fy );
  }

  function readJets( required string fileName ) {
    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Read line
    var line = fileReadLine( file );

    // Close file
    fileClose( file );
    
    // Process
    var res = [];
    for( var i = len( line ); i >= 1; i-- ) {
      res.append( mid( line, i, 1 ) );
    }

    // Done
    return res;
  }

  function p( numeric x, numeric y ) {
    return { "x": arguments.x, "y": arguments.y };
  }

  function verbose( required array piece, numeric xOffset = 2, numeric yOffset = 3 ) {
    // Get min Y
    var minY = arguments.piece.map( function( e ) {
      return arguments.e.y;
    } ).min() - arguments.yOffset;

    // Get max Y
    var maxY = arguments.piece.map( function( e ) {
      return arguments.e.y;
    } ).max() - arguments.yOffset;

    // Get min X
    var minX = arguments.piece.map( function( e ) {
      return arguments.e.x;
    } ).min() - arguments.xOffset;

    // Get max X
    var maxX = arguments.piece.map( function( e ) {
      return arguments.e.x ;
    } ).max() - arguments.xOffset;

    // Print
    for( var i = maxY; i >= minY; i-- ) {
      for( var j = minX; j <= maxX; j++ ) {
        if( arguments.piece.find( { "x": j + arguments.xOffset, "y": i + arguments.yOffset } ) ) print.text( "X" );
        else print.text( "." );
      }
      print.line();
    }
    print.line();
  }

  function printPieces( required array pieces ) {
    arguments.pieces.each( function( p ) {
      // Get min Y
      var minY = arguments.p.map( function( e ) {
        return arguments.e.y;
      } ).min();

      // Get max Y
      var maxY = arguments.p.map( function( e ) {
        return arguments.e.y;
      } ).max();

      // Print
      for( var i = maxY; i >= minY; i-- ) {
        for( var j = 0; j <= 6; j++ ) {
          if( arguments.p.find( { "x": j, "y": i } ) ) print.text( "X" );
          else print.text( "." );
        }
        print.line();
      }
    } );
    print.line().line();
  }
}