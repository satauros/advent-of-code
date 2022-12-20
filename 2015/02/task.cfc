component {

	function solve( string fileName ) {
		// Get file
		var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		//
		var total = 0;

		//
		var ribbon = 0;

		//
		var line = "";
		while ( !fileIsEOF( file ) ) {
			// Read line
			line = fileReadLine( file );

			// Get dimensions
			var d = listToArray( line, "x" );

			// Map
			var areas = d.map( function( e, index ) {
				return e * d[ ( index % 3 ) + 1 ];
			} );

			// Calculate total
			total += (
				areas.reduce( function( result, e ) {
					total += ( 2 * e );
				}, total ) + areas.min()
			);

			// Calculate ribbon
			ribbon += (
				d.sort( "numeric" )
					.slice( 1, 2 )
					.reduce( function( r, e ) {
						return r + 2 * e;
					}, 0 ) + d.reduce( function( r, e ) {
					return r * e;
				}, 1 )
			);
		}

		// Done
		print.greenLine( "A total of #total# square feet of wrapping paper is required" );
		print.greenLine( "A total of #ribbon# feet of ribbon is required" );
	}

	function run() {
		solve( "input.txt" );
	}

	function example() {
		solve( "example.txt" );
	}

}
