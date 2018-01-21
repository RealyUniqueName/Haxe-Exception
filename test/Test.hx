import utest.ui.Report;

class Test {
	static public function main() {
		var runner = new utest.Runner();
		Report.create(runner);
		runner.addCases('cases');
		runner.run();
	}
}

