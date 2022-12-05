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
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			// Get sections as arrays
			var sectionOne = getSections( listFirst( line ) );
			var sectionTwo = getSections( listLast( line ) );

			// Use Java's 'containsAll' collection method
			if ( sectionOne.containsAll( sectionTwo ) || sectionTwo.containsAll( sectionOne ) ) total++;
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part one : #total# assignment pair(s) fully contain the other" );
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

			// Get sections as arrays
			var sectionOne = getSections( listFirst( line ) );
			var sectionTwo = getSections( listLast( line ) );

			// Get intersection using Java's 'retainAll' collection method
			sectionOne.retainAll( sectionTwo );

			// Verify
			if ( !sectionOne.isEmpty() ) total++;
		}

		// Close file
		fileClose( file );

		// Done
		print.greenLine( "Part two : the number of overlapping assignment pairs is #total#" );
	}

	function getSections( required string boundaries ) {
		var result = [];
		for ( var i = val( listFirst( arguments.boundaries, "-" ) ); i <= val( listLast( arguments.boundaries, "-" ) ); i++ ) {
			result.append( i );
		}
		return result;
	}

}
