component {

  variables.INFINITY = createObject( "java", "java.lang.Integer" ).MIN_VALUE;

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
    // Read input
    var valves = readValves( arguments.fileName );


	}


	function partTwo( required string fileName ) {
    // Done
    print.greenLine( "Part two:" );
	}

  function readValves( required string fileName ) {
    // Contains all valves
    var valves = {};

    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Process
    var line = ""; 
    while( !fileIsEOF( file ) ) {
      line = fileReadLine( file );
      // Create valve
      var v = {};
      v.name = listGetAt( line, 2, " " );
      v.rate = listGetAt( line, 6, " =;" );
      v.visited = false;
      // Add neighbours
      v.list = [];
      for( var i = 11; i <= listLen( line, " =;," ); i++ ) {
        v.list.append( listGetAt( line, i, " =;," ) );
      }
      // Add valve
      valves[ v.name ] = v;
    }

    // Close file
    fileClose( file );

    // Process
    valves.each( function( name, valve ) {
      arguments.valve.list = arguments.valve.list.map( function( e ) {
        return valves[ arguments.e ];
      } );
    } );

    // Done
    return valves;
  }

}
