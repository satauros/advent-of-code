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

    // Read instructions
    var instructions = [];
    while( !fileIsEOF( file ) ) {
      var line = fileReadLine( file );
      // Create default instruction
      var instruction = { "cycle" : 1, "value" : 0 }; // noop
      // Add stack
      if( listLen( line, " " ) != 1 ) instruction = { "cycle" : 2, "value" : listLast( line, " " ) }; // addx
      // Add instruction
      instructions.prepend( instruction );
    }

    // Close file
    fileClose( file );

    // Init
    var signals = [];

    // Register
    var x = 1;

    // Run instructions
    var j = 1;
    while( !instructions.isEmpty() ) {
      // Get instruction
      var i = instructions.last();
      // Decrement
      i.cycle--;
      // Verbose
      if( j++ % 40 == 20 ) signals.append( ( j - 1 ) * x );
      // Execute instruction
      if( i.cycle == 0 ) x += instructions.pop().value;
    }

    // Done
    print.greenLine( "Part one: #arraySum( signals )#" );
	}

	function partTwo( required string fileName, boolean verbose = false ) {
    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Read instructions
    var instructions = [];
    while( !fileIsEOF( file ) ) {
      var line = fileReadLine( file );
      // Create default instruction
      var instruction = { "cycle" : 1, "value" : 0 }; // noop
      // Add stack
      if( listLen( line, " " ) != 1 ) instruction = { "cycle" : 2, "value" : listLast( line, " " ) }; // addx
      // Add instruction
      instructions.prepend( instruction );
    }

    // Close file
    fileClose( file );

    // Register
    var x = 1;

    // Set sprite
    var s = [ 0, 2 ]; 

    // Output
    var row = "";

    // Result
    var rows = [];

    // Verbose
    if( verbose ) {
      printSprite( s );
      print.line();
    }

    // Run instructions
    var j = 0;
    while( !instructions.isEmpty() && ++j ) {
      // Get instruction
      var i = instructions.last();
      // Build row
      var pos = ( j - 1 ) % 40;
      if( pos >= s[1] && pos <= s[2] ) row &= "##";
      else row &= ".";
      // Verbose
      if( verbose ) {
        if( i.cycle - 1 != 0 ) print.line("Start cycle #j#: begin executing #i.value ? "addx #i.value#" : "noop"#" );
        print.line( "During cycle #j#: CRT draws pixel in position #pos#" );
        print.line( "Current CRT row: #row#" );
      }
      // Execution cycle
      if( --i.cycle == 0 ) { 
        // Execute
        x += instructions.pop().value;
        // Adjust sprite position
        if( i.value ) { 
          // Set new sprite position
          s = [ x - 1, x + 1 ];
          // Verbose
          if( verbose ) {
            print.line( "End of cycle #j#: finish executing #i.value ? "addx #i.value# (Register X is now #x#)" : "noop"#" );
            printSprite( s );
          }
        }
      }
      // Verbose
      if ( verbose ) print.line();
      // EOL
      if( j % 40 == 0 ) { 
        rows.append( row ); 
        row = ""; 
      }
    }

    // Done
    print.greenLine( "Part two:" );
    rows.each( function( r ) {
      print.line( r );
    });
	}

  function printSprite( s ) {
    print.text( "Sprite position: " )
    for( var c = 0; c <= 39; c++) { 
      if( c >= s[1] && c <= s[2] ) print.text( "##" );
      else print.text( "." );
    }
    print.line();
  }

}
