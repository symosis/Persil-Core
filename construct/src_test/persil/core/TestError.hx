package persil.core;

import massive.munit.Assert;

class TestError
{
	@Test
	function contextNotNull()
	{
		try
		{
			var context = ContextBuilder.newBuilder().addConfig(TestConfigWithoutRTTI).build();

			Assert.fail("Expected Error");
		}
		catch (error : String)
		{
		}
	}
}

private class TestConfigWithoutRTTI
{
}
