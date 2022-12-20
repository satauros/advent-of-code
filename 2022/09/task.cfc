component {

	function run() {
		var fileName = "input.txt";
		var tickCount = getTickCount();
		partOne( fileName );
		partTwo( fileName );
		print.yellowLine( "Solved in #getTickCount() - tickcount# ms" );
	}

	function example() {
		var fileName = "example.txt";
		partOne( fileName );
		partTwo( fileName );
	}

	function partOne( required string fileName ) {
		// Initialize
		var state = { "head": { "x" : 0, "y": 0 }, "tail": { "x" : 0, "y" : 0 }, "label" : "== Initial State ==" };
 
		// Use Java's TreeSet
		var positions = createObject( "java", "java.util.TreeSet" );

		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Process
		var steps =  [];
		while ( !fileIsEOF( file ) ) {
			var line = fileReadLine( file );
			state = move(
				  state
				, listFirst( line, " " )
				, listLast( line, " " )
				, positions
			);
			steps.append( state );
		}

		// Close file
		fileClose( file );

		// Verbose
		verbose( steps );

		// Done
		print.greenLine( "Part one: the tail of the rope visits #arrayLen( positions.toArray() )# positions at least once" );
	}

	function partTwo( required string fileName ) {
	}

	function move(
		  required struct state
		, required string direction
		, required numeric count
		, required any visited
	) {
		// Get state
		var state = state.duplicate();

    // Set metadata
    state.label = "== #arguments.direction# #arguments.count# ==";

		// Process
		for ( var i = 1; i <= count; i++ ) {
			// Move head
			switch ( arguments.direction ) {
				case "L":
					// left
					state.head[ 2 ] = state.head[ 2 ] - 1;
					if ( abs( state.head[ 2 ] - state.tail[ 2 ] ) >= 2 ) state.tail[ 1 ] = state.head[ 1 ];
					if ( state.head[ 1 ] == state.tail[ 1 ] && state.tail[2] > state.head[2] ) state.tail[ 2 ] = state.head[ 2 ] + 1;
					break;
				case "R":
					// right
					state.head[ 2 ] = state.head[ 2 ] + 1;
					if ( abs( state.head[ 2 ] - state.tail[ 2 ] ) >= 2 ) state.tail[ 1 ] = state.head[ 1 ];
					if ( state.head[ 1 ] == state.tail[ 1 ] && state.tail[2] < state.head[2] ) state.tail[ 2 ] = state.head[ 2 ] - 1;
					break;
				case "U":
					// up
					state.head[ 1 ] = state.head[ 1 ] - 1;
					if ( abs( state.head[ 1 ] - state.tail[ 1 ] ) >= 2 ) state.tail[ 2 ] = state.head[ 2 ];
					if ( state.head[ 2 ] == state.tail[ 2 ] && state.tail[1] > state.head[1] ) state.tail[ 1 ] = state.head[ 1 ] + 1;
					break;
				case "D":
					// down
					state.head[ 1 ] = state.head[ 1 ] + 1;
					if ( abs( state.head[ 1 ] - state.tail[ 1 ] ) >= 2 ) state.tail[ 2 ] = state.head[ 2 ];
					if ( state.head[ 2 ] == state.tail[ 2 ] && state.tail[1] < state.head[1] ) state.tail[ 1 ] = state.head[ 1 ] - 1;
					break;
			}

      // Add position
      visited.add( arrayToList( state.tail ) );
		}

		// Done
		return state;
	}

	function verbose( states ) {
    // Output gets too large 
		if ( states.len() >= 10 ) return;

    // Init min / max values
    var i = createObject( "java", "java.lang.Integer" );
    var xMin = i.MAX_VALUE;
    var xMax = i.MIN_VALUE;
    var yMin = i.MAX_VALUE;
    var yMax = i.MIN_VALUE;
    local.delete( "i" );

    // Calculate min / max values with 1 iteration
    states.each( function( e ) {
      if( e.head.x <= xMin ) xMin = e.head.x;
      if( e.head.x >= xMax ) xMax = e.head.x;
      if( e.head.y <= yMin ) yMin = e.head.y;
      if( e.head.y >= xMax ) yMax = e.head.y;
    } );

    // Calculate the x-shift (left / right)
    var xShift = 0;
    if( xMin < 0 ) xShift = abs( xMin );

    // Calculate the y-shift (up / down)
    var yShift = 0;
    if( yMin < 0 ) yShift = abs( yMin );

    // Calculate boundaries
    var rows = 1 + yMax + yShift; // rows are 1-based
    var cols = 1 + xMax + xShift; // cols are 1-based

    // Output
		states.each( function( state, index ) {
      // Print label
      print.line( state.label );
      // Verbose
      print.yellow( "#state.head.x#,#state.head.y# => " );
      // Shift coordinates
      state.head = shift( state.head, xShift, yShift );
      state.tail = shift( state.tail, xShift, yShift );
      // Verbose
      print.yellowLine( "#state.head.x#,#state.head.y#" );
      continue;
      // Print contents
      for( var i = 1; i <= rows; i++ ) {
        for( var j = 1; j <= cols; j++ ) {
          // if( state.head.x + 1 == i && state.head.y + 1 == j ) print.redText( "H" );
          // else if( state.tail.x + 1 == i && state.tail.y + 1 == j ) print.redText( "T" );
          // else print.redText( "." );
          print.redText( "." );
        }
        print.line();
      }
      print.line();
    } );
  }

  function shift( pos, xShift, yShift ) {
    return pos;
  }
}