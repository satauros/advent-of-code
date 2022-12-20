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

    // Init
    var i = 0; 

    // Lookup hash
    var res = hash( "#file##++i#" );
    while( !res.startsWith( "00000" ) ) {
      res = hash( "#file##++i#" );
    }

    // Done
    print.greenLine( "Part one : the lowest positive number that generates a hash with five leading zeroes is #i#" );

	}

	function partTwo( required string fileName ) {
    // Read file
    var file = fileRead( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Init
    var i = 0; 

    // Lookup hash
    var res = hash( "#file##++i#" );
    while( !res.startsWith( "000000" ) ) {
      res = hash( "#file##++i#" );
    }

    // Done
    print.greenLine( "Part two : the lowest positive number that generates a hash with six leading zeroes is #i#" );
	}

}
