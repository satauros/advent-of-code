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
		//partTwo( fileName );
	}

	function partOne( required string fileName ) {
    // Open file
    var file = fileOpen( getDirectoryFromPath( getCurrentTemplatePath() ) & arguments.fileName );

    // Init
    var monkeys = [];

    // Process monkeys
    var line = "";
    while( !fileIsEOF( file ) ) {
      fileReadLine( file ); // monkey definition
      var monkey = {};
      monkey.count = 0;
      line = fileReadLine( file ); // starting items
      monkey.items = listToArray( listLast( line, ":" ), ", " );
      line = fileReadLine( file ); // operation
      monkey.operation = trim( listLast( line, "=" ) );
      line = fileReadLine( file ); // test
      monkey.test = val( listLast( line, " " ) );
      line = fileReadLine( file ); // if true
      monkey.trec = val( listLast( line, " " ) ) + 1;
      line = fileReadLine( file ); // if false
      monkey.frec = val( listLast( line, " " ) ) + 1;
      if( !fileIsEOF( file ) ) fileReadLine( file );
      monkeys.add( monkey );
    }

    // Close file
    fileClose( file );

    for( var r = 1; r <= 20; r++ ) {
      monkeys.each( function( m, mi ) {
        var items = [];

        print.line("Monkey #mi - 1#:" );

        m.items.each( function( i, ii ) {
          print.line( "  Monkey inspects an item with worry level of #i#" );
          m.count++;
          var old = i;
          var level = evaluate( m.operation );
          print.line( "    Worry level is modified to #level#." );
          level = floor( level / 3 );
          print.line( "    Monkey gets bored with item. Worry level is divided by 3 to #level#." );
          if( level % m.test == 0 ) {
            print.line( "    Current worry level is divisible by #m.test#." );
            print.line( "    Item with worry level #level# is thrown to monkey #m.trec - 1#." );
            items.append({ "dst": m.trec, "new": level, "old" : i });
          }
          else {
            print.line( "    Current worry level is not divisible by #m.test#." );
            print.line( "    Item with worry level #level# is thrown to monkey #m.frec - 1#." );
            items.append({ "dst": m.frec, "new": level, "old" : i } );
          }
        } );

        print.line();

        items.each( function( i ) {
          m.items.delete( i.old );
          monkeys[ i.dst ].items.append( i.new );
        } );
      });
    }

    // Done
    print.greenLine( "Part one:" );
    monkeys.each( function( m, mi ) {
      print.blueLine( "Monkey #mi - 1# inspected items #m.count# times" );
    });

    // Get result
    var res = monkeys
      .map( function( e ) { return e.count; } )
      .sort( "numeric", "desc" )
      .slice( 1, 2 )
      .reduce( function( result, e ) {
        return result * e;
      }, 1 );

    // Done
    print.greenLine( "The level of monkey business after 20 rounds of stuff-slinging simian shenanigans #res#" );
	}

	function partTwo( required string fileName ) {
    // TODO
  }
}
