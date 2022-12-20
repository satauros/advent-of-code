component {

  variables.verbose = false;

	function run() {
		var fileName = "input.txt";
		var tickCount = getTickCount();
    variables.verbose = false;
		partOne( fileName, 2000000 );
		partTwo( fileName );
		print.yellowLine( "Solved in #getTickCount() - tickcount# ms" );
	}

	function example() {
		var fileName = "example.txt";
    variables.verbose = true;
		partOne( fileName, 10 );
		partTwo( fileName );
	}

	function partOne( required string fileName, numeric row = 10 ) {
    // Get grid
    var grid = readGrid( arguments.fileName );

    // Fire each sensor
    sonar( grid );

    // Verbose
    printGrid( grid );

    // Get count
    var count = 0;
    for( var x = grid.min.x; x <= grid.max.x; x++ ) {
      if( grid.keyExists( "#x#,#arguments.row#" ) && grid[ "#x#,#arguments.row#" ] == "##" ) {
        count++;
      }
    }
    
    // Done
    print.green( "Part one: in the row where y=" ).blueText( arguments.row ).greenText(" there are " ).yellowText( count ).greenLine( " positions where a beacon cannot be present" );
	}

	function partTwo( required string fileName ) {
    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Close file
    fileClose( file );

    // Done
    print.greenLine( "Part two:" );
	}

  function readGrid( required string fileName ) {
    // Init result
    var res = {};
    res.sensors = [];

    // Init
    var x = createObject( "java", "java.util.TreeSet" );
    var y = createObject( "java", "java.util.TreeSet" );

    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Process
    var line = ""; 
    while( !fileIsEOF( file ) ) {
      line = fileReadLine( file );
      // Get sensor
      var s = { "x": val( listGetAt( line, 4, " ,=:" ) ), "y": val( listGetAt( line, 6, " ,=:" ) ) };
      x.add( s.x );
      y.add( s.y );
      res[ "#s.x#,#s.y#" ] = "S";
      // Get beacon
      s.beacon = { "x": val( listGetAt( line, 12, " ,=:" ) ), "y": val( listGetAt( line, 14, " ,=:" ) ) };
      x.add( s.beacon.x );
      y.add( s.beacon.y );
      res[ "#s.beacon.x#,#s.beacon.y#" ] = "B";
      // Add sensor
      res.sensors.append( s );
    }

    // Close file
    fileClose( file );

    // Add metadata
    res.min = { "x": x.first(), "y": y.first() };
    res.max = { "x": x.last(), "y": y.last() };

    // Done
    return res;
  }

  function d( required struct pos1, required struct pos2 ) {
    return abs( arguments.pos1.x - arguments.pos2.x ) + abs( arguments.pos1.y - arguments.pos2.y );
  }

  function sonar( required struct grid ) {
    arguments.grid.sensors.each( function( s ) {
      pulse( arguments.s, grid );
    } );
  }

  function pulse( required struct sensor, required struct grid ) {
    // Get distance to beacon
    var dist = d( arguments.sensor, arguments.sensor.beacon );

    // Adjust grid boundaries
    if( variables.verbose ) {
      grid.min.x = min( grid.min.x, arguments.sensor.x - dist );
      grid.max.x = max( grid.max.x, arguments.sensor.x + dist );
      grid.min.y = min( grid.min.y, arguments.sensor.y - dist );
      grid.max.y = max( grid.max.y, arguments.sensor.y + dist );
    }

    // Pulse
    for( var n = 0; n <= dist; n++ ) {
      for( var i = -n; i <= n; i++ ) {
        var x = arguments.sensor.x - i;
        var y = arguments.sensor.y - dist + n;
        if( !arguments.grid.keyExists( "#x#,#y#" ) ) arguments.grid[ "#x#,#y#" ] = "##";
        x = arguments.sensor.x - i;
        y = arguments.sensor.y + dist -n;
        if( !arguments.grid.keyExists( "#x#,#y#" ) ) arguments.grid[ "#x#,#y#" ] = "##";
      }
    }
  }
  
  function printGrid( required struct grid ) {
    // Don't print 
    if( !variables.verbose ) return;

    // Determine padding
    var padding = len( arguments.grid.max.y ) + 1;

    // Upper header row
    print.text( padRight( padLeft( "", len( arguments.grid.max.y ) ), padding ) );
    for( var h = arguments.grid.min.x; h <= arguments.grid.max.x; h++ ) {
      if( h % 5 == 0 && h - arguments.grid.min.x >= 10 ) print.text( left( h, 1 ) );
      else print.text( " " );
    }
    print.line();

    // Lower header row
    print.text( padRight( padLeft( "", len( arguments.grid.max.y ) ), padding ) );
    for( var h = arguments.grid.min.x; h <= arguments.grid.max.x; h++ ) {
      if( h % 5 == 0 ) print.text( right( h, 1 ) );
      else print.text( " " );
    }
    print.line();

    // Output
    for( var i = arguments.grid.min.y; i <= arguments.grid.max.y; i++ ) {
      print.text( padRight( padLeft( i, len( arguments.grid.max.y ) ), padding ) );
      for( var j = arguments.grid.min.x; j <= arguments.grid.max.x; j++ ) {
        if( arguments.grid.keyExists( "#j#,#i#" ) ) print.text( arguments.grid[ "#j#,#i#" ] );
        else print.text( "." );
      }
      print.line();
    }
    print.line();
  }
  
  function padLeft( required string text, numeric length = 3 ) {
    var res = arguments.text;
    while( len( res ) <= arguments.length ) res = " " & res;
    return res;
  }

  function padRight( required string text, numeric length = 4 ) {
    var res = arguments.text;
    while( len( res ) <= arguments.length ) res &= " ";
    return res;
  }

}