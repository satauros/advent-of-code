component {

	function run() {
		var fileName = "input.txt";
		var tickCount = getTickCount();
		partOne( fileName );
		partTwo( fileName );
		print.yellowLine( "Solved in #getTickCount() - tickCount# ms" );
	}

	function example() {
		var fileName = "example.txt";
		partOne( fileName );
		partTwo( fileName );
	}

	function partOne( required string fileName ) {
		// Open file
		var file = fileRead( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

		// Path that was followed
		var path = { "0,0": 1 };

		// Current pos
		var currentPos = listFirst( path.keyList() );

		// Process file
    var instruction = "";
		for ( var i = 1; i <= file.len(); i++ ) {
			instruction = mid( file, i, 1 );

      // Move
      currentPos = move( currentPos, instruction );

			// Increment gift count
			if ( path.keyExists( currentPos ) ) {
				path[ "#currentPos#" ]++;
			} else path.append( { "#currentPos#": 1 } );
		}

		// Done
		print.greenLine( "Part one : #path.count()# house(s) got at least one present" );
	}

	function partTwo( required string fileName ) {
		// Open file
    var file = fileRead( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Path that was followed
    var path = { "0,0" : 1 };

    // Keep positions
    var sPos = listFirst( path.keyList() );
    var rPos = listFirst( path.keyList() );

    // Process file
    var instruction = "";
    for( var i = 1; i<= file.len(); i++ ) {
      instruction = mid( file, i, 1 );

      // Get current position
      var currentPos = i % 2 == 1 
        ? sPos
        : rPos;

      // Move
      currentPos = move( currentPos, instruction );
      
      // Increment gift count
			if ( path.keyExists( currentPos ) ) {
				path[ "#currentPos#" ]++;
			} else path.append( { "#currentPos#": 1 } );

      // Set current position
      if( i % 2 == 1 ) sPos = currentPos;
      else rPos = currentPos;
    }

    // Done
		print.greenLine( "Part two : #path.count()# house(s) got at least one present" );
	}

	function move( required string currentPos, required string instruction ) {
		// Get coordinates
		var x = val( listFirst( arguments.currentPos, "," ) );
		var y = val( listLast( arguments.currentPos, "," ) );

		// Determine next coordinate
		switch ( arguments.instruction ) {
			case "^":
				y++;
				break;
			case ">":
				x++;
				break;
			case "v":
				y--;
				break;
			case "<":
				x--;
				break;
		}

    // Done
    return "#x#,#y#";
	}

}
