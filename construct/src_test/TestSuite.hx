class TestSuite extends massive.munit.TestSuite
{		
	public function new()
	{
		super();

		add(persil.core.TestInject);
		add(persil.core.TestInjectById);
		add(persil.core.TestGetObject);
		add(persil.core.TestDynamic);
		add(persil.core.TestComplete);
		add(persil.core.TestAddObject);
		add(persil.core.TestFrontMessenger);
		add(persil.core.TestMessenger);
		add(persil.core.TestObserve);
		add(persil.core.TestMultipleConfigs);
		add(persil.core.TestMessengerExtension);
		add(persil.core.TestDestroy);
		add(persil.core.TestDynamicObject);
		add(persil.core.TestReflectUtil);
		add(persil.core.TestParentContext);
	}
}