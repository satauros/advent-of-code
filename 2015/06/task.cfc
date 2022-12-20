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
		var lights = [ [] ];
		arrayResize( lights, 1000 );
		for ( var i = 1; i <= lights.len(); i++ ) {
			lights[ i ] = [];
			arrayResize( lights[ i ], 1000 );
			for ( var j = 1; j <= lights[ i ].len(); j++ ) {
				lights[ i ][ j ] = false;
			}
		}

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			if ( line.startsWith( "turn on" ) ) {
				var begin = listGetAt( line, 3, " " );
				var end = listGetAt( line, 5, " " );

				for ( var x = val( listFirst( begin ) ); x <= val( listFirst( end ) ); x++ ) {
					for ( var y = val( listLast( begin ) ); y <= val( listLast( end ) ); y++ ) {
						lights[ x + 1 ][ y + 1 ] = true;
					}
				}
			} else if ( line.startsWith( "turn off" ) ) {
				var begin = listGetAt( line, 3, " " );
				var end = listGetAt( line, 5, " " );

				for ( var x = val( listFirst( begin ) ); x <= val( listFirst( end ) ); x++ ) {
					for ( var y = val( listLast( begin ) ); y <= val( listLast( end ) ); y++ ) {
						lights[ x + 1 ][ y + 1 ] = false;
					}
				}
			} else {
				var begin = listGetAt( line, 2, " " );
				var end = listGetAt( line, 4, " " );
				for ( var x = val( listFirst( begin ) ); x <= val( listFirst( end ) ); x++ ) {
					for ( var y = val( listLast( begin ) ); y <= val( listLast( end ) ); y++ ) {
						lights[ x + 1 ][ y + 1 ] = !lights[ x + 1 ][ y + 1 ];
					}
				}
			}
		}

		// Close file
		fileClose( file );

		// Calculate
		var total = 0;
		for ( var x = 1; x <= lights.len(); x++ ) {
			for ( var y = 1; y <= lights[ x ].len(); y++ ) {
				if ( lights[ x ][ y ] ) total++;
			}
		}

		// Done
		print.greenLine( "Part one : #total# light(s) are lit" );
	}


	function partTwo( required string fileName ) {
		// Open file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Init
		var lights = [ [] ];
		arrayResize( lights, 1000 );
		for ( var i = 1; i <= lights.len(); i++ ) {
			lights[ i ] = [];
			arrayResize( lights[ i ], 1000 );
			for ( var j = 1; j <= lights[ i ].len(); j++ ) {
				lights[ i ][ j ] = 0;
			}
		}

		// Process
		var line = "";
		while ( !fileIsEOF( file ) ) {
			line = fileReadLine( file );

			if ( line.startsWith( "turn on" ) ) {
				var begin = listGetAt( line, 3, " " );
				var end = listGetAt( line, 5, " " );

				for ( var x = val( listFirst( begin ) ); x <= val( listFirst( end ) ); x++ ) {
					for ( var y = val( listLast( begin ) ); y <= val( listLast( end ) ); y++ ) {
						lights[ x + 1 ][ y + 1 ]++;
					}
				}
			} else if ( line.startsWith( "turn off" ) ) {
				var begin = listGetAt( line, 3, " " );
				var end = listGetAt( line, 5, " " );

				for ( var x = val( listFirst( begin ) ); x <= val( listFirst( end ) ); x++ ) {
					for ( var y = val( listLast( begin ) ); y <= val( listLast( end ) ); y++ ) {
						if ( lights[ x + 1 ][ y + 1 ] - 1 >= 0 ) lights[ x + 1 ][ y + 1 ]--;
					}
				}
			} else {
				var begin = listGetAt( line, 2, " " );
				var end = listGetAt( line, 4, " " );
				for ( var x = val( listFirst( begin ) ); x <= val( listFirst( end ) ); x++ ) {
					for ( var y = val( listLast( begin ) ); y <= val( listLast( end ) ); y++ ) {
						lights[ x + 1 ][ y + 1 ] += 2;
					}
				}
			}
		}

		// Close file
		fileClose( file );

		// Calculate
		var total = 0;
		for ( var x = 1; x <= lights.len(); x++ ) {
			for ( var y = 1; y <= lights[ x ].len(); y++ ) {
				total += lights[ x ][ y ];
			}
		}

		// Done
		print.greenLine( "Part two : total brightness is #total#" );
	}

}
