const events = require('events');

var systick = function(milliseconds) {
	events.EventEmitter.call(this);
	__C_SysTick_init(milliseconds);
};

systick.prototype = Object.create(events.EventEmitter.prototype);

var systick_irq = function() {
	systick.emit('tick');
};

module.exports = systick;