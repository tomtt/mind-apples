function DomReadyHandler () {
	var dom_ready = false;
	var dom_load_queue = [];
	this.dom_load_queue = dom_load_queue;
	
	function add() {
		if (dom_ready) {
			run(arguments);
		}
		else {
			dom_load_queue.push(arguments);
		}
	}
	this.add = add;
	
	function run(argument_list) {
		args = [];
		args.push.apply(args, argument_list);
		var func = args.shift();
		func.apply(window, args);
	}
	
	function process_queue() {
		dom_ready = true;
		while (dom_load_queue.length > 0) {
			run(dom_load_queue.shift());
		}
		
	}
	
	$().ready(process_queue);
}

window.dom_ready_handler = new DomReadyHandler();

