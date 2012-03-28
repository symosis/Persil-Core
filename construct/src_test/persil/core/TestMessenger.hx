package persil.core;

import massive.munit.Assert;

import persil.core.extension.Messenger;

class TestMessenger
{
	private var completeCount : Int;

	@Before
	function before() : Void
	{
		completeCount = 0;
	}

	@Test
	function singleMessage()
	{
		var messenger = new Messenger();
		messenger.addReceiver(Message, incrementCompleteCount);
		messenger.send(new Message());

		Assert.areEqual(1, completeCount);
	}

	@Test
	function doubleAddListener()
	{
		var messenger = new Messenger();
		messenger.addReceiver(Message, incrementCompleteCount);
		messenger.addReceiver(Message, incrementCompleteCount);
		messenger.send(new Message());

		Assert.areEqual(1, completeCount);
	}

	@Test
	function doubleSend()
	{
		var messenger = new Messenger();
		messenger.addReceiver(Message, incrementCompleteCount);
		messenger.send(new Message());
		messenger.send(new Message());

		Assert.areEqual(2, completeCount);
	}

	private function incrementCompleteCount(message)
	{
		completeCount++;
	}
}

private class Message
{
	public function new(){}
}