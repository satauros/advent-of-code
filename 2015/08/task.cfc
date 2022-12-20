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

		// Init
		var total = 0;

		// Process
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// String representation
			total += len( line );

			// In-memory string value
			var i = 2;
			while ( i <= len( line ) - 1 ) {
				total -= 1;
				if ( i + 1 <= len( line ) - 1 && mid( line, i, 2 ) == "\x" ) i += 4;
				else if ( mid( line, i, 1 ) == "\" ) i += 2;
				else i += 1;
			}
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part one: #total#" );
	}

	function partTwo( required string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var total = 0;

		// Process
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// In-memory string value
			var count = 2;
			for ( var i = 1; i <= len( line ); i++ ) {
				count += 1;
				var char = mid( line, i, 1 );
				if ( asc( char ) == 34 || asc( char ) == 92 ) count += 1;
			}

			// Increment
			total += ( count - len( line ) );
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part two: #abs( total )#" );
	}

}
