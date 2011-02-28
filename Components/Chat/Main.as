import it.unipmn.di.Meeting.components.Chat;

class MainChat {
	static var TITLE = "Chat v.1.0";

	static var CLASS = "it.unipmn.di.Meeting.components.Chat";

	private function foo(){
		var test:Chat = new Chat(_root);
		
	}
	
	// entry point
	static function main(mc) {
		mc.TITLE = MainChat.TITLE;
		mc.CLASS = MainChat.CLASS;
	}
}