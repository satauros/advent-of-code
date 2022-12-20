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
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var total = 0;

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// Use regex
			var nice = reFindNoCase( "(.*[aeiou]){3}", line ) != 0
				&& reFindNoCase( "(.)\1", line ) != 0
				&& reFindNoCase( "(ab|cd|pq|xy)", line ) == 0;

			// Done
			if ( nice ) total++;
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part one : there are #total# nice string(s)" );
	}

	function partTwo( required string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var total = 0;

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// Use regex
			var nice = reFindNoCase( "(..).*\1", line ) != 0
				&& reFindNoCase( "(.).\1", line ) != 0;

			// Done
			if ( nice ) total++;
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part two : there are #total# nice string(s)" );
	}

}
