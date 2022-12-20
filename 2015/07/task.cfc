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
    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Get circuit
    var circuit = getCircuit( file );

    // Close file
    fileClose( file );

    // Get first wire (a | d)
    var wire = circuit.keyArray().sort( "text" ).first();

    // Get signal
    var signal = getSignal( {}, circuit, wire );

    // Verbose
    print.greenLine( "Part one: the signal of wire #wire# is #signal#" );

    // Done
    return signal;
	}

	function partTwo( required string fileName ) {
    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Get circuit
    var circuit = getCircuit( file );

    // Close file
    fileClose( file );

    // Get first wire (a | d)
    var wire = circuit.keyArray().sort( "text" ).first();

    // Override 
    var res = { "b" : getSignal( {}, circuit, "a" ) };

    // Get signal
    var signal = getSignal( res, circuit, wire );

    // Verbose
    print.greenLine( "Part two: the signal of wire #wire# is #signal#" );
	}

  private struct function getCircuit( required any file ) {
    var circuit = {};
    while( !fileIsEOF( file )) {
      var line = replace( fileReadLine( file ), " -> ", "," );
      circuit[ listLast( line ) ] = listToArray( listFirst( line, "," ), " " );
    }
    return circuit;
  }

  private numeric function getSignal( required struct result, required struct circuit, required any wire ) {
    // Base case
    if( isNumeric( arguments.wire ) ) return val( arguments.wire );
    
    // Recursion
    if( !arguments.result.keyExists( arguments.wire ) ) {
      // Get instructions
      var instructions = arguments.circuit[ arguments.wire ];
      
      // Init
      var res = 0;

      // assignment
      if( instructions.len() == 1 ) {
        res = getSignal( arguments.result, arguments.circuit, instructions.first() );
      }
      // unary
      else if( instructions.len() == 2 ) {
        var p1 = getSignal( arguments.result, arguments.circuit, instructions.last() );
        res = bitNot( p1 ) + 65536;
      }
      // binary
      else {
        var p1 = getSignal( arguments.result, arguments.circuit, instructions.first() );
        var p2 = getSignal( arguments.result, arguments.circuit, instructions.last() );
        switch( instructions[ 2 ] ) {
          case "AND":
            res = bitAnd( p1, p2 );
            break;
          case "OR":
            res = bitOr( p1, p2 );
            break;
          case "LSHIFT":
            res = bitShln( p1, p2 );
            break;
          case "RSHIFT":
            res = bitShrn( p1, p2 );
            break;
        }
      }

      // Set result
      arguments.result[ arguments.wire ] = res;
    }

    // Done
    return arguments.result[ arguments.wire ];
  }
}
