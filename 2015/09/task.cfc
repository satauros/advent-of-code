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
    // Get graph
    var graph = readGraph( arguments.fileName );

    // Verbose
    print.greenLine( graph );

    // Done
    print.greenLine( "Part one:" );
	}

	function partTwo( required string fileName ) {
    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Close file
    fileClose( file );

    // Done
    print.greenLine( "Part two:" );
	}

  private array function readGraph( required string fileName ) {
    // Init
    var weights = {};

    // Contains list of cities
    var cities = createObject( "java", "java.util.TreeSet" ).init();

    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Process
    var line = ""; 
    while( !fileIsEOF( file ) ){
      line = fileReadLine( file );

      var from = listFirst( line, " " );
      var to = listGetAt( line, 3, " " );
      var weight = listLast( line, " " );

      cities.add( from );
      cities.add( to );

      weights[ from ][ to ] = weight;
      weights[ to ][ from ] = weight;
    }

    // Close file
    fileClose( file );

    // Convert to array
    cities = cities.toArray();

    // Init 
    var graph = arrayNew( 2 );
    for( var i = 1; i <= arrayLen( cities ); i++ ) {
      graph[ i ] = [];
    }

    // Build graph
    for( var i = 1; i <= arrayLen( cities ); i++ ) {
      var city = cities[ i ];
      for( var j = 1; j <= arrayLen( cities ); j++ ) {
        if( i == j ) graph[ i ][ j ] = 0;
        else graph[ i ][ j ] = val( weights[ city ][ cities[ j ] ] );
      }
    }

    // Done
    return graph;
  }

}
