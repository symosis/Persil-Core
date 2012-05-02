#if js
import js.Lib;
import js.Dom;
#end

import massive.munit.client.PrintClient;
import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.TestRunner;

class TestMain
{
	static function main()
	{
		new TestMain();
	}
	
	public function new()
	{
		var suites = new Array<Class<massive.munit.TestSuite>>();
		suites.push(TestSuite);
		
		#if MCOVER
			var client = new m.cover.coverage.munit.client.MCoverPrintClient();
		#else
			var client = new RichPrintClient();
		#end
		
		var runner:TestRunner = new TestRunner(client);
		runner.completionHandler = completionHandler;
		runner.run(suites);
	}

	function completionHandler(successful:Bool):Void
	{
		#if flash
            flash.external.ExternalInterface.call("testResult", successful);
        #elseif js
			js.Lib.eval("testResult(" + successful + ");");
		#end
	}
}
