const events = require('events');

SysTick = function(milliseconds) {
	__C_SysTick_init(milliseconds);
	return new events.EventEmitter();
};

SysTick_irq = function() {
	SysTick.emit('tick');
};