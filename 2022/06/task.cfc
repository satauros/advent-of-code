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
    // Read file
    var file = fileRead( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Execute
    var pos = getMarkerPosition( file, 4 );

    // Done
    print.greenLine( "Part one: first start-of-packet marker detected at position #pos#" );
	}

	function partTwo( required string fileName ) {
    // Read file
    var file = fileRead( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Execute
    var pos = getMarkerPosition( file, 14 );

    // Done
    print.greenLine( "Part two: first start-of-packet marker detected at position #pos#" );
	}

  function getMarkerPosition( required string line, required numeric lookBackLength ) {
    var i = arguments.lookBackLength;
    while( i <= len( arguments.line ) ) {
      var input = mid( arguments.line, i - arguments.lookBackLength + 1, arguments.lookBackLength );
      if( reFind( "(.).*\1", input ) == 0 ) break;
      i += 1;
    }
    return i;
  }

}
