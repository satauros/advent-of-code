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

    // Close file
    fileClose( file );

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

}
