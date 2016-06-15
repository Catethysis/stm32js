const events = require('events');

var uart = function(module, params, parser) {
	events.EventEmitter.call(this);
	var baudrate = 9600, byte_bits = 8, parity = 'N' /* N (no), O (odd), E (even), M (mark), S (space) */, stop_bits = 1;
	switch(typeof params) {
		case "number":
			baudrate   =  params;
			break;
		case "object":
			baudrate  |=  params.baudrate;
			byte_bits |=  params.byte_length;
			parity    |=  params.parity;
			stop_bits |=  params.stop_bits;
			break;
		case "string":
			params = params.split(/\/|-/);
			baudrate   = +params[0];
			byte_bits  =  params[1];
			parity     =  params[2];
			stop_bits  =  params[3];
			break;
	}
	// if(parser);
	this.split = parser.split.charCodeAt(0);
	__C_UART_Init(module, baudrate, byte_bits, parity.charCodeAt(0), stop_bits, this.split);
}

uart.prototype = Object.create(events.EventEmitter.prototype);

uart.prototype.send = function(data) {
	if(typeof data === 'string') data = data.split('');
	data = data.map(function(elem) { return typeof elem === 'string' ? elem.charCodeAt(0) : elem});
	__C_UART_Send(2, new Uint8Array(data), data.length, this.split);
}

var uart_data_irq = function(data) {
	uart.emit('data', data);
}

module.exports = uart;